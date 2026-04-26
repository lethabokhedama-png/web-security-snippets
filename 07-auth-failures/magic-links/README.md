# Magic Links (Passwordless Email Authentication)

**OWASP:** A07 — Identification and Authentication Failures
**Risk Level:** Medium
**Applies to:** Consumer applications looking to reduce friction while eliminating password-related vulnerabilities

---

## What Is a Magic Link?

A magic link is a single-use, time-limited URL sent to a user's email address that, when clicked, authenticates the user without a password. The security of the authentication is tied to the security of the user's email account — which is itself typically protected by a password and often MFA.

Magic links are a form of passwordless authentication. They eliminate an entire class of vulnerabilities related to passwords: credential stuffing, password reuse, weak passwords, phishing for passwords, and password database breaches.

---

## How Magic Links Work

1. User enters their email address on the login page
2. Server generates a cryptographically random token (minimum 32 bytes of entropy)
3. Server stores a hash of the token (not the token itself) alongside the user record, with an expiry timestamp
4. Server sends an email containing a URL with the token as a query parameter
5. User clicks the link, server retrieves the token from the URL, hashes it, and looks up the stored hash
6. If the hash matches and the token has not expired, the user is authenticated
7. Server immediately invalidates the token (marks it as used or deletes it) — it must never be usable again

---

## Security Requirements

**Token entropy:** The token must be generated with a cryptographically secure random number generator. A minimum of 32 bytes (256 bits) of randomness, typically represented as a 64-character hex string or a url-safe base64 string. Shorter or predictably generated tokens can be brute-forced, especially if there is no rate limiting on the validation endpoint.

**Store the hash, not the token:** The token itself is a credential. Store a SHA-256 hash of the token. If your database is compromised, the attacker has hashes, not the tokens needed to authenticate.

**Short expiry:** Magic links should expire quickly — 15 minutes is a reasonable default for most applications. Users who do not click within that window request a new link. Longer expiry windows increase the risk if the email is accessed by an attacker.

**Single use:** Once clicked, the token is immediately invalidated. A link that can be used multiple times is a persistent credential, not a one-time code.

**Rate limiting:** Limit how many magic links can be requested per email address per time period. Without rate limiting, an attacker can spam a user's inbox with authentication emails.

---

## When to Use Magic Links vs Password Authentication

Magic links are appropriate when:
- Your users are not highly technical and often forget passwords
- Your application is low-to-medium security (not financial, health, or government)
- Email deliverability is reliable and fast in your target market
- You want to eliminate password reuse and credential stuffing as attack vectors

Magic links are less appropriate when:
- Your users access the application frequently (constant email round trips are friction)
- Email delivery in your target region is unreliable
- The security of your application must be independent of email security

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express | 🟡 Intermediate | node-express-intermediate.js |
| Node.js | Express + Nodemailer | 🟢 Beginner | node-express-nodemailer-beginner.js |
| Python | Flask | 🟡 Intermediate | python-flask-intermediate.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| PHP | Laravel | 🟡 Intermediate | php-laravel-intermediate.php |
| Ruby | Rails + Action Mailer | 🟡 Intermediate | ruby-rails-intermediate.rb |
