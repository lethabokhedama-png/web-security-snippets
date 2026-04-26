# Application-Level Intrusion Detection

**OWASP:** A09 — Security Logging and Monitoring Failures
**Risk Level:** High
**Applies to:** Applications with user authentication and externally accessible endpoints

---

## What Is Application-Level Intrusion Detection?

Application-level intrusion detection (sometimes called RASP — Runtime Application Self-Protection, or WAAP — Web Application and API Protection) refers to detection logic built into the application itself that identifies and responds to attack patterns in real time. It is distinct from network-level intrusion detection (NIDS) and host-based intrusion detection (HIDS), which operate below the application layer.

The advantage of application-level detection is context. The application knows whether a login attempt used a valid email format, whether the account exists, whether the request matches a known user's behavioural baseline, and whether the response indicates success or failure. Network-level tools cannot see this context.

---

## High-Value Detection Patterns

**Brute force detection:** Track failed login attempts per account and per IP address. Trigger alerts and lockouts when thresholds are exceeded. A threshold of 5 failed attempts per account in 15 minutes is a reasonable starting point for most applications.

**Credential stuffing detection:** Credential stuffing tools make rapid attempts across many different accounts. Patterns to detect include: a high ratio of login failures from a single IP across multiple accounts, login attempts from IPs appearing in published threat intelligence blocklists, and a spike in login failures across the entire application significantly above the normal baseline.

**Account enumeration detection:** Applications that return different responses for "wrong email" vs "wrong password" allow attackers to enumerate valid accounts. Detect patterns of requests that seem designed to enumerate accounts (sequential variations of usernames, high request rates to the login endpoint without completing the login flow).

**Anomalous access patterns:** A user who normally accesses their account from London suddenly appears to be accessing from Lagos and Singapore within the same hour. Session-level geolocation anomalies are a strong signal of session hijacking.

**Sensitive data access spikes:** A user who normally exports 50 records suddenly exports 50,000. Bulk data access patterns are a signal of data exfiltration or a compromised account being used for reconnaissance.

**Scanner and fuzzer detection:** Requests that hit many different paths in rapid succession, requests that include SQL injection or XSS payloads, requests with tool-identifying user agents — these are signals of automated scanning.

---

## Detection vs Response

Detection identifies that something suspicious is happening. Response is what you do about it. Response options escalate in severity:

1. **Log** — Record the event for later analysis. Always do this.
2. **Alert** — Notify security staff in real time. Do this for high-confidence signals.
3. **Rate limit** — Slow down the attacker without blocking them. Useful for ambiguous signals.
4. **CAPTCHA** — Require human verification for subsequent requests from this source.
5. **Temporary block** — Block the IP or account temporarily (5–30 minutes). Use for clear brute force.
6. **Account lock** — Lock the account pending user verification. Use when account takeover is suspected.
7. **Permanent block** — Rarely appropriate for IPs (IP addresses change). More appropriate for confirmed malicious accounts.

Automated blocking carries the risk of false positives — blocking legitimate users. Always provide a path to recovery.

---

## Available Snippets

| Language | Framework | Pattern | Level | File |
|----------|-----------|---------|-------|------|
| Python | Flask | Failed login tracking | 🟡 Intermediate | python-flask-login-tracking-intermediate.py |
| Python | Flask + Redis | Distributed brute force detection | 🔴 Advanced | python-flask-redis-advanced.py |
| Node.js | Express | Failed login tracking | 🟡 Intermediate | node-express-intermediate.js |
| Node.js | Express + Redis | Credential stuffing detection | 🔴 Advanced | node-express-redis-advanced.js |
| Go | Gin | Anomaly detection middleware | 🔴 Advanced | go-gin-advanced.go |
| Java | Spring Boot | Security event publisher | 🔴 Advanced | java-spring-advanced.java |
