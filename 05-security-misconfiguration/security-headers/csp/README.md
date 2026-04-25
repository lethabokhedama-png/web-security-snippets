# Content Security Policy (CSP)

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** High
**Applies to:** All web applications that serve HTML pages

---

## What Is CSP?

Content Security Policy is an HTTP response header that tells browsers which sources of content — scripts, styles, images, fonts, frames — are trusted and may be loaded and executed. Any content not matching the policy is blocked.

CSP is the most powerful browser-enforced defence against XSS. Even if an attacker successfully injects a script tag into your HTML, a strict CSP will prevent that script from executing if its source is not in the allowlist. A CSP with script-src 'self' means scripts may only be loaded from your own origin — inline scripts and scripts from other domains are blocked entirely.

---

## CSP Directives Reference

**default-src** — Fallback for all resource types not explicitly defined. Setting `default-src 'self'` is a safe starting point.

**script-src** — Controls JavaScript sources. The most security-critical directive.
- `'self'` — only scripts from the same origin
- `'nonce-{random}'` — allow inline scripts with a specific server-generated nonce
- `'strict-dynamic'` — trust scripts loaded by already-trusted scripts (enables framework compatibility with strict CSP)
- Never use `'unsafe-inline'` in production — it disables XSS protection for inline scripts
- Never use `'unsafe-eval'` unless absolutely required — it allows eval() and Function()

**style-src** — Controls CSS sources. Same principles as script-src.

**img-src** — Controls image sources. Often needs to include CDN domains.

**connect-src** — Controls which URLs JavaScript can connect to via fetch, XHR, WebSocket. Critical for API security.

**frame-ancestors** — Controls which origins can embed this page in a frame. Use instead of X-Frame-Options in modern browsers.

**base-uri** — Restricts the URLs that can appear in the `<base>` element. Prevents base tag injection.

**form-action** — Restricts where forms may submit data. Prevents form hijacking.

---

## The Nonce Pattern

Inline scripts are common in web applications and are blocked by `script-src 'self'`. The nonce pattern allows specific inline scripts while maintaining protection against injected scripts.

A nonce is a randomly generated, base64-encoded value generated per-request by the server. It is included in the CSP header and as an attribute on permitted script tags. Injected scripts cannot know the nonce because it changes on every request.

```html
<!-- Server generates a new nonce for every response -->
<script nonce="r4nd0mN0nc3">
  // This script is allowed because the nonce matches
</script>
```

```
Content-Security-Policy: script-src 'nonce-r4nd0mN0nc3'
```

---

## Starting With Report-Only Mode

`Content-Security-Policy-Report-Only` applies the policy in report mode — violations are logged to a reporting endpoint but content is not blocked. Use this to identify what a strict policy would break before enforcing it. Once violations are resolved, switch to the enforcing `Content-Security-Policy` header.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express + helmet | 🟢 Beginner | node-express-beginner.js |
| Node.js | Express + helmet | 🔴 Advanced | node-express-advanced.js |
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Go | Gin | 🟡 Intermediate | go-gin-intermediate.go |
| PHP | Laravel | 🟢 Beginner | php-laravel-beginner.php |
| Java | Spring Boot | 🟡 Intermediate | java-spring-intermediate.java |
| Config | Nginx | 🟡 Intermediate | nginx-intermediate.conf |