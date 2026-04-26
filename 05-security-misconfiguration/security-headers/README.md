# Security Headers

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** High
**Applies to:** All web applications and APIs

---

## What Are Security Headers?

Security headers are HTTP response headers that instruct browsers to enforce specific security policies. They are one of the simplest and highest-value security controls available — adding a single header can prevent entire classes of attacks with no changes to application logic.

They work because browsers are trustworthy execution environments that respect server instructions. A CSP header tells the browser which scripts to execute. An HSTS header tells the browser to always use HTTPS. An X-Frame-Options header tells the browser never to render this page inside a frame. The browser enforces these policies before the attacker's content can take effect.

Security headers do not protect the server. They protect users by restricting what the browser will do with the server's content.

---

## Headers Covered in This Section

**Content-Security-Policy (CSP)** — Defines which sources of scripts, styles, images, and other resources the browser is permitted to load and execute. A strict CSP prevents XSS attacks from executing even if the attacker successfully injects a script tag. Covered in csp/.

**Cross-Origin Resource Sharing (CORS)** — Controls which origins can make cross-origin requests to your API and which response headers are exposed to JavaScript. Incorrect CORS configuration can expose APIs to cross-site credential theft. Covered in cors/.

**Strict-Transport-Security (HSTS)** — Instructs the browser to only access this domain over HTTPS for a specified period, even if the user types `http://` or clicks an HTTP link. Prevents protocol downgrade attacks and SSL stripping. Covered in hsts/.

**X-Frame-Options** — Prevents the page from being embedded in an iframe on another domain, protecting against clickjacking attacks where an attacker overlays invisible frames to steal clicks. Being superseded by CSP's `frame-ancestors` directive but should still be set for older browser compatibility. Covered in x-frame-options/.

**X-Content-Type-Options: nosniff** — Prevents the browser from MIME-sniffing a response away from the declared content type. Without this, a browser may execute a file uploaded as an image if it detects JavaScript-like content inside it.

**Referrer-Policy** — Controls how much referrer information is included with requests. Prevents leaking sensitive URL parameters to third-party sites when users click links.

**Permissions-Policy** — Allows or denies browser features (camera, microphone, geolocation, payment) for the page and any embedded frames.

---

## Testing Your Headers

After implementing security headers, verify them using:

- **securityheaders.com** — Analyses a URL and grades its headers
- **Mozilla Observatory** — Comprehensive security header and TLS analysis
- Browser DevTools → Network tab → Response Headers

Aim for an A or A+ grade on securityheaders.com for any public-facing application.

---

## A Minimal Secure Header Set

At minimum, every application should set these headers on every response:

```
Content-Security-Policy: default-src 'self'
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), camera=(), microphone=()
```

These are starting points. CSP in particular needs to be tailored to your application's actual resource loading requirements.
