# Security Alerting

**OWASP:** A09 — Security Logging and Monitoring Failures
**Risk Level:** High
**Applies to:** All production applications

---

## Why Alerting Is Distinct From Logging

Logs record what happened. Alerts tell you what is happening right now and requires your attention. An application that generates detailed security logs but never alerts on those logs gives security staff a forensic tool after a breach but no ability to intervene during one.

Effective security alerting requires defining what events warrant immediate attention, who should be notified, and through which channel. A Slack message is appropriate for a medium-severity event during business hours. A PagerDuty page is appropriate for a critical event at any hour.

---

## Alert Fatigue: The Biggest Risk to an Alerting System

An alerting system that generates too many alerts trains the people receiving them to ignore them. When every hour brings a dozen alerts, each of which turns out to be a false positive, the real alert — a genuine breach in progress — blends into the noise. Security professionals call this alert fatigue, and it has been identified as a contributing factor in numerous significant breaches.

The solution is ruthless prioritisation:
- Only alert on events that require human action
- Tune thresholds based on observed normal behaviour
- Regularly review alerts to identify and eliminate false positives
- Grade alerts by severity — reserve immediate pages for genuine critical events

---

## Alert Categories

**Immediate (pager-worthy):**
- Signs of active data exfiltration (bulk export, unusual database query patterns)
- Multiple privileged account logins from unknown locations
- CI/CD pipeline accessing credentials outside normal deploy times
- WAF or IDS triggering on known exploit signatures

**High priority (acknowledge within 1 hour):**
- Account lockouts on multiple accounts simultaneously
- Sustained brute force attack in progress
- Admin panel access from unfamiliar IP
- Rate limit violations at high volume

**Medium priority (review within 4 hours):**
- Single account brute force (resolved by lockout)
- Spike in 4xx or 5xx errors above normal baseline
- New device login for a privileged account

**Informational (review daily):**
- New user registrations from suspicious IP ranges
- Daily summary of failed authentication attempts

---

## Available Snippets

| Language | Target | Level | File |
|----------|--------|-------|------|
| Python | Slack webhook | 🟢 Beginner | python-slack-beginner.py |
| Python | PagerDuty Events API | 🔴 Advanced | python-pagerduty-advanced.py |
| Python | Email (SMTP) | 🟢 Beginner | python-email-beginner.py |
| Node.js | Slack webhook | 🟢 Beginner | node-slack-beginner.js |
| Node.js | PagerDuty Events API | 🔴 Advanced | node-pagerduty-advanced.js |
| Go | Slack webhook | 🟡 Intermediate | go-slack-intermediate.go |
| All | Alerting threshold patterns | 🟡 Intermediate | alerting-thresholds-guide.md |
| All | Alert escalation policy template | 🟡 Intermediate | escalation-policy-template.md |
