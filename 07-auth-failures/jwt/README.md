# JSON Web Tokens (JWT)

**OWASP:** A07 — Identification and Authentication Failures
**Risk Level:** Critical
**Applies to:** Stateless API authentication, microservice identity, single-page applications

---

## What Is a JWT?

A JSON Web Token is a compact, self-contained token that encodes claims — statements about an entity — in a JSON payload that is cryptographically signed. A server that issues a JWT signs it with a secret or private key. Any server with the corresponding secret or public key can verify the signature and trust the claims inside without querying a central store.

A JWT has three parts separated by dots:
- **Header** — algorithm and token type
- **Payload** — claims (user ID, roles, expiry, etc.)
- **Signature** — cryptographic signature over header and payload

The payload is base64url-encoded, not encrypted. It is not secret. Anyone who holds a JWT can decode and read its payload. Never put sensitive data in a JWT payload unless the token is also encrypted (a JWE, JSON Web Encryption — a different and more complex construct).

---

## Algorithm Selection: HS256 vs RS256

**HS256 (HMAC-SHA256):** A symmetric algorithm. The same secret is used to both sign and verify tokens. Simple to implement. Requires that every service validating tokens shares the secret — a problem when multiple services need to verify tokens independently.

**RS256 (RSA-SHA256):** An asymmetric algorithm. A private key signs tokens. A public key verifies them. The signing service keeps its private key secret. Any other service can verify tokens using the public key without ever seeing the private key. This is the correct choice for distributed systems, microservices, or any case where token issuance and verification are separated.

**The `none` algorithm vulnerability:** Some JWT libraries historically accepted `none` as an algorithm, meaning no signature. An attacker who knew this could create a token with any claims they wanted and set `"alg": "none"`. Always configure your library to reject unsigned tokens and to only accept specific named algorithms. Never accept algorithms from the token header without validation against your allowlist.

---

## Critical Implementation Rules

**Always verify the signature.** The signature check is the entire security value of a JWT. A library call that decodes without verifying provides no security.

**Validate the expiry claim (`exp`).** An expired token must be rejected. An application that accepts tokens past their expiry has effectively issued non-expiring credentials.

**Validate the audience claim (`aud`) where used.** An access token issued for service A should be rejected by service B if the audience claim is set and validated correctly. Without audience validation, a token issued for one service can be replayed against another.

**Validate the issuer claim (`iss`).** Verify that the token was issued by the expected authority.

**Store tokens in httpOnly cookies, not localStorage.** localStorage is accessible to any JavaScript on the page. An XSS vulnerability gives an attacker access to every stored token. httpOnly cookies cannot be read by JavaScript — they are attached to requests automatically by the browser and are not accessible to scripts.

**Set short expiry times and implement token refresh.** Access tokens should have short lifetimes (15 minutes to 1 hour). Implement a refresh token mechanism for maintaining sessions without requiring re-login.

**Implement token revocation.** JWTs are stateless by design — there is no server-side session to invalidate. For use cases that require immediate revocation (logout, account suspension), maintain a blocklist of revoked JTI (JWT ID) claims or use short-lived tokens with a refresh token rotation pattern.

---

## What JWTs Are Not Good For

JWTs are not session cookies. They are not designed for web application session management where you need to invalidate sessions immediately (on logout, on password change, on account suspension). The stateless nature that makes them useful for distributed systems makes them unsuitable for use cases requiring immediate revocation without a blocklist.

JWTs are not encrypted by default. The payload is readable by anyone. Use JWE if you need to encrypt claims.

JWTs are not authentication. They carry claims about an already-authenticated identity. Authentication happens before the JWT is issued.

---

## Available Snippets

| Language | Framework | Algorithm | Level | File |
|----------|-----------|-----------|-------|------|
| Python | Flask | HS256 | 🟢 Beginner | python-flask-hs256-beginner.py |
| Python | Flask | RS256 | 🔴 Advanced | python-flask-rs256-advanced.py |
| Python | FastAPI | RS256 | 🔴 Advanced | python-fastapi-rs256-advanced.py |
| Node.js | Express | HS256 | 🟢 Beginner | node-express-hs256-beginner.js |
| Node.js | Express | RS256 | 🔴 Advanced | node-express-rs256-advanced.js |
| Node.js | Express | JWKS endpoint | 🔴 Advanced | node-express-jwks-advanced.js |
| Go | Gin | RS256 | 🔴 Advanced | go-gin-rs256-advanced.go |
| Java | Spring Boot | RS256 | 🔴 Advanced | java-spring-rs256-advanced.java |
| PHP | Laravel | HS256 | 🟡 Intermediate | php-laravel-intermediate.php |
| Ruby | Rails | HS256 | 🟡 Intermediate | ruby-rails-intermediate.rb |
| Rust | Axum | RS256 | 🔴 Advanced | rust-axum-advanced.rs |
| C# | ASP.NET Core | RS256 | 🔴 Advanced | csharp-aspnet-advanced.cs |