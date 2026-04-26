# API Key Validation

**OWASP:** A01 — Broken Access Control
**Risk Level:** High
**Applies to:** APIs that serve machine-to-machine clients, third-party integrations, or developer platforms

---

## What Are API Keys and Why Do They Need Secure Handling?

API keys are credentials issued to clients — applications, scripts, or services — to authenticate API requests. Unlike username/password pairs, they are typically long random strings that are passed in a request header and validated by the server on every call.

API keys appear simple but their security depends entirely on how they are generated, stored, transmitted, and validated. A poorly implemented API key system is worse than no system at all because it creates a false sense of security.

---

## The Four Problems This Section Solves

**Generation:** API keys must be cryptographically random. A key generated with a predictable seed can be guessed. Keys must be long enough that brute force is computationally infeasible — a minimum of 32 bytes of entropy, typically represented as a 64-character hex string or a base64url string.

**Storage:** API keys must never be stored in plain text. If your database is compromised, plain-text keys give the attacker immediate access to every client's account. Keys must be hashed before storage — but unlike passwords, they cannot use slow hashing algorithms because key validation happens on every API request and must be fast. HMAC-SHA256 with a server-side secret is the standard approach.

**Transmission:** Keys must only be transmitted over HTTPS. They must be passed in headers (`Authorization: Bearer <key>` or `X-API-Key: <key>`), never in URLs. URLs appear in server logs, browser history, and referrer headers. A key in a URL is a key that has already been leaked.

**Scoping:** A key should grant access only to what it needs to. An API key for reading analytics data should not be able to delete users. Key scopes define exactly what permissions a key carries, and those scopes are enforced on every request just like roles in an RBAC system.

---

## Key Rotation

API keys should be rotatable. When a key is suspected to be compromised — because it appeared in a log file, was committed to a repository, or was shared with the wrong party — the client must be able to generate a new key and invalidate the old one without disrupting the integration for longer than necessary.

Good key management systems support:
- Issuing multiple active keys per client (so the old one remains valid while the client rotates to the new one)
- Setting expiry dates on keys
- Immediately revoking a specific key when it is known or suspected to be compromised
- Emitting an event or alert when a key is used after it has been revoked

---

## Common Mistakes

**Storing keys in plain text.** A database dump, a misconfigured backup, or an exposed admin panel becomes a full account takeover event.

**Passing keys in query strings.** `/api/data?api_key=abc123` logs that key to every access log between the client and server.

**No rate limiting on key validation.** Without rate limiting, an attacker can brute-force short or predictably generated keys.

**No expiry.** Keys that never expire remain valid forever. A key from a contractor who left three years ago still works. Implement expiry with a sensible default.

**No scoping.** All-powerful keys mean a compromised key compromises everything. Scope keys to the minimum access required.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Node.js | Express | 🟢 Beginner | node-express-beginner.js |
| Node.js | Express | 🔴 Advanced | node-express-advanced.js |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| Ruby | Rails | 🟡 Intermediate | ruby-rails-intermediate.rb |

---

## Dependencies

See the dependency file for your language in this folder. All versions are pinned.
