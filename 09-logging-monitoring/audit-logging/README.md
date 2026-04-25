# Audit Logging

**OWASP:** A09 — Security Logging and Monitoring Failures
**Risk Level:** High
**Applies to:** All web applications — if it is not logged, it did not happen

---

## What Is an Audit Log?

An audit log is a chronological record of security-relevant events in your application. It is distinct from application logs (which record technical events for debugging) and performance logs (which record response times and resource usage). An audit log records who did what to which resource and when, for purposes of security analysis, compliance, and incident response.

When a breach occurs — and statistically, for any application of scale, a breach will eventually occur — the audit log is the evidence that allows you to determine what was accessed, what was modified, who was affected, and when the breach began. Without an audit log, you cannot answer these questions, you cannot notify affected users correctly, and you cannot demonstrate compliance to regulators.

---

## Log Format: Why Structured Logging Matters

Log lines written as free text are nearly impossible to query at scale. A message like `"User 42 logged in from 192.168.1.1 at 14:32:01"` requires regex parsing to extract the user ID, IP address, and timestamp as discrete fields. Over millions of log entries, this is slow and error-prone.

Structured logging writes log entries as JSON objects (or another structured format) where every field is a named key with a typed value:

```json
{
  "timestamp": "2024-03-15T14:32:01.234Z",
  "event_type": "auth.login.success",
  "user_id": 42,
  "session_id": "sess_9xkQ3mP",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0...",
  "request_id": "req_7v2nXkL"
}
```

Every field is queryable. Finding all login attempts from a specific IP takes milliseconds. Correlating all events from a specific session across services is straightforward. Security information and event management (SIEM) tools ingest structured logs directly.

---

## Log Injection Prevention

Log injection is a vulnerability where an attacker includes newline characters or structured data in user-supplied input that gets logged, causing fake log entries to appear in your audit trail. This can cover tracks or implicate innocent users.

The defence is to sanitise or encode user-supplied data before including it in log messages — specifically, replacing or escaping newline characters (`\n`, `\r`), null bytes, and any characters that have special meaning in your log format.

In structured logging, this is less of a concern because values are encoded as JSON strings by the library. The vulnerability is more relevant when building log strings manually.

---

## Log Storage and Retention

Security logs must be tamper-evident. An attacker who can delete or modify logs can erase evidence of their activities. Logs should be:

- Sent to a centralised, append-only log store separate from the application server
- Retained for a period appropriate to your compliance requirements (typically 12 months minimum, 7 years for PCI-DSS, as required by local regulation)
- Protected with access controls — only security and operations staff should be able to read production security logs
- Backed up independently from the application

---

## Available Snippets

| Language | Framework | Library | Level | File |
|----------|-----------|---------|-------|------|
| Python | Flask | structlog | 🟢 Beginner | python-flask-structlog-beginner.py |
| Python | FastAPI | structlog | 🟡 Intermediate | python-fastapi-structlog-intermediate.py |
| Python | Django | structlog | 🟡 Intermediate | python-django-structlog-intermediate.py |
| Node.js | Express | Winston | 🟢 Beginner | node-express-winston-beginner.js |
| Node.js | Express | Pino | 🟡 Intermediate | node-express-pino-intermediate.js |
| Node.js | Fastify | Pino (built-in) | 🟡 Intermediate | node-fastify-pino-intermediate.js |
| Go | Gin | slog / zerolog | 🔴 Advanced | go-gin-zerolog-advanced.go |
| Java | Spring Boot | Logback + SLF4J | 🟡 Intermediate | java-spring-logback-intermediate.java |
| PHP | Laravel | Monolog | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails | Semantic Logger | 🟡 Intermediate | ruby-rails-intermediate.rb |
| C# | ASP.NET Core | Serilog | 🟡 Intermediate | csharp-serilog-intermediate.cs |