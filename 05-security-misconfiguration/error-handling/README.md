# Secure Error Handling

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** Medium
**Applies to:** All web applications and APIs

---

## Why Error Handling Is a Security Control

Verbose error messages are a reconnaissance gift. A stack trace reveals the language, framework, library versions, file paths, function names, and sometimes variable values. A database error message reveals table names, column names, and query structure. An unhandled exception that reaches the browser gives an attacker a detailed map of the application's internals.

This information does not enable an attack on its own. It dramatically reduces the time and skill required to construct one. An attacker who does not know your database schema cannot craft a targeted SQL injection payload. An attacker who does not know your file paths cannot exploit path traversal. Error verbosity removes these obstacles.

---

## The Two Environments

**Development:** Detailed errors are valuable. You need stack traces, query text, and variable state to debug effectively. Suppress nothing in development.

**Production:** Detailed errors must never reach the client. Every unhandled exception must produce a generic error response. Detailed information must be written to logs that are accessible only to operations staff.

The most common mistake is an application that behaves as expected in development — where everyone is a trusted developer — and leaks information in production because error handling was never implemented.

---

## What a Production Error Response Should Look Like

```json
{
  "error": "An unexpected error occurred.",
  "reference": "err_7x3k9m"
}
```

The reference ID is a correlation identifier that maps to the full error details in your internal logs. A support engineer can look up `err_7x3k9m` and see the full stack trace. The client sees nothing exploitable.

---

## What Must Be Logged Internally

For every unhandled exception in production, your logs must capture:
- Timestamp
- Request ID or correlation ID
- The request URL and HTTP method
- The authenticated user ID (if any)
- The full exception type, message, and stack trace
- Any relevant request parameters (with sensitive fields redacted)

Without this information, production errors are undiagnosable.

---

## Centralised Error Handling

Error handling should live in one place — a centralised error handling middleware or exception handler — not scattered throughout route handlers. This ensures consistent behaviour, makes it easy to update the format of error responses, and prevents individual routes from accidentally leaking details.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Python | Django | 🟡 Intermediate | python-django-intermediate.py |
| Node.js | Express | 🟢 Beginner | node-express-beginner.js |
| Node.js | Fastify | 🟡 Intermediate | node-fastify-intermediate.js |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| Java | Spring Boot | 🟡 Intermediate | java-spring-intermediate.java |
| PHP | Laravel | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails | 🟢 Beginner | ruby-rails-beginner.rb |
| C# | ASP.NET Core | 🟡 Intermediate | csharp-aspnet-intermediate.cs |
