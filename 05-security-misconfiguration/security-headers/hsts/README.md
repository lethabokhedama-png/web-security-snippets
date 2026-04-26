# HTTP Strict Transport Security (HSTS)

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** Medium-High
**Applies to:** All web applications served over HTTPS

---

## What Is HSTS?

HTTP Strict Transport Security is a response header that instructs browsers to only contact your site over HTTPS for a specified period, regardless of what protocol the user or a link specifies. Once a browser has seen an HSTS header from your site, it will automatically upgrade any HTTP requests to HTTPS and refuse to connect if a valid HTTPS connection cannot be established.

Without HSTS, a user who types `example.com` into a browser makes an initial HTTP request. An attacker performing SSL stripping can intercept this request, establish an HTTP connection with the user and an HTTPS connection with your server, and transparently proxy all traffic — reading and modifying it in transit. The user sees the padlock disappear but may not notice.

With HSTS, the browser never makes that initial HTTP request. It upgrades to HTTPS before any packet leaves the device.

---

## The HSTS Header

```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

**max-age** — How long (in seconds) the browser should remember to enforce HTTPS. 31,536,000 is one year. Start with a shorter value (300 seconds = 5 minutes) during initial deployment and increase once you are confident HTTPS is stable.

**includeSubDomains** — Applies the policy to all subdomains. Only add this once all subdomains are serving valid HTTPS. A subdomain without HTTPS becomes inaccessible to users who have received the HSTS header with this flag.

**preload** — Indicates willingness to be included in browser HSTS preload lists. Browsers ship with a built-in list of sites that must always be accessed over HTTPS — even on first visit. Requires submitting to hstspreload.org and is effectively permanent. Do not add this flag until you are certain HTTPS will always be available on your domain.

---

## Deployment Caution

HSTS is a commitment. Once a browser has cached your HSTS policy, it will not make HTTP connections to your domain for the duration of `max-age`. If your HTTPS configuration breaks during that period, those users cannot reach your site at all — they cannot fall back to HTTP.

Deploy HSTS progressively: start with `max-age=300`, verify everything works, increase to `max-age=86400`, then `max-age=2592000`, then `max-age=31536000`.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express + helmet | 🟢 Beginner | node-express-beginner.js |
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Go | Gin | 🟡 Intermediate | go-gin-intermediate.go |
| Config | Nginx | 🟡 Intermediate | nginx-intermediate.conf |
| Config | Apache | 🟡 Intermediate | apache-intermediate.conf |
| Java | Spring Boot | 🟡 Intermediate | java-spring-intermediate.java |
