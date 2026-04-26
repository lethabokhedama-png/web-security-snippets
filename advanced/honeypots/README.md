# Honeypots

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Delayed detection of attacker reconnaissance and lateral movement
**Audience:** Senior engineers, security engineers, incident response teams

---

## What Is a Honeypot?

A honeypot is a decoy resource — an endpoint, file, database record, user account, or system — that has no legitimate use. Legitimate users and systems will never access it. The only entity that should ever interact with it is an attacker conducting reconnaissance or attempting exploitation.

When a honeypot is triggered, you have a high-confidence signal with essentially zero false positives. A request to `/admin-panel`, `/wp-admin`, `/.env`, or `/api/v1/users/admin` on an application that has none of these resources is almost certainly automated scanning or an attacker who has already enumerated your application and is probing for weaknesses.

Honeypots are a detection technology, not a prevention technology. They do not stop attacks. They detect them, often earlier than any other control.

---

## Types of Application Honeypots

**Fake admin endpoints:** Routes that look like administrative interfaces (`/admin`, `/management`, `/console`, `/dashboard/admin`) but serve only to log and alert on access attempts.

**Fake API endpoints:** Endpoints that appear to be undocumented or internal APIs (`/api/internal/users`, `/api/v2/admin`) that would only be found through directory enumeration or source code analysis.

**Honey credentials:** Fake username/password combinations seeded into credential databases that are sometimes exfiltrated in breaches. If these credentials are ever used to attempt authentication, the credential database has been compromised.

**Honey tokens in code:** API keys, access tokens, or database connection strings with the appearance of real credentials embedded in places that might be accessed by an attacker — configuration files, documentation, source code comments. The tokens are real-looking but connect only to a honeypot service that logs and alerts on any connection attempt.

**Honey records in databases:** Fake user records, fake customer records, or fake documents in your database that should never be read by the application. A query that retrieves a honey record is a signal that an attacker is enumerating your database, either through injection or through a compromised account.

---

## What Happens When a Honeypot Is Triggered

The response to a honeypot trigger depends on your security posture and incident response capability:

1. **Always log:** Record the request in detail — timestamp, source IP, user agent, request headers, any authentication credentials attempted, and the full request body.
2. **Always alert:** Send an immediate notification to your security team. A honeypot trigger is a high-confidence signal that warrants investigation.
3. **Consider rate-limited response:** For endpoint honeypots, consider returning a plausible but fake response rather than an immediate 404. This keeps the attacker engaged while your team investigates, potentially revealing more of their tooling and techniques.
4. **Do not immediately block:** Blocking the source IP immediately tells the attacker they have been detected and may cause them to change their approach. Investigate first.

---

## Available Snippets

| Language | Framework | Type | Level | File |
|----------|-----------|------|-------|------|
| Python | Flask | Fake admin routes | Intermediate | python-flask-honeypot.py |
| Node.js | Express | Fake admin routes | Intermediate | node-express-honeypot.js |
| Go | Gin | Fake admin routes | Advanced | go-gin-honeypot.go |
| Python | Any | Honey database records | Advanced | python-honey-records.py |
| Config | Nginx | Fake endpoint logging | Intermediate | nginx-honeypot.conf |
| All | Any | Honey token integration guide | Intermediate | honey-token-guide.md |
