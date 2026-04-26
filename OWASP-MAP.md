# OWASP Top 10 — Full Snippet Map

This document maps every snippet in the library to its corresponding OWASP Top 10 (2021) category. It exists so you can find the right snippet by threat type rather than by browsing folders. It also serves as a coverage tracker — gaps show where contributions are needed.

The OWASP Top 10 is the most widely recognised classification of critical web application security risks. It is published by the Open Web Application Security Project and updated periodically based on real-world vulnerability data. This library uses the 2021 edition.

Understanding which OWASP category a vulnerability falls into helps you assess your application's overall security posture, communicate risk to non-technical stakeholders, and prioritise which controls to implement first.

---

## How to Read This Map

Each section below represents one OWASP category. Inside each section you will find a table listing every snippet that addresses that risk, along with the language, framework, difficulty level, and file path. As new snippets are added to the library, this document is updated to reflect them.

Status indicators used in this document:

- **Available** — snippet exists and is ready to use
- **In Progress** — snippet is being written
- **Needed** — gap in coverage, contribution welcome

---

## A01 — Broken Access Control

Broken access control is the most common web application vulnerability. It occurs when users can act outside their intended permissions — accessing other users' data, performing administrative actions without authorisation, or bypassing access checks entirely. It is ranked first because it appears in 94% of applications tested.

Common failure modes include missing function-level access checks, insecure direct object references, CORS misconfiguration that allows untrusted origins, and privilege escalation through parameter manipulation.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Role-Based Access Control (RBAC) | Python | Flask | Beginner | In Progress | 01-broken-access-control/rbac/python-flask-beginner.py |
| Role-Based Access Control (RBAC) | Python | Flask | Advanced | In Progress | 01-broken-access-control/rbac/python-flask-advanced.py |
| Role-Based Access Control (RBAC) | Python | Django | Intermediate | In Progress | 01-broken-access-control/rbac/python-django-intermediate.py |
| Role-Based Access Control (RBAC) | Node.js | Express | Beginner | In Progress | 01-broken-access-control/rbac/node-express-beginner.js |
| Role-Based Access Control (RBAC) | Node.js | Express | Advanced | In Progress | 01-broken-access-control/rbac/node-express-advanced.js |
| Role-Based Access Control (RBAC) | Go | Gin | Advanced | In Progress | 01-broken-access-control/rbac/go-gin-advanced.go |
| Role-Based Access Control (RBAC) | Java | Spring Boot | Advanced | In Progress | 01-broken-access-control/rbac/java-spring-advanced.java |
| Role-Based Access Control (RBAC) | PHP | Laravel | Intermediate | In Progress | 01-broken-access-control/rbac/php-laravel-intermediate.php |
| Attribute-Based Access Control (ABAC) | Python | FastAPI | Advanced | Needed | 01-broken-access-control/abac/ |
| Attribute-Based Access Control (ABAC) | Node.js | NestJS | Advanced | Needed | 01-broken-access-control/abac/ |
| API Key Validation | Python | Flask | Beginner | In Progress | 01-broken-access-control/api-key-validation/python-flask-beginner.py |
| API Key Validation | Node.js | Express | Beginner | In Progress | 01-broken-access-control/api-key-validation/node-express-beginner.js |
| API Key Validation | Go | Gin | Advanced | Needed | 01-broken-access-control/api-key-validation/ |

---

## A02 — Cryptographic Failures

Previously known as Sensitive Data Exposure, this category covers failures in cryptography that lead to exposure of sensitive data. The most common issues are storing passwords in plain text or with weak hashing algorithms, transmitting data over unencrypted connections, using deprecated cryptographic functions, and poor key management practices.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Password Hashing with bcrypt | Python | None | Beginner | In Progress | 02-cryptographic-failures/password-hashing/python-beginner.py |
| Password Hashing with bcrypt | Python | None | Advanced | In Progress | 02-cryptographic-failures/password-hashing/python-advanced.py |
| Password Hashing with Argon2 | Python | None | Advanced | In Progress | 02-cryptographic-failures/password-hashing/python-argon2-advanced.py |
| Password Hashing with bcrypt | Node.js | None | Beginner | In Progress | 02-cryptographic-failures/password-hashing/node-beginner.js |
| Password Hashing with bcrypt | Go | None | Advanced | In Progress | 02-cryptographic-failures/password-hashing/go-advanced.go |
| Password Hashing with Argon2 | Rust | None | Advanced | In Progress | 02-cryptographic-failures/password-hashing/rust-advanced.rs |
| Encryption at Rest — AES-256-GCM | Python | None | Intermediate | In Progress | 02-cryptographic-failures/encryption-at-rest/python-intermediate.py |
| Encryption at Rest — AES-256-GCM | Node.js | None | Intermediate | In Progress | 02-cryptographic-failures/encryption-at-rest/node-intermediate.js |
| TLS Configuration — Nginx | Config | None | Intermediate | In Progress | 02-cryptographic-failures/tls-config/nginx-intermediate.conf |
| TLS Configuration — Apache | Config | None | Intermediate | In Progress | 02-cryptographic-failures/tls-config/apache-intermediate.conf |
| Key Management — Environment Variables | Python | None | Beginner | In Progress | 02-cryptographic-failures/key-management/python-beginner.py |
| Key Management — HashiCorp Vault | Python | None | Advanced | In Progress | 02-cryptographic-failures/key-management/python-vault-advanced.py |
| Key Management — AWS Secrets Manager | Node.js | None | Advanced | In Progress | 02-cryptographic-failures/key-management/node-aws-advanced.js |

---

## A03 — Injection

Injection vulnerabilities occur when untrusted data is sent to an interpreter as part of a command or query. SQL injection, NoSQL injection, command injection, LDAP injection, and cross-site scripting all fall into this category. An attacker who successfully exploits injection can read, modify, or delete data, execute system commands, or take full control of the application.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| SQL Injection Prevention — Parameterized Queries | Python | Flask + SQLAlchemy | Beginner | In Progress | 03-injection/sql-injection/python-flask-beginner.py |
| SQL Injection Prevention — Parameterized Queries | Python | Flask + SQLAlchemy | Advanced | In Progress | 03-injection/sql-injection/python-flask-advanced.py |
| SQL Injection Prevention — Django ORM | Python | Django | Intermediate | In Progress | 03-injection/sql-injection/python-django-intermediate.py |
| SQL Injection Prevention — Parameterized Queries | Node.js | Express + pg | Beginner | In Progress | 03-injection/sql-injection/node-express-beginner.js |
| SQL Injection Prevention — Prepared Statements | Node.js | Express + mysql2 | Intermediate | In Progress | 03-injection/sql-injection/node-mysql-intermediate.js |
| SQL Injection Prevention — Parameterized Queries | Go | Gin + pgx | Advanced | In Progress | 03-injection/sql-injection/go-gin-advanced.go |
| SQL Injection Prevention — PreparedStatement | Java | Spring Boot + JDBC | Advanced | In Progress | 03-injection/sql-injection/java-spring-advanced.java |
| SQL Injection Prevention — Parameterized Queries | PHP | Laravel | Beginner | In Progress | 03-injection/sql-injection/php-laravel-beginner.php |
| NoSQL Injection Prevention | Node.js | Express + Mongoose | Beginner | In Progress | 03-injection/nosql-injection/node-express-beginner.js |
| NoSQL Injection Prevention | Python | Flask + PyMongo | Intermediate | In Progress | 03-injection/nosql-injection/python-flask-intermediate.py |
| Command Injection Prevention | Python | None | Beginner | In Progress | 03-injection/command-injection/python-beginner.py |
| Command Injection Prevention | Node.js | None | Beginner | In Progress | 03-injection/command-injection/node-beginner.js |
| Command Injection Prevention | Go | None | Advanced | In Progress | 03-injection/command-injection/go-advanced.go |
| LDAP Injection Prevention | Java | Spring Boot | Advanced | In Progress | 03-injection/ldap-injection/java-spring-advanced.java |
| LDAP Injection Prevention | Python | None | Intermediate | In Progress | 03-injection/ldap-injection/python-intermediate.py |
| XSS Prevention — Output Encoding | Python | Flask + Jinja2 | Beginner | In Progress | 03-injection/xss/python-flask-beginner.py |
| XSS Prevention — Output Encoding | Node.js | Express + helmet | Beginner | In Progress | 03-injection/xss/node-express-beginner.js |
| XSS Prevention — DOMPurify | JavaScript | None (frontend) | Intermediate | In Progress | 03-injection/xss/javascript-frontend-intermediate.js |
| XSS Prevention — Content Security Policy | Config | None | Intermediate | In Progress | 03-injection/xss/csp-intermediate.md |

---

## A04 — Insecure Design

Insecure design refers to missing or ineffective security controls that result from design choices rather than implementation bugs. You cannot fix insecure design by writing better code — the architecture itself is the problem. Rate limiting, input validation, anti-automation controls, and threat modelling address this category.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Rate Limiting — Redis-backed | Python | Flask + Redis | Intermediate | In Progress | 04-insecure-design/rate-limiting/python-flask-redis-intermediate.py |
| Rate Limiting — In-memory sliding window | Node.js | Express | Beginner | In Progress | 04-insecure-design/rate-limiting/node-express-beginner.js |
| Rate Limiting — express-rate-limit | Node.js | Express | Beginner | In Progress | 04-insecure-design/rate-limiting/node-express-ratelimit-beginner.js |
| Rate Limiting — Redis-backed | Go | Gin | Advanced | In Progress | 04-insecure-design/rate-limiting/go-gin-redis-advanced.go |
| Input Validation — Schema validation | Python | FastAPI | Beginner | In Progress | 04-insecure-design/input-validation/python-fastapi-beginner.py |
| Input Validation — Joi schema | Node.js | Express | Beginner | In Progress | 04-insecure-design/input-validation/node-express-beginner.js |
| Input Validation — Bean Validation | Java | Spring Boot | Intermediate | In Progress | 04-insecure-design/input-validation/java-spring-intermediate.java |
| Threat Modelling — STRIDE Template | Documentation | None | All levels | In Progress | 04-insecure-design/threat-modeling-templates/ |

---

## A05 — Security Misconfiguration

Security misconfiguration is the most common finding in penetration tests. It includes missing security headers, open cloud storage buckets, default credentials left in place, verbose error messages that reveal stack traces, unnecessary features enabled, and improperly configured permissions.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Content Security Policy (CSP) header | Node.js | Express + helmet | Beginner | In Progress | 05-security-misconfiguration/security-headers/csp/node-express-beginner.js |
| Content Security Policy (CSP) header | Python | Flask | Beginner | In Progress | 05-security-misconfiguration/security-headers/csp/python-flask-beginner.py |
| CSP — Strict policy with nonces | Node.js | Express | Advanced | In Progress | 05-security-misconfiguration/security-headers/csp/node-express-advanced.js |
| CORS configuration — Restrictive | Node.js | Express | Beginner | In Progress | 05-security-misconfiguration/security-headers/cors/node-express-beginner.js |
| CORS configuration — Restrictive | Python | Flask | Beginner | In Progress | 05-security-misconfiguration/security-headers/cors/python-flask-beginner.py |
| CORS configuration — Dynamic origin validation | Go | Gin | Advanced | In Progress | 05-security-misconfiguration/security-headers/cors/go-gin-advanced.go |
| HSTS header | Node.js | Express | Beginner | In Progress | 05-security-misconfiguration/security-headers/hsts/node-express-beginner.js |
| HSTS header | Python | Flask | Beginner | In Progress | 05-security-misconfiguration/security-headers/hsts/python-flask-beginner.py |
| HSTS — Nginx config | Config | Nginx | Intermediate | In Progress | 05-security-misconfiguration/security-headers/hsts/nginx-intermediate.conf |
| X-Frame-Options header | Node.js | Express | Beginner | In Progress | 05-security-misconfiguration/security-headers/x-frame-options/node-express-beginner.js |
| X-Frame-Options header | Python | Flask | Beginner | In Progress | 05-security-misconfiguration/security-headers/x-frame-options/python-flask-beginner.py |
| Safe error handling — No stack traces | Python | Flask | Beginner | In Progress | 05-security-misconfiguration/error-handling/python-flask-beginner.py |
| Safe error handling — No stack traces | Node.js | Express | Beginner | In Progress | 05-security-misconfiguration/error-handling/node-express-beginner.js |
| Server hardening — Linux checklist | Config | None | Advanced | In Progress | 05-security-misconfiguration/server-hardening/ |

---

## A06 — Vulnerable and Outdated Components

Using components with known vulnerabilities is one of the most avoidable categories. Frameworks, libraries, and other software components run with the same privileges as the application itself. If a component has a known CVE, an attacker can use published exploit code against your application.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Dependency audit — npm | JavaScript | Node.js | Beginner | In Progress | 06-vulnerable-components/dependency-scanning/node-beginner.md |
| Dependency audit — pip-audit | Python | None | Beginner | In Progress | 06-vulnerable-components/dependency-scanning/python-beginner.md |
| Dependency audit — go mod verify | Go | None | Intermediate | In Progress | 06-vulnerable-components/dependency-scanning/go-intermediate.md |
| Dependency audit — cargo audit | Rust | None | Intermediate | In Progress | 06-vulnerable-components/dependency-scanning/rust-intermediate.md |
| Automated dependency updates — Dependabot | Config | GitHub | Beginner | In Progress | 06-vulnerable-components/update-policies/dependabot-beginner.yml |
| Automated dependency updates — Renovate | Config | Any | Intermediate | In Progress | 06-vulnerable-components/update-policies/renovate-intermediate.json |
| CI vulnerability gate — GitHub Actions | Config | GitHub Actions | Intermediate | In Progress | 06-vulnerable-components/dependency-scanning/github-actions-intermediate.yml |

---

## A07 — Identification and Authentication Failures

This category covers failures in authentication and session management. Weak passwords, missing multi-factor authentication, broken session invalidation, credential stuffing vulnerabilities, and insecure token handling all fall here. This is one of the most targeted categories because authentication is the gate to everything else.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| JWT — HS256 generation and validation | Python | Flask | Beginner | In Progress | 07-auth-failures/jwt/python-flask-beginner.py |
| JWT — RS256 asymmetric signing | Python | Flask | Advanced | In Progress | 07-auth-failures/jwt/python-flask-advanced.py |
| JWT — HS256 generation and validation | Node.js | Express | Beginner | In Progress | 07-auth-failures/jwt/node-express-beginner.js |
| JWT — RS256 with JWKS endpoint | Node.js | Express | Advanced | In Progress | 07-auth-failures/jwt/node-express-advanced.js |
| JWT — RS256 asymmetric signing | Go | Gin | Advanced | In Progress | 07-auth-failures/jwt/go-gin-advanced.go |
| JWT — Spring Security | Java | Spring Boot | Advanced | In Progress | 07-auth-failures/jwt/java-spring-advanced.java |
| Session Management — Secure session config | Python | Flask | Beginner | In Progress | 07-auth-failures/session-management/python-flask-beginner.py |
| Session Management — Secure session config | Node.js | Express | Beginner | In Progress | 07-auth-failures/session-management/node-express-beginner.js |
| Session Management — Redis-backed sessions | Node.js | Express | Intermediate | In Progress | 07-auth-failures/session-management/node-express-redis-intermediate.js |
| MFA — TOTP (Google Authenticator compatible) | Python | Flask | Intermediate | In Progress | 07-auth-failures/mfa/python-flask-totp-intermediate.py |
| MFA — TOTP | Node.js | Express | Intermediate | In Progress | 07-auth-failures/mfa/node-express-totp-intermediate.js |
| MFA — SMS OTP | Node.js | Express + Twilio | Intermediate | In Progress | 07-auth-failures/mfa/node-express-sms-intermediate.js |
| OAuth2 — Authorization Code Flow | Node.js | Express | Intermediate | In Progress | 07-auth-failures/oauth2/node-express-intermediate.js |
| OAuth2 — Authorization Code Flow | Python | Flask | Intermediate | In Progress | 07-auth-failures/oauth2/python-flask-intermediate.py |
| OAuth2 — PKCE | JavaScript | Frontend | Advanced | In Progress | 07-auth-failures/oauth2/javascript-pkce-advanced.js |
| Magic Links | Node.js | Express | Intermediate | In Progress | 07-auth-failures/magic-links/node-express-intermediate.js |
| Magic Links | Python | Flask | Intermediate | In Progress | 07-auth-failures/magic-links/python-flask-intermediate.py |
| Passkeys — WebAuthn registration | Node.js | Express | Advanced | In Progress | 07-auth-failures/passkeys/node-express-advanced.js |
| Passkeys — WebAuthn authentication | Node.js | Express | Advanced | In Progress | 07-auth-failures/passkeys/node-express-webauthn-advanced.js |

---

## A08 — Software and Data Integrity Failures

This category covers assumptions about software updates, CI/CD pipelines, and critical data without verifying integrity. Unsigned updates, use of untrusted CDN resources without integrity checks, and deserialization of untrusted data all fall here. Supply chain attacks — where malicious code is injected into a dependency — are the most high-profile manifestation.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Subresource Integrity — CDN script tags | HTML | None | Beginner | In Progress | 08-software-integrity/subresource-integrity/html-beginner.html |
| Subresource Integrity — Template helper | Node.js | Express | Intermediate | In Progress | 08-software-integrity/subresource-integrity/node-express-intermediate.js |
| Signed Commits — GPG setup guide | Documentation | Git | Beginner | In Progress | 08-software-integrity/signed-commits/ |
| CI/CD Security — GitHub Actions hardening | Config | GitHub Actions | Intermediate | In Progress | 08-software-integrity/ci-cd-security/github-actions-intermediate.yml |
| CI/CD Security — Pinned action versions | Config | GitHub Actions | Advanced | In Progress | 08-software-integrity/ci-cd-security/pinned-actions-advanced.yml |
| CI/CD Security — Secret scanning | Config | GitHub Actions | Intermediate | In Progress | 08-software-integrity/ci-cd-security/secret-scanning-intermediate.yml |

---

## A09 — Security Logging and Monitoring Failures

Applications that do not log security events cannot detect breaches, respond to incidents, or prove compliance. This category covers missing audit logs, logs that do not contain enough information to reconstruct an incident, logs that are not monitored, and alerting systems that do not trigger on meaningful events.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Audit Logging — Structured JSON logs | Python | Flask | Beginner | In Progress | 09-logging-monitoring/audit-logging/python-flask-beginner.py |
| Audit Logging — Structured JSON logs | Node.js | Express + Winston | Beginner | In Progress | 09-logging-monitoring/audit-logging/node-express-beginner.js |
| Audit Logging — Structured logs with correlation IDs | Go | Gin | Advanced | In Progress | 09-logging-monitoring/audit-logging/go-gin-advanced.go |
| Intrusion Detection — Failed login alerting | Python | Flask | Intermediate | In Progress | 09-logging-monitoring/intrusion-detection/python-flask-intermediate.py |
| Intrusion Detection — Anomaly detection hook | Node.js | Express | Intermediate | In Progress | 09-logging-monitoring/intrusion-detection/node-express-intermediate.js |
| Alerting — Slack webhook on security event | Python | None | Beginner | In Progress | 09-logging-monitoring/alerting/python-slack-beginner.py |
| Alerting — PagerDuty integration | Node.js | None | Advanced | In Progress | 09-logging-monitoring/alerting/node-pagerduty-advanced.js |

---

## A10 — Server-Side Request Forgery (SSRF)

SSRF vulnerabilities allow attackers to induce the server to make HTTP requests to unintended locations. In cloud environments, this is especially dangerous because it can expose internal metadata services (such as the AWS EC2 metadata endpoint at 169.254.169.254) which may contain credentials and configuration. SSRF typically occurs when user-supplied URLs are fetched server-side without validation.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| URL Validation — Allowlist approach | Python | Flask | Beginner | In Progress | 10-ssrf/url-validation/python-flask-beginner.py |
| URL Validation — Allowlist approach | Node.js | Express | Beginner | In Progress | 10-ssrf/url-validation/node-express-beginner.js |
| URL Validation — DNS rebinding protection | Go | Gin | Advanced | In Progress | 10-ssrf/url-validation/go-gin-advanced.go |
| Allowlist Patterns — Domain and IP filtering | Python | None | Intermediate | In Progress | 10-ssrf/allowlist-patterns/python-intermediate.py |
| Allowlist Patterns — Domain and IP filtering | Node.js | None | Intermediate | In Progress | 10-ssrf/allowlist-patterns/node-intermediate.js |
| Private IP range blocking | Go | None | Advanced | In Progress | 10-ssrf/allowlist-patterns/go-advanced.go |

---

## Beyond OWASP — Advanced Category

These snippets address security concerns that go beyond the OWASP Top 10. They are intended for experienced engineers who are hardening applications beyond baseline compliance.

| Snippet | Language | Framework | Level | Status | Path |
|---------|----------|-----------|-------|--------|------|
| Zero Trust — mTLS between services | Go | None | Advanced | In Progress | advanced/zero-trust/ |
| Zero Trust — Service identity with SPIFFE | Config | None | Advanced | Needed | advanced/zero-trust/ |
| Secrets Management — HashiCorp Vault | Python | None | Advanced | In Progress | advanced/secrets-management/ |
| Secrets Management — AWS Secrets Manager | Node.js | None | Advanced | In Progress | advanced/secrets-management/ |
| Honeypot — Fake admin route detection | Python | Flask | Intermediate | In Progress | advanced/honeypots/ |
| Honeypot — Fake admin route detection | Node.js | Express | Intermediate | In Progress | advanced/honeypots/ |
| Canary Token — Database field canary | Python | None | Advanced | In Progress | advanced/canary-tokens/ |
| Certificate Pinning — Mobile API | Python | None | Advanced | In Progress | advanced/certificate-pinning/ |
| Supply Chain Security — SBOM generation | Config | None | Advanced | In Progress | advanced/supply-chain-security/ |
| Supply Chain Security — Sigstore / cosign | Config | None | Advanced | In Progress | advanced/supply-chain-security/ |

---

## Contributing to This Map

When you add a new snippet to the library, you must also update this document. Add a row to the relevant table. If your snippet covers a risk not yet in this map, open an issue to discuss whether it warrants a new section.

This document is the single source of truth for coverage. Keeping it accurate is a shared responsibility.
