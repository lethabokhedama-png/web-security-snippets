// Feature        : API Key Validation — Express middleware
// Language       : JavaScript (Node.js 20)
// Framework      : Express 4.18
// Level          : Beginner
// OWASP          : A01 — Broken Access Control
// Protects       : Against unauthorised API access; hashed key storage prevents plain-text exposure
// Does NOT cover : Key rotation, per-endpoint scoping beyond basic, UI for key management
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.11.1, Express 4.18.3
// Last reviewed  : 2024-03-01

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// REPLACE THESE BEFORE USING:
//   HMAC_SECRET → a 32+ character random string in process.env.HMAC_SECRET
//                 generate: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

const express = require('express');
const crypto  = require('crypto');
const app     = express();
app.use(express.json());

// Load from environment — never hardcode
const HMAC_SECRET = process.env.HMAC_SECRET || 'REPLACE_WITH_YOUR_HMAC_SECRET';

// Simulated database — replace with real DB calls in production
const apiKeyStore = new Map(); // hash → { clientId, scopes, active }


function generateApiKey() {
  // 32 bytes = 256 bits — URL-safe base64 encoding
  return crypto.randomBytes(32).toString('base64url');
}

function hashApiKey(rawKey) {
  // HMAC-SHA256 binds the hash to the server secret
  // Without the secret, the hash cannot be reproduced
  return crypto.createHmac('sha256', HMAC_SECRET).update(rawKey).digest('hex');
}

function lookupApiKey(rawKey) {
  const incoming = hashApiKey(rawKey);
  for (const [stored, record] of apiKeyStore.entries()) {
    // timingSafeEqual prevents timing attacks — always use it for secret comparisons
    const storedBuf   = Buffer.from(stored,   'hex');
    const incomingBuf = Buffer.from(incoming, 'hex');
    if (storedBuf.length === incomingBuf.length &&
        crypto.timingSafeEqual(storedBuf, incomingBuf)) {
      return record.active ? record : null;
    }
  }
  return null;
}

/**
 * requireApiKey middleware
 *
 * Reads the X-API-Key header, validates the key, and optionally checks scopes.
 * Attach to any route that should require API key authentication.
 *
 * Usage:
 *   app.get('/data', requireApiKey(['read:data']), handler)
 *   app.post('/data', requireApiKey(['write:data']), handler)
 */
function requireApiKey(scopes = []) {
  return (req, res, next) => {
    // X-API-Key header — never accept keys in query strings (they appear in logs)
    const rawKey = req.headers['x-api-key'];
    if (!rawKey) {
      return res.status(401).json({ error: 'API key required. Use X-API-Key header.' });
    }

    const record = lookupApiKey(rawKey);
    if (!record) {
      return res.status(401).json({ error: 'Invalid or revoked API key.' });
    }

    // Check required scopes
    if (scopes.length > 0) {
      const missing = scopes.filter(s => !record.scopes.includes(s));
      if (missing.length > 0) {
        return res.status(403).json({ error: 'Insufficient scope.', missing });
      }
    }

    req.apiClient = record;
    next();
  };
}

// ── Key management routes ─────────────────────────────────────────────────────

app.post('/api-keys', (req, res) => {
  const { clientId, scopes = ['read:data'] } = req.body;
  if (!clientId) return res.status(400).json({ error: 'clientId required' });

  const rawKey = generateApiKey();
  const hash   = hashApiKey(rawKey);

  apiKeyStore.set(hash, { clientId, scopes, active: true });

  res.status(201).json({
    apiKey: rawKey,
    clientId,
    scopes,
    warning: 'Store this key securely. It will not be shown again.',
  });
});

app.delete('/api-keys/:clientId', (req, res) => {
  let revoked = 0;
  for (const record of apiKeyStore.values()) {
    if (record.clientId === req.params.clientId && record.active) {
      record.active = false;
      revoked++;
    }
  }
  res.json({ revoked, clientId: req.params.clientId });
});

// ── Protected routes ──────────────────────────────────────────────────────────

app.get('/api/data',  requireApiKey(['read:data']),  (req, res) => res.json({ data: [], client: req.apiClient.clientId }));
app.post('/api/data', requireApiKey(['write:data']), (req, res) => res.json({ created: true, client: req.apiClient.clientId }));

app.listen(3000);
module.exports = app;
