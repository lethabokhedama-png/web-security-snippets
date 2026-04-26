# Canary Tokens

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Detecting data exfiltration and unauthorised access to sensitive resources
**Audience:** Senior engineers, security engineers

---

## What Is a Canary Token?

A canary token is a unique, trackable identifier embedded in a document, configuration file, database record, code repository, or any other digital artifact. When the artifact is accessed or the token is used in a way it should not be, an alert is generated. The token "canaries" on access — the term comes from the historical practice of coal miners keeping canaries in mines to detect carbon monoxide before it reached dangerous levels for humans.

The key distinction from a honeypot is that canary tokens travel with the data. A document that should never leave your internal systems can contain a canary token. If the document is exfiltrated and opened by an attacker, the token fires and you know the document has been compromised — even if you do not yet know how it was exfiltrated.

---

## Canarytokens.org

The simplest way to start using canary tokens is canarytokens.org, a free service that generates various types of tokens and sends email alerts when they fire. Useful for simple deployments or proof-of-concept. For production use, consider self-hosted implementations to avoid dependency on an external service and to maintain privacy of your detection infrastructure.

---

## Token Types

**URL tokens:** An embedded URL (e.g., an image URL or a link) that fires a web request when accessed. Embed in Word documents, PDFs, HTML files, or emails. Fires when the document is opened.

**DNS tokens:** A unique DNS hostname embedded in configuration or documents. Fires a DNS query when resolved. DNS requests often succeed even through firewalls that block HTTP, making DNS tokens more reliable in restricted environments.

**AWS API key tokens:** Fake AWS credentials that look real. If an attacker uses them to make an AWS API call, the call fails (the credentials are fake) but AWS logs the attempt, and the token fires an alert.

**Database canary records:** A record in your database with a unique identifier. Add a database trigger or application-level check that fires an alert if this record is ever read outside of the audit query that checks its existence.

**Code repository tokens:** Fake API keys or credentials in a private repository. If the repository is compromised and an attacker uses the credentials, the token fires.

---

## Self-Hosted Canary Token Infrastructure

For production deployments, self-host your canary token server to:
- Maintain full control over alert content and routing
- Avoid revealing your detection infrastructure to an external service
- Integrate with your existing alerting and incident response toolchain
- Customise token types for your specific environment

Thinkst Canary (commercial) and the open-source canarytokens-docker project are starting points for self-hosted deployments.

---

## Available Snippets

| Language | Token Type | Level | File |
|----------|-----------|-------|------|
| Python | Database canary record | Advanced | python-db-canary.py |
| Python | URL canary endpoint | Intermediate | python-url-canary.py |
| Node.js | URL canary endpoint | Intermediate | node-url-canary.js |
| All | Canary token placement strategy | Any | placement-strategy-guide.md |
| Docker | Self-hosted canary server | Advanced | self-hosted-setup-guide.md |
