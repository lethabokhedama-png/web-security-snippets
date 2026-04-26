<div align="center">

# 🔐 web-security-snippets

**A production-grade, multi-language security reference library built for developers who ship real software.**

Not a course. Not a tutorial. Not a blog post.
A library you open when you need working security code — right now — in the language you are already using.

---

[![OWASP Top 10](https://img.shields.io/badge/OWASP-Top%2010%20%282021%29-red?style=flat-square)](https://owasp.org/www-project-top-ten/)
[![Languages](https://img.shields.io/badge/Languages-8-blue?style=flat-square)](#languages--frameworks)
[![Frameworks](https://img.shields.io/badge/Frameworks-20+-green?style=flat-square)](#languages--frameworks)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen?style=flat-square)](./CONTRIBUTING.md)
[![Security Policy](https://img.shields.io/badge/Security-Policy-orange?style=flat-square)](./SECURITY.md)

</div>

---

## What This Is

Every security control in a web application — authentication, access control, injection prevention, encryption, logging — has been implemented correctly and incorrectly by thousands of teams before yours. The correct implementations follow consistent, well-understood patterns. The incorrect ones follow consistent, well-understood mistakes.

This library documents the correct patterns across eight languages, twenty frameworks, and three experience levels. Every snippet includes the dependencies required to run it, comments calibrated to the reader's experience level, and a clear statement of what it protects against and what it does not.

When your team needs to implement JWT authentication, prevent SQL injection, add rate limiting to a login endpoint, or configure a Content Security Policy — this is the first place to look.

---

## Who This Is For

This library is written for three distinct audiences. You will recognise yourself immediately.

---

### 🟢 Junior Developers and Learners

You are building your first production application. Security concepts like CSRF, XSS, and SQL injection are familiar names but you have not implemented defences against them yet. You are not sure which library to use, what configuration is safe, or what the difference is between hashing and encrypting a password.

Every beginner file in this library is written for you. The comments explain not just what the code does but why it exists — what attack it prevents, what happens to real applications that skip it, and exactly which values you need to replace with your own. You will also find the exact install command for every dependency.

**Start here:** Read the category `README.md` for any topic that interests you. Then open the `beginner` file for your language. Read everything. Replace the marked values. You are done.

---

### 🟡 Mid-Level Engineers and Team Leads

You understand the fundamentals. You have shipped applications before. You need patterns that fit into an existing codebase, work with the specific framework your team chose, and do not require a full architectural rewrite to add.

The intermediate files and the `integrations/` folder are built for you. Moderate comments explain non-obvious decisions. Integration guides show you where the code slots into a typical existing application — what changes before the addition and what changes after.

**Start here:** Go directly to the category. Pick your language and framework. Check `integrations/` if you are patching an existing app rather than building from scratch.

---

### 🔴 Senior Engineers, Architects, and Project Managers

You have seen what happens when security is treated as an afterthought. You do not need explanation. You need a clean, production-ready reference implementation to review, adapt, or hand to your team with confidence.

The advanced files are written for you — minimal comments, maximum signal. The `advanced/` section covers patterns beyond the OWASP Top 10: zero trust architecture, enterprise secrets management, honeypots, canary tokens, certificate pinning, and supply chain security.

**Start here:** Navigate directly to the file. The header block tells you everything relevant in ten seconds. The `advanced/` section is yours.

---

## How to Navigate

The library is organised by the [OWASP Top 10 (2021)](https://owasp.org/www-project-top-ten/) — the most widely recognised classification of critical web application security risks. Every folder follows the same internal structure. Learn it once and you can find anything.

```
web-security-snippets/
│
├── 01-broken-access-control/       A01 — The most common web vulnerability
├── 02-cryptographic-failures/      A02 — Password hashing, encryption, TLS, key management
├── 03-injection/                   A03 — SQL, NoSQL, command, LDAP, XSS
├── 04-insecure-design/             A04 — Rate limiting, input validation, threat modelling
├── 05-security-misconfiguration/   A05 — Security headers, error handling, server hardening
├── 06-vulnerable-components/       A06 — Dependency scanning, automated updates
├── 07-auth-failures/               A07 — JWT, sessions, MFA, OAuth2, passkeys
├── 08-software-integrity/          A08 — SRI, signed commits, CI/CD pipeline security
├── 09-logging-monitoring/          A09 — Audit logging, intrusion detection, alerting
├── 10-ssrf/                        A10 — URL validation, allowlist patterns
│
├── advanced/                       Beyond OWASP — zero trust, secrets, honeypots
└── integrations/                   Drop into your existing app without a rewrite
```

### Inside Every Category Folder

```
{category}/
├── README.md                ← What this risk is, real breach examples, which snippet to use
└── {subcategory}/
    ├── README.md            ← Deep explanation of the specific pattern
    ├── requirements.txt     ← Python dependencies (pinned versions)
    ├── package.json         ← Node.js dependencies (pinned versions)
    ├── go.mod               ← Go dependencies
    ├── [other dep files]    ← Gemfile, Cargo.toml, pom.xml, composer.json
    ├── python-flask-beginner.py
    ├── python-flask-advanced.py
    ├── node-express-beginner.js
    ├── node-express-advanced.js
    └── [all other language files]
```

---

## Understanding Snippet Files

Every code file in this library begins with a standard header. Read it before using the snippet.

```
# Feature        : JWT Authentication — HS256 token generation and validation
# Language       : Python 3.11
# Framework      : Flask 3.0
# Level          : Beginner
# OWASP          : A07 — Identification and Authentication Failures
# Protects       : Against unauthenticated API access, session forgery
# Does NOT cover : Token revocation, refresh token rotation, MFA
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11.8, Flask 3.0.2
# Last reviewed  : 2024-03-01
```

The **Does NOT cover** line is as important as the **Protects** line. No single snippet is a complete security solution. Security is layered. This header tells you exactly what layer you are adding.

---

## Difficulty Levels

| Level | Who it's for | Comment style |
|-------|-------------|---------------|
| 🟢 **Beginner** | First time implementing this | Explains every decision in plain English |
| 🟡 **Intermediate** | Familiar with the concept, needs the pattern | Explains non-obvious choices |
| 🔴 **Advanced** | Experienced engineer, needs clean reference code | Minimal — the code speaks |

Files are named to reflect their level:

```
python-flask-beginner.py
python-flask-advanced.py
node-express-intermediate.js
go-gin-advanced.go
```

---

## Languages and Frameworks

| Language | Frameworks and Libraries |
|----------|--------------------------|
| **Python** | Flask, Django, FastAPI |
| **JavaScript / TypeScript** | Express, Fastify, NestJS, Next.js |
| **Go** | Gin, Echo |
| **Java** | Spring Boot |
| **PHP** | Laravel |
| **Ruby** | Rails |
| **Rust** | Axum |
| **C#** | ASP.NET Core |

Coverage grows with contributions. If your language or framework is missing from a category, see [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## Installing Dependencies

Every folder that contains code also contains the appropriate dependency file for each language represented. All versions are pinned exactly.

```bash
# Python
pip install -r requirements.txt

# Node.js
npm install

# Go
go mod tidy

# PHP
composer install

# Ruby
bundle install

# Rust
cargo build

# Java (Maven)
mvn install

# C# (.NET)
dotnet restore
```

> **Do not upgrade pinned versions without testing.** Security libraries have breaking changes between versions that can silently remove protections. Verify any version change before deploying.

---

## The integrations/ Folder

The `integrations/` folder is for teams with an existing application who need to add a security layer without restructuring their codebase. Each integration includes a before-and-after example showing exactly where the code goes in a typical application.

Available integrations:

| Integration | What it does |
|------------|-------------|
| `add-jwt-to-existing-api/` | Adds JWT authentication middleware to an unprotected API |
| `add-mfa-to-login/` | Adds TOTP-based multi-factor authentication to an existing login flow |
| `add-rate-limiting-to-login/` | Adds Redis-backed rate limiting to any login or sensitive endpoint |
| `add-rbac-to-existing-app/` | Adds role-based access control without rewriting route handlers |
| `add-audit-logging/` | Adds structured security audit logging as middleware |
| `add-csp-headers/` | Adds Content Security Policy headers to any web application |

---

## The advanced/ Section

The `advanced/` folder covers security patterns beyond baseline OWASP compliance. These are for teams operating high-value targets, regulated environments, or applications with elevated threat models.

| Section | What it covers |
|---------|---------------|
| `zero-trust/` | Mutual TLS between services, SPIFFE workload identity |
| `secrets-management/` | HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, Azure Key Vault |
| `honeypots/` | Decoy endpoints and database records for attacker detection |
| `canary-tokens/` | Embeddable tokens that alert on unauthorised access to sensitive data |
| `certificate-pinning/` | Binding clients to specific server certificates against CA compromise |
| `supply-chain-security/` | SBOM generation, Sigstore/cosign image signing, SLSA framework |

Comment density in the advanced section is minimal. Engineers working at this level are expected to evaluate and adapt implementations to their specific environment.

---

## What This Library Is Not

Read this before using any snippet in production.

**Not a security audit.** Snippets are reference implementations. They are not a guarantee that your application is secure. Security requires threat modelling, architecture review, penetration testing, and continuous monitoring alongside correct implementations.

**Not a substitute for understanding.** Copying code you do not understand is one of the most common ways vulnerabilities are introduced. Read the category `README.md` before using any snippet. The beginner files are written specifically to teach as they demonstrate.

**Not always complete protection.** Every snippet header lists exactly what it does and does not protect against. Defence in depth means layering multiple controls — no single snippet makes an application secure.

**Not version-agnostic.** Snippets are tested against specific versions of languages and frameworks. If you are on a different version, verify compatibility before deploying.

---

## OWASP Top 10 Coverage

| # | Category | Subcategories |
|---|----------|--------------|
| A01 | Broken Access Control | RBAC, ABAC, API key validation |
| A02 | Cryptographic Failures | Password hashing, encryption at rest, TLS config, key management |
| A03 | Injection | SQL, NoSQL, command, LDAP, XSS |
| A04 | Insecure Design | Rate limiting, input validation, threat modelling templates |
| A05 | Security Misconfiguration | CSP, CORS, HSTS, X-Frame-Options, error handling, server hardening |
| A06 | Vulnerable Components | Dependency scanning, automated update policies |
| A07 | Authentication Failures | JWT, sessions, MFA, OAuth2, magic links, passkeys |
| A08 | Software Integrity | Subresource integrity, signed commits, CI/CD security |
| A09 | Logging and Monitoring | Audit logging, intrusion detection, alerting |
| A10 | SSRF | URL validation, allowlist patterns |

Full snippet-level coverage map: [OWASP-MAP.md](./OWASP-MAP.md)

---

## Contributing

This library grows through contributions from developers who have implemented these patterns in production. If you want to add a snippet for a language not yet covered, fix an error in an existing snippet, or improve documentation:

1. Read [CONTRIBUTING.md](./CONTRIBUTING.md) — every contribution must follow the standards defined there
2. Open an issue before starting large additions to coordinate with maintainers
3. Submit a pull request using the provided template

First time contributing to open source? Look for issues labelled `good first issue`.

---

## Reporting a Security Issue in a Snippet

If you find a snippet in this library that is itself insecure — do not open a public issue. A public disclosure gives attackers time to exploit every developer who has already copied that snippet into production.

Report privately: **lethabokhedama@gmail.com**

Full disclosure policy: [SECURITY.md](./SECURITY.md)

---

## License

MIT — see [LICENSE](./LICENSE). Use any snippet in personal or commercial projects. Attribution is appreciated but not required.

---

## Support the Project

If this library helped your team ship more securely:

- **Star the repo** — it helps other developers find it when they need it
- **Share it** — with your team, in security communities, on LinkedIn, wherever developers who care about this work gather
- **Contribute** — a new language file, a corrected snippet, a clearer explanation
- **Sponsor** — if your organisation depends on this library, consider supporting its maintenance via [GitHub Sponsors](https://github.com/sponsors/lethabokhedama-png)

---

<div align="center">

**Built for developers. Maintained by the community. Secured by design.**

[⭐ Star](https://github.com/lethabokhedama-png/web-security-snippets) · [🐛 Issues](https://github.com/lethabokhedama-png/web-security-snippets/issues) · [🤝 Contribute](./CONTRIBUTING.md) · [🔒 Security](./SECURITY.md)

</div>
