# Session Management

**OWASP:** A07 — Identification and Authentication Failures
**Risk Level:** Critical
**Applies to:** Any web application with server-side session state

---

## What Is a Session?

When a user authenticates, the server needs a way to recognise subsequent requests as coming from the same authenticated user without requiring re-authentication on every request. A session is the mechanism for maintaining this state. The server creates a session record, generates a session ID, and sends that ID to the browser in a cookie. On each subsequent request, the browser sends the cookie, the server looks up the session ID, and retrieves the associated user state.

Sessions are a server-side construct. The session ID stored in the cookie is a reference to server-side state — it carries no information about the user itself. This is the key distinction from JWT-based authentication, where all state is encoded in the token.

---

## Session ID Requirements

A session ID must be:

**Unpredictable:** Generated with a cryptographically secure random number generator. A session ID that can be predicted or guessed allows session hijacking without ever needing a password. Do not use sequential numbers, timestamps, or deterministic values as session IDs.

**Long enough:** At minimum 128 bits of entropy (typically a 32-byte random value represented as a 64-character hex string). Shorter session IDs are susceptible to brute-force guessing, especially at scale.

**Unique per session:** Two sessions must never share an ID, and re-authentication must generate a new ID (see session fixation below).

---

## Secure Cookie Configuration

Session IDs are transmitted via cookies. These cookie attributes are security-critical:

**Secure:** The cookie is only sent over HTTPS connections. Without this attribute, the session ID is transmitted in plain text over HTTP and can be captured by a network observer.

**HttpOnly:** The cookie is not accessible to JavaScript (document.cookie). This prevents session hijacking via XSS. An XSS attacker cannot steal an httpOnly session cookie through JavaScript.

**SameSite=Strict or Lax:** Controls whether the cookie is sent with cross-site requests. `Strict` prevents the cookie from being sent in any cross-site request, protecting against CSRF attacks. `Lax` allows the cookie for top-level navigations (clicking links) but not for cross-site sub-resource requests.

**Domain and Path:** Scope the cookie to the specific domain and path that needs it. A cookie scoped to the root path of your entire domain is sent with every request to that domain, including images and static assets that do not need authentication.

---

## Session Fixation

Session fixation is an attack where an attacker sets the victim's session ID before the victim authenticates. The attacker navigates to the login page, captures the pre-authentication session ID, tricks the victim into using that ID, and after the victim authenticates, the attacker has a valid authenticated session.

The defence is simple: regenerate the session ID on every privilege change, including login, logout, and any elevation of privilege. The pre-authentication session ID must never carry over to the post-authentication state.

---

## Session Invalidation on Logout

On logout, the server must invalidate the session server-side — delete it from the session store or mark it as expired. Clearing the session cookie client-side is not sufficient. A cookie that has been cleared client-side may still be held by an attacker who captured it earlier. Invalidating the server-side record makes it worthless.

---

## Available Snippets

| Language | Framework | Storage | Level | File |
|----------|-----------|---------|-------|------|
| Python | Flask | Server-side (filesystem) | 🟢 Beginner | python-flask-beginner.py |
| Python | Flask | Redis | 🟡 Intermediate | python-flask-redis-intermediate.py |
| Python | Django | Database | 🟢 Beginner | python-django-beginner.py |
| Node.js | Express | In-memory | 🟢 Beginner | node-express-memory-beginner.js |
| Node.js | Express | Redis | 🟡 Intermediate | node-express-redis-intermediate.js |
| Go | Gin | Redis | 🔴 Advanced | go-gin-redis-advanced.go |
| PHP | Laravel | Database | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails | Active Record | 🟢 Beginner | ruby-rails-beginner.rb |
| Java | Spring Boot | Redis | 🟡 Intermediate | java-spring-redis-intermediate.java |
| C# | ASP.NET Core | Distributed cache | 🟡 Intermediate | csharp-aspnet-intermediate.cs |
