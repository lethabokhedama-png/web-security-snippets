// Feature        : Attribute-Based Access Control (ABAC) — Express policy middleware
// Language       : JavaScript (Node.js 20)
// Framework      : Express 4.18
// Level          : Intermediate
// OWASP          : A01 — Broken Access Control
// Protects       : Against context-blind access — enforces rules on user, resource, and environment
// Does NOT cover : External policy engines, XACML, distributed PDP
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.11.1, Express 4.18.3, jsonwebtoken 9.0.2
// Last reviewed  : 2024-03-01

const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();
app.use(express.json());

const SECRET_KEY = process.env.SECRET_KEY;

// ── Policy definitions ────────────────────────────────────────────────────────

const policies = {
  canRead(subject, resource, env) {
    if (resource.status === 'published' && subject.clearance >= resource.clearanceRequired)
      return [true, 'published with sufficient clearance'];
    if (resource.ownerId === subject.userId)
      return [true, 'owner'];
    if (['editor', 'admin'].includes(subject.role))
      return [true, 'editor/admin'];
    return [false, 'no matching read policy'];
  },

  canEdit(subject, resource, env) {
    if (resource.status === 'archived')
      return [false, 'archived documents are immutable'];
    if (resource.ownerId === subject.userId && resource.status === 'draft')
      return [true, 'owner editing draft'];
    if (subject.role === 'admin' && env.isBusinessHours && subject.mfaVerified)
      return [true, 'admin during business hours with MFA'];
    return [false, 'no matching edit policy'];
  },

  canDelete(subject, resource, env) {
    if (subject.role !== 'admin') return [false, 'admin required'];
    if (!subject.mfaVerified)     return [false, 'MFA required'];
    return [true, 'admin with MFA'];
  },
};

// ── Middleware factories ───────────────────────────────────────────────────────

function authenticate(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Token required' });
  try {
    const payload = jwt.verify(token, SECRET_KEY, { algorithms: ['HS256'] });
    req.subject = {
      userId: payload.sub,
      role: payload.role ?? 'viewer',
      department: payload.department ?? 'general',
      mfaVerified: payload.mfa_verified ?? false,
      clearance: payload.clearance ?? 1,
    };
    next();
  } catch {
    res.status(401).json({ error: 'Invalid token' });
  }
}

function buildEnvironment(req) {
  const now = new Date();
  const hour = now.getUTCHours();
  const day  = now.getUTCDay();
  return {
    isBusinessHours: hour >= 9 && hour < 18 && day > 0 && day < 6,
    ip: req.ip,
    timestamp: now,
  };
}

// policyFn: (subject, resource, environment) => [allowed, reason]
// getResource: async (req) => ResourceAttributes
function abac(policyFn, getResource) {
  return async (req, res, next) => {
    const resource = await getResource(req);
    const env      = buildEnvironment(req);
    const [allowed, reason] = policyFn(req.subject, resource, env);

    if (!allowed) return res.status(403).json({ error: 'Access denied', reason });

    req.resource = resource;
    next();
  };
}

// ── Resource loaders (replace with DB calls) ──────────────────────────────────

async function loadDocument(req) {
  return {
    id: req.params.docId,
    ownerId: 'user_42',
    status: 'draft',
    clearanceRequired: 1,
  };
}

// ── Routes ────────────────────────────────────────────────────────────────────

app.get(   '/documents/:docId', authenticate, abac(policies.canRead,   loadDocument), (req, res) => res.json({ doc: req.resource.id }));
app.patch( '/documents/:docId', authenticate, abac(policies.canEdit,   loadDocument), (req, res) => res.json({ updated: req.resource.id }));
app.delete('/documents/:docId', authenticate, abac(policies.canDelete, loadDocument), (req, res) => res.json({ deleted: req.resource.id }));

app.listen(3000);
module.exports = app;
