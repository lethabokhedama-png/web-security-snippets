# Cross-Origin Resource Sharing (CORS)

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** High
**Applies to:** All APIs and web applications that serve requests from browser clients on other domains

---

## What Is CORS and Why Does It Matter?

Browsers enforce a Same-Origin Policy (SOP) that prevents JavaScript on one domain from making requests to another domain. This is a foundational browser security control. CORS is the mechanism that allows servers to selectively relax this restriction for specific, trusted origins.

CORS is a server-side configuration that tells the browser which cross-origin requests are permitted. If a browser receives a response with `Access-Control-Allow-Origin: https://app.example.com`, it allows JavaScript on `app.example.com` to read that response. Without CORS headers, the response is blocked.

The critical misunderstanding is this: CORS does not protect the server from receiving requests. The request reaches the server regardless — CORS only controls whether the browser allows JavaScript to read the response. Server-side access controls are still required. CORS is a browser-enforced policy for browser clients, not a general API access control mechanism.

---

## The Dangerous Misconfiguration: Wildcard Origin

`Access-Control-Allow-Origin: *` allows any domain on the internet to read the response from JavaScript. This is appropriate for completely public, unauthenticated APIs (public weather data, public transit schedules). It is never appropriate for APIs that:
- Return any user-specific data
- Accept authentication credentials
- Process state-changing operations

Note that `*` cannot be combined with `Access-Control-Allow-Credentials: true`. If credentials (cookies, HTTP auth) are included in the request, the response origin must be explicitly specified, not wildcarded.

---

## Dynamic Origin Reflection — The Subtle Vulnerability

A common but dangerous pattern is reflecting the request's `Origin` header directly back as the `Access-Control-Allow-Origin` value without validating it:

```python
# DANGEROUS — reflects any origin
response.headers['Access-Control-Allow-Origin'] = request.headers.get('Origin')
```

This effectively grants any origin access to your API. An attacker who hosts a page at `evil.com` can make authenticated requests to your API and read the responses. The correct approach is to maintain an allowlist of trusted origins and only reflect the origin if it appears in that list.

---

## Preflight Requests

Browsers send a preflight OPTIONS request before certain cross-origin requests (those using non-simple methods or custom headers). Your server must respond to OPTIONS with appropriate CORS headers. If the preflight fails, the actual request is never sent. Misconfigured preflight responses are a common source of CORS errors in development.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express | 🟢 Beginner | node-express-beginner.js |
| Node.js | Express | 🔴 Advanced | node-express-advanced.js |
| Node.js | Fastify | 🟡 Intermediate | node-fastify-intermediate.js |
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| Java | Spring Boot | 🔴 Advanced | java-spring-advanced.java |
| PHP | Laravel | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails | 🟡 Intermediate | ruby-rails-intermediate.rb |
| C# | ASP.NET Core | 🟡 Intermediate | csharp-aspnet-intermediate.cs |
