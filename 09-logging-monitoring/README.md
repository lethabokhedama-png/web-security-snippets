# A09 — Security Logging and Monitoring Failures

**OWASP Rank:** 9 of 10
**Risk Level:** High
**Community-submitted:** Yes (added based on industry survey data)

---

## What Is This Category?

Security logging and monitoring failures occur when an application does not generate sufficient audit logs, does not monitor those logs for suspicious activity, and does not alert on security events in a timely manner. Without logging, breaches go undetected. Without monitoring, logs are evidence collected after the fact rather than a detection mechanism.

The average time to detect a data breach globally is over 200 days. For many organisations, detection happens only when an external party — a researcher, a regulator, or a journalist — notifies them. This is almost always a logging and monitoring failure.

---

## Real-World Impact

**Yahoo (2013-2014):** Two separate breaches exposed 3 billion accounts. The 2013 breach was not discovered until 2016 — three years later — and the full scope was not acknowledged until 2017. The delay was due to inadequate log retention, insufficient monitoring, and a failure to correlate anomalous access patterns with breach activity.

**Marriott International (2014-2018):** The Starwood reservation database (acquired by Marriott in 2016) had been compromised since 2014. The breach was not detected until 2018 — four years of ongoing exfiltration. During that time, 500 million guest records were exposed. The breach was discovered not through internal monitoring but through a security tool that flagged suspicious database access.

---

## What Makes a Security Log Useful

A log entry that says "error occurred" is not a security log. A security log must contain enough information to reconstruct what happened, who did it, when, and from where. For every security-relevant event, capture:

- **Timestamp** — in UTC, with millisecond precision if possible
- **Event type** — what happened (login success, login failure, permission denied, data export, etc.)
- **User identifier** — the authenticated user ID or "unauthenticated" for requests without a session
- **Source IP address** — and the originating IP if behind a proxy (X-Forwarded-For)
- **Resource** — what was accessed or attempted
- **Outcome** — success, failure, the reason for failure
- **Correlation ID** — a request ID that links all log entries for a single request

Do not log passwords, session tokens, credit card numbers, or other sensitive values. Logs are often stored with less protection than the application database.

---

## What to Log

At minimum, log every:
- Authentication attempt (success and failure) with the username attempted
- Authorisation failure (a user attempting to access something they are not permitted to)
- Session creation and invalidation
- Password change and password reset request
- MFA challenge success and failure
- Administrative action (user creation, role change, configuration change)
- Unusual or large data access (exporting more records than typical)
- Input validation failure that might indicate scanning or fuzzing

---

## What This Section Covers

**Audit Logging** — Structured log formats and middleware for capturing security-relevant events. Includes JSON-structured logging, correlation ID propagation, and log sanitisation to prevent log injection.

**Intrusion Detection** — Application-level detection patterns for brute force, credential stuffing, and anomalous access. Includes rate-based alerting and account-level anomaly detection.

**Alerting** — Integration with notification services (Slack, PagerDuty, email) for real-time security event notification. Includes threshold-based alerting and incident correlation patterns.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Implement structured security audit logging | audit-logging/ |
| Detect and respond to brute force attacks | intrusion-detection/ |
| Send real-time alerts on security events | alerting/ |
