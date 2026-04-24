# 🔐 web-security-snippets

> A structured, multi-language, multi-level reference library of web application security patterns — built for developers who ship production code and the teams that review it.

---

<div align="center">

![Security](https://img.shields.io/badge/Security-OWASP%20Top%2010-red?style=for-the-badge)
![Languages](https://img.shields.io/badge/Languages-8+-blue?style=for-the-badge)
![Frameworks](https://img.shields.io/badge/Frameworks-20+-green?style=for-the-badge)
![Level](https://img.shields.io/badge/Level-Beginner%20→%20Expert-orange?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![PRs Welcome](https://img.shields.io/badge/PRs-Welcome-brightgreen?style=for-the-badge)

</div>

---

## 📌 What Is This?

**web-security-snippets** is not a tutorial. It is not a course. It is not a blog post series.

It is a **living reference library** — a place developers, team leads, and security-conscious project managers come to find the exact code pattern they need, in the language and framework they are already using, at the complexity level that matches their experience.

Every snippet in this library exists because a real web application was compromised, a real vulnerability was exploited, or a real security control was implemented wrong. This is not theoretical. This is production-grade, opinionated, and direct.

Whether you are a junior developer adding your first authentication layer, a mid-level engineer hardening an existing API, or a senior architect reviewing a team's security posture — this library has something for you.

---

## 🧭 How To Navigate This Repo

This library is organized by **OWASP Top 10** security risk categories. Each category contains:

- A `README.md` explaining what the risk is, why it matters, and a real-world breach that happened because of it
- Code snippets organized by **language**, **framework**, and **experience level**
- Dependency files (`requirements.txt`, `package.json`, `go.mod`, etc.) with **pinned versions**
- An `integrations/` subfolder with drop-in patches for existing applications

```
web-security-snippets/
│
├── 01-broken-access-control/
├── 02-cryptographic-failures/
├── 03-injection/
├── 04-insecure-design/
├── 05-security-misconfiguration/
├── 06-vulnerable-components/
├── 07-auth-failures/
├── 08-software-integrity/
├── 09-logging-monitoring/
├── 10-ssrf/
│
├── advanced/                   ← Beyond OWASP — zero trust, honeypots, supply chain
└── integrations/               ← Drop into your existing app
```

---

## 🎯 Who This Is For

This library is intentionally written for **three distinct audiences.** You will find your level immediately.

---

### 🟢 Junior Developers & Learners

You are building your first authenticated application. You have heard terms like "SQL injection" or "JWT" but have not implemented them in a production context. You need explanation alongside the code.

**What you will find:**
- Heavy inline comments explaining not just *what* the code does but *why* it exists
- Plain-English breakdowns of each security concept
- Clear `# REPLACE THIS` markers so you know exactly what to change
- Dependency files so you know exactly what to install and how
- Real-world examples of what happens when this is skipped

**Start here:** Pick any `beginner` file in any category. Read the category `README.md` first. Install the dependencies. Replace the marked values. You are done.

---

### 🟡 Mid-Level Engineers & Team Leads

You know the fundamentals. You have shipped applications before. You need patterns that fit into an existing codebase without a full rewrite, and you need them in the specific framework your team is using.

**What you will find:**
- Clean, framework-specific implementations with moderate comments
- `integrations/` folders showing how to bolt a security layer onto an existing app
- Notes on what each pattern does and does not protect against
- Version-pinned dependencies so your team's setup is reproducible

**Start here:** Go directly to the category you need. Pick your language and framework. Check the `integrations/` folder if you are patching an existing app rather than starting fresh.

---

### 🔴 Senior Engineers, Architects & Project Managers

You have seen what happens when security is an afterthought. You do not need explanation — you need clean, production-ready reference implementations you can adapt, review, or hand to your team.

**What you will find:**
- Minimal-comment advanced files — the pattern is self-evident
- Architectural decision notes where the implementation requires a structural choice
- Framework-agnostic patterns written at the language level for maximum portability
- The `advanced/` section covering zero-trust, secrets management, supply chain security, and more

**Start here:** Go straight to the file. If you have a question about the pattern, the category `README.md` has the context. Everything else is in the code.

---

## 📖 Understanding the Snippet Format

Every snippet in this library follows a consistent header format so you can assess it in seconds:

```
# Feature        : SQL Injection Prevention — Parameterized Queries
# Language       : Python
# Framework      : Flask + SQLAlchemy
# Level          : 🟢 Beginner
# OWASP          : A03 - Injection
# Protects       : Against user-controlled input reaching raw SQL queries
# Does NOT cover : Application logic flaws, compromised DB credentials
# Dependencies   : See requirements.txt in this folder
# Tested on      : Python 3.11, Flask 3.0, SQLAlchemy 2.0
```

---

## 🌐 Languages & Frameworks Covered

| Language | Frameworks |
|----------|------------|
| **Python** | Flask, Django, FastAPI |
| **JavaScript / TypeScript** | Express, Fastify, NestJS, Next.js |
| **Go** | Gin, Echo, Fiber |
| **Java** | Spring Boot |
| **PHP** | Laravel |
| **Ruby** | Rails |
| **Rust** | Axum |
| **C#** | ASP.NET Core |

> Coverage grows with contributions. If your language or framework is missing, see [CONTRIBUTING.md](./CONTRIBUTING.md).

---

## 🔢 Difficulty Levels Explained

| Level | Label | Who It's For | Comment Density |
|-------|-------|-------------|-----------------|
| 🟢 | **Beginner / Drop-in** | Junior devs, learners | Heavy — explains every decision |
| 🟡 | **Intermediate / Needs Config** | Mid-level engineers | Moderate — explains non-obvious parts |
| 🔴 | **Advanced / Architectural** | Seniors, architects | Minimal — the code speaks for itself |

Files are named to reflect their level:
```
python-flask-beginner.py
python-flask-advanced.py
node-express-intermediate.js
```

---

## 📦 Dependencies — How They Work Here

Every folder that contains code also contains the relevant dependency file for each language. Dependencies are **always pinned to a specific version** to ensure snippets work as written.

### Python
```bash
pip install -r requirements.txt
```

### Node.js
```bash
npm install
```

### Go
```bash
go mod tidy
```

### PHP
```bash
composer install
```

### Ruby
```bash
bundle install
```

### Rust
```bash
cargo build
```

### C#
```bash
dotnet restore
```

> ⚠️ **Important:** Do not blindly upgrade pinned versions without testing. Security libraries have breaking changes between versions that can silently remove protections.

---

## 🗺️ OWASP Top 10 — Coverage Map

| # | Category | Status |
|---|----------|--------|
| A01 | Broken Access Control | 🔄 In progress |
| A02 | Cryptographic Failures | 🔄 In progress |
| A03 | Injection | 🔄 In progress |
| A04 | Insecure Design | 🔄 In progress |
| A05 | Security Misconfiguration | 🔄 In progress |
| A06 | Vulnerable & Outdated Components | 🔄 In progress |
| A07 | Identification & Authentication Failures | 🔄 In progress |
| A08 | Software & Data Integrity Failures | 🔄 In progress |
| A09 | Security Logging & Monitoring Failures | 🔄 In progress |
| A10 | Server-Side Request Forgery (SSRF) | 🔄 In progress |
| ⬆️ | Advanced (Beyond OWASP) | 🔄 In progress |

---

## 🚨 What This Library Is Not

Read this before using any snippet in production.

- **This is not a security audit.** Snippets are reference implementations, not a guarantee your application is secure. Security requires threat modelling, architecture review, and testing.

- **This is not a substitute for understanding.** Copying code you do not understand is how vulnerabilities get introduced. Read the category `README.md` before using any snippet.

- **This is not always complete protection.** Every snippet header lists what it does and does not protect against. Read that section. Defence in depth means layering multiple controls, not relying on one snippet.

- **This is not version-agnostic.** Snippets are tested against specific versions. If you are on a different version, verify compatibility.

---

## 🔧 Using the `integrations/` Folder

The `integrations/` folder contains **drop-in patches** — complete, self-contained implementations you can add to an existing application without restructuring it.

Each integration includes:
- A `README.md` with prerequisites and integration steps
- All required files for each supported language and framework
- Before/after examples showing where the code goes in a typical app structure

Available integrations:
```
integrations/
├── add-jwt-to-existing-api/
├── add-mfa-to-login/
├── add-rate-limiting-to-login/
├── add-rbac-to-existing-app/
└── add-audit-logging/
```

---

## 🤝 Contributing

This library grows through contributions. If you want to add a snippet, fix an existing one, or add a new language:

1. Read [CONTRIBUTING.md](./CONTRIBUTING.md) — it explains the exact format every snippet must follow
2. Open an issue before starting large additions so we can coordinate
3. Use the snippet header template exactly as defined
4. Include the dependency file for your language
5. Write at least a beginner-level version with full comments

**First time contributing to open source?** Look for issues labelled `good first issue` — these are specifically scoped for new contributors and are a great way to get started.

---

## 🔒 Security Disclosure

If you find a snippet in this library that is **itself insecure** — a flawed implementation, a dangerous pattern, a vulnerable dependency — please do not open a public issue.

Report it privately via: **[lethabokhedama@gmail.com]**

Include:
- The file path of the affected snippet
- A description of the vulnerability
- If possible, a corrected version

We take this seriously. A security reference library with bad security advice is worse than no library at all.

---

## 📄 License

MIT License — see [LICENSE](./LICENSE) for details.

You are free to use any snippet in this library in personal or commercial projects. Attribution is appreciated but not required.

---

## ⭐ Support the Project

If this library saved you time, helped your team ship more securely, or taught you something new:

- **Star the repo** — it helps other developers find it
- **Share it** — with your team, on LinkedIn, Reddit, or wherever developers in your network gather
- **Contribute** — even fixing a typo or adding a missing comment helps
- **Sponsor** — if your company uses this library professionally, consider supporting it via [GitHub Sponsors]

---

<div align="center">

**Built for developers. Maintained by the community. Secured by design.**

[⭐ Star this repo](https://github.com/lethabokhedama-png/web-security-snippets) · [🐛 Report an Issue](https://github.com/lethabokhedama-png/web-security-snippets/issues) · [🤝 Contribute](./CONTRIBUTING.md)

</div>
