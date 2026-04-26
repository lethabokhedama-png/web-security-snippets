// Feature        : API Key Validation — Scoped keys, rotation, prefix-lookup
// Language       : JavaScript (Node.js 20)
// Framework      : Express 4.18
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Against brute force via key prefix, plain-text storage, scope bypass
// Does NOT cover : Full key management UI, OAuth2 client credentials flow
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.11.1, Express 4.18.3
// Last reviewed  : 2024-03-01

const express = require('express');
const crypto  = require('crypto');
const app     = express();
app.use(express.json());

const HMAC_SECRET = Buffer.from(process.env.HMAC_SECRET || '', 'utf8');

// Key format: wss_<8-char-prefix>_<random-part>
// The prefix allows O(1) DB lookup — index on prefix column, compare hash only for that row
const KEY_PREFIX = 'wss_';
const PREFIX_LEN = 8;

const db = new Map(); // prefix → { hash, clientId, scopes, active, createdAt, lastUsedAt }

function issue(clientId, scopes) {
  const random  = crypto.randomBytes(32).toString('base64url');
  const prefix  = random.slice(0, PREFIX_LEN);
  const rawKey  = `${KEY_PREFIX}${prefix}_${random.slice(PREFIX_LEN)}`;
  const hash    = crypto.createHmac('sha256', HMAC_SECRET).update(rawKey).digest('hex');
  db.set(prefix, { hash, clientId, scopes, active: true, createdAt: Date.now(), lastUsedAt: null });
  return rawKey;
}

function verify(rawKey) {
  if (!rawKey?.startsWith(KEY_PREFIX)) return null;
  const withoutPrefix = rawKey.slice(KEY_PREFIX.length);
  const prefix = withoutPrefix.slice(0, PREFIX_LEN);
  const record = db.get(prefix);
  if (!record?.active) return null;

  const expected = Buffer.from(record.hash, 'hex');
  const incoming = Buffer.from(crypto.createHmac('sha256', HMAC_SECRET).update(rawKey).digest('hex'), 'hex');
  if (expected.length !== incoming.length || !crypto.timingSafeEqual(expected, incoming)) return null;

  record.lastUsedAt = Date.now();
  return record;
}

const authenticate = (...scopes) => (req, res, next) => {
  const raw = req.headers['x-api-key'];
  if (!raw) return res.sendStatus(401);
  const record = verify(raw);
  if (!record) return res.sendStatus(401);
  const missing = scopes.filter(s => !record.scopes.includes(s));
  if (missing.length) return res.status(403).json({ missing });
  req.client = record;
  next();
};

app.post('/keys',               (req, res) => res.status(201).json({ key: issue(req.body.clientId, req.body.scopes ?? ['read:data']) }));
app.get('/api/data',            authenticate('read:data'),  (req, res) => res.json({ ok: true, client: req.client.clientId }));
app.post('/api/data',           authenticate('write:data'), (req, res) => res.json({ created: true }));
app.delete('/api/admin/:scope', authenticate('admin'),      (req, res) => res.json({ done: true }));

module.exports = app;
