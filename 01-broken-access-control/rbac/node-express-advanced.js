// Feature        : Role-Based Access Control (RBAC) — Permission-scoped Express middleware
// Language       : Node.js 20
// Framework      : Express 4.19
// Level          : Advanced
// OWASP          : A01 — Broken Access Control
// Protects       : Granular permission enforcement with role-to-permission mapping
// Does NOT cover : Attribute-based rules, field-level filtering
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.14.0, Express 4.19.2, jsonwebtoken 9.0.2
// Last reviewed  : 2024-06-01

'use strict';

const express = require('express');
const jwt     = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET_KEY;

const ROLE_PERMISSIONS = Object.freeze({
  viewer:   new Set(['posts:read']),
  editor:   new Set(['posts:read', 'posts:write']),
  moderator:new Set(['posts:read', 'posts:write', 'posts:delete', 'users:read']),
  admin:    new Set(['posts:read', 'posts:write', 'posts:delete', 'users:read', 'users:write', 'users:delete', 'billing:read']),
});

function extractUser(req) {
  const header = req.headers['authorization'] || '';
  if (!header.startsWith('Bearer ')) throw Object.assign(new Error('missing_token'), { status: 401 });
  try {
    const payload = jwt.verify(header.slice(7), JWT_SECRET, { algorithms: ['HS256'] });
    const perms = ROLE_PERMISSIONS[payload.role] ?? new Set();
    return { userId: payload.sub, role: payload.role, permissions: perms };
  } catch (e) {
    throw Object.assign(new Error(e.name === 'TokenExpiredError' ? 'expired_token' : 'invalid_token'), { status: 401 });
  }
}

function requirePermission(...required) {
  const requiredSet = new Set(required);
  return (req, res, next) => {
    try {
      req.user = extractUser(req);
    } catch (e) {
      return res.status(e.status || 401).json({ error: e.message });
    }
    const missing = [...requiredSet].filter(p => !req.user.permissions.has(p));
    if (missing.length) {
      return res.status(403).json({ error: 'forbidden', missing });
    }
    next();
  };
}

const app = express();
app.use(express.json());

app.delete('/posts/:id', requirePermission('posts:delete'), (req, res) => {
  res.json({ deleted: req.params.id, by: req.user.userId });
});

app.get('/admin/users', requirePermission('users:read'), (req, res) => {
  res.json({ users: [] });
});

module.exports = { requirePermission };
