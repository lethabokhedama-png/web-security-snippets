# X-Frame-Options

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** Medium
**Applies to:** Web applications with interactive UI elements — buttons, forms, payment flows

---

## What Is Clickjacking and How Does X-Frame-Options Prevent It?

Clickjacking is an attack where an attacker embeds your site in a transparent iframe and overlays it with a deceptive interface. The user believes they are clicking buttons on the attacker's page but their clicks are captured by your invisible application underneath. The attacker can trick users into performing actions on your site — liking posts, transferring funds, changing account settings — without their awareness or consent.

The X-Frame-Options header tells the browser not to render this page inside any frame or iframe unless explicitly permitted.

---

## Header Values

**DENY** — The page cannot be framed by any domain, including your own. Use this for login pages, payment flows, account settings, and any page where clickjacking would cause harm.

**SAMEORIGIN** — The page can only be framed by pages on the same origin. Use this for applications that legitimately embed their own pages in frames.

**ALLOW-FROM uri** — Deprecated. Not supported in all browsers. Use CSP's `frame-ancestors` directive instead for granular origin control.

---

## CSP frame-ancestors — The Modern Replacement

The Content Security Policy `frame-ancestors` directive provides the same protection with more control and better browser support for granular origin specification:

```
Content-Security-Policy: frame-ancestors 'none'
```

This is equivalent to `X-Frame-Options: DENY`. Set both for maximum compatibility with older browsers that support one but not the other.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express + helmet | 🟢 Beginner | node-express-beginner.js |
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Go | Gin | 🟡 Intermediate | go-gin-intermediate.go |
| PHP | Laravel | 🟢 Beginner | php-laravel-beginner.php |
| Config | Nginx | 🟢 Beginner | nginx-beginner.conf |
| Java | Spring Boot | 🟡 Intermediate | java-spring-intermediate.java |
