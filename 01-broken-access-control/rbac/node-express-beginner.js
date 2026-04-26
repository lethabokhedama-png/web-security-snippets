// Feature        : Role-Based Access Control (RBAC) — Express middleware
// Language       : Node.js 20
// Framework      : Express 4.19
// Level          : Beginner
// OWASP          : A01 — Broken Access Control
// Protects       : Against users accessing routes above their permission level
// Does NOT cover : Permission-level granularity, attribute-based rules
// Dependencies   : See package.json in this folder
// Tested on      : Node.js 20.14.0, Express 4.19.2, jsonwebtoken 9.0.2
// Last reviewed  : 2024-06-01

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// HOW THIS WORKS
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Express middleware runs before your route handlers.
// requireRole("admin") creates a middleware function that:
//   1. Reads the JWT from the Authorization header
//   2. Verifies it was signed by your server
//   3. Checks that the role in the token meets the required level
//   4. Either calls next() (passes to your handler) or sends 403
//
// REPLACE THESE VALUES:
//   process.env.JWT_SECRET_KEY → set this in your .env file or environment
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

const express = require('express');
const jwt = require('jsonwebtoken'); // install via package.json

const app = express();
app.use(express.json());

// Load the secret from environment — never hardcode this
const JWT_SECRET = process.env.JWT_SECRET_KEY;

// Define role levels — higher number = more access
// A user with a higher role can access routes requiring a lower one
const ROLE_LEVELS = {
  viewer:    1,
  editor:    2,
  moderator: 3,
  admin:     4,
};


// ── THE MIDDLEWARE ────────────────────────────────────────
/**
 * requireRole(minimumRole)
 *
 * Returns an Express middleware that blocks the request if the
 * authenticated user does not have at least the minimum role.
 *
 * Usage:
 *   app.delete('/posts/:id', requireRole('editor'), deletePost);
 *   app.get('/admin/users', requireRole('admin'), listUsers);
 */
function requireRole(minimumRole) {
  return function (req, res, next) {

    // Step 1: Extract the token from the Authorization header
    // Header format: "Authorization: Bearer <your-token-here>"
    const authHeader = req.headers['authorization'] || '';

    if (!authHeader.startsWith('Bearer ')) {
      // No token at all — the user has not logged in
      return res.status(401).json({ error: 'Authentication required' });
    }

    const token = authHeader.slice(7); // everything after "Bearer "

    // Step 2: Verify the token signature and decode the payload
    // jwt.verify will throw if the token is expired, tampered, or fake
    let payload;
    try {
      payload = jwt.verify(token, JWT_SECRET, { algorithms: ['HS256'] });
    } catch (err) {
      if (err.name === 'TokenExpiredError') {
        return res.status(401).json({ error: 'Token has expired — please log in again' });
      }
      // InvalidSignatureError, JsonWebTokenError, etc.
      return res.status(401).json({ error: 'Invalid token' });
    }

    // Step 3: Read the role from the verified token
    const userRole = payload.role;

    if (!(userRole in ROLE_LEVELS)) {
      // Token has a role we do not recognise — reject it
      return res.status(403).json({ error: 'Unknown role in token' });
    }

    // Step 4: Compare the user's role level to the minimum required
    if (ROLE_LEVELS[userRole] < ROLE_LEVELS[minimumRole]) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        required: minimumRole,
        yours: userRole,
      });
    }

    // Step 5: Attach the decoded user to the request object
    // Your route handlers can now access req.user without decoding the token again
    req.user = {
      userId: payload.sub,
      email:  payload.email,
      role:   userRole,
    };

    // All checks passed — hand off to the route handler
    next();
  };
}


// ── EXAMPLE ROUTES ────────────────────────────────────────
// Any logged-in user can view posts
app.get('/posts', requireRole('viewer'), (req, res) => {
  res.json({ message: 'Post list', viewer: req.user.email });
});

// Only editors and above can create posts
app.post('/posts', requireRole('editor'), (req, res) => {
  res.json({ message: 'Post created by', user: req.user.userId });
});

// Only admins can access user management
app.get('/admin/users', requireRole('admin'), (req, res) => {
  res.json({ message: 'Admin-only user list' });
});


// ── GENERATE A TEST TOKEN (dev only) ──────────────────────
// In production this lives in your login route.
// Remove or protect this endpoint before deploying.
app.post('/dev/token', (req, res) => {
  const { userId, email, role } = req.body;
  const token = jwt.sign(
    { sub: userId, email, role },
    JWT_SECRET,
    { algorithm: 'HS256', expiresIn: '1h' }
  );
  res.json({ token });
});


app.listen(3000, () => console.log('Running on http://localhost:3000'));
module.exports = { requireRole }; // export for testing
