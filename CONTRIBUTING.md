# Contributing to web-security-snippets

Thank you for taking the time to contribute. This library exists because security-conscious developers choose to share what they know. Every snippet added here could prevent a breach, protect user data, or save a team hours of research. That is not a small thing.

This document explains exactly how contributions work, what the standards are, and what you need to do to get a pull request merged. Please read it in full before opening a PR.

---

## Table of Contents

- [Who Should Contribute](#who-should-contribute)
- [What We Accept](#what-we-accept)
- [What We Do Not Accept](#what-we-do-not-accept)
- [The Snippet Standard](#the-snippet-standard)
- [File Naming Convention](#file-naming-convention)
- [Dependency Files](#dependency-files)
- [Comment Standards by Level](#comment-standards-by-level)
- [The Required Header Block](#the-required-header-block)
- [How to Submit a Pull Request](#how-to-submit-a-pull-request)
- [Reviewing Others' Contributions](#reviewing-others-contributions)
- [Reporting a Broken or Insecure Snippet](#reporting-a-broken-or-insecure-snippet)
- [Code of Conduct](#code-of-conduct)

---

## Who Should Contribute

Anyone. Junior developers who just learned something the hard way. Senior engineers who have implemented a pattern dozens of times and want to document it properly. Security researchers who spot a gap. DevOps engineers who know how server hardening actually works in production. Project managers who want to improve the documentation.

You do not need to be a security expert to contribute. You do need to be honest about your level of knowledge. If you are unsure whether a pattern is correct, say so in the PR description and request a review from someone with more context.

---

## What We Accept

**New snippets** for languages or frameworks not yet covered in an existing category. Before writing one, check the category folder to confirm your language is genuinely missing.

**New difficulty levels** for existing snippets. If a category has an advanced file but no beginner file, adding the beginner version with full comments is a valuable contribution.

**New categories** that represent a real, documented security risk not already covered. Open an issue first so the structure can be agreed on before you write the code.

**Bug fixes and corrections** to existing snippets. If a snippet has a vulnerability, an outdated dependency, or incorrect logic, a correction PR is the most urgent kind of contribution this repo accepts.

**Documentation improvements** to any README.md file. If an explanation is unclear, incomplete, or inaccurate, fix it.

**New integration guides** in the integrations folder. These must be complete, working implementations — not outlines or half-finished patches.

---

## What We Do Not Accept

**Snippets that introduce new vulnerabilities.** This sounds obvious but it happens. A JWT implementation that skips signature verification, a password hasher using MD5, a CORS config that allows all origins — these will be rejected immediately.

**Untested code.** Every snippet must have been run against the stated language version and framework version. If you have not run it, do not submit it.

**Snippets without pinned dependency versions.** Floating versions like `>=1.0` are not acceptable. Pin to the exact version you tested against.

**Snippets without the required header block.** The header is not optional. It is how users assess a snippet in seconds. PRs missing the header will not be reviewed until it is added.

**Snippets that duplicate existing coverage without improving on it.** If a Python Flask beginner file already exists for SQL injection prevention, submitting another one that is essentially the same adds noise, not value. Improve the existing one instead.

**Marketing language or product promotion.** Snippets that recommend a specific paid service, SDK, or platform without a genuine technical reason will be removed.

---

## The Snippet Standard

Every code file in this repository must follow this structure exactly, in this order:

1. The required header block
2. Any imports or package declarations
3. The dependency installation comment
4. The code itself
5. A usage example at the bottom (where applicable)

Nothing before the header. Nothing after the usage example. No extra commentary outside of inline comments.

---

## File Naming Convention

Files are named using this pattern:

```
{language}-{framework}-{level}.{extension}
```

Examples:

```
python-flask-beginner.py
python-flask-advanced.py
python-django-intermediate.py
node-express-beginner.js
node-express-advanced.js
node-fastify-intermediate.js
go-gin-beginner.go
go-gin-advanced.go
java-spring-advanced.java
php-laravel-beginner.php
ruby-rails-intermediate.rb
rust-axum-advanced.rs
csharp-aspnet-intermediate.cs
```

If there is no framework (language-level implementation only):

```
python-beginner.py
go-advanced.go
```

Do not use abbreviations in file names. Do not use version numbers in file names. Do not use underscores — use hyphens.

---

## Dependency Files

Every folder that contains code files must also contain the relevant dependency file for each language represented. Dependency files must use exact pinned versions.

**Python — requirements.txt**
```
bcrypt==4.1.3
PyJWT==2.8.0
cryptography==42.0.5
```

**Node.js — package.json**
```json
{
  "dependencies": {
    "jsonwebtoken": "9.0.2",
    "bcryptjs": "2.4.3"
  }
}
```

**Go — go.mod**
```
module example.com/security

go 1.22

require (
    github.com/golang-jwt/jwt/v5 v5.2.1
    golang.org/x/crypto v0.21.0
)
```

**PHP — composer.json**
```json
{
  "require": {
    "firebase/php-jwt": "6.10.0"
  }
}
```

**Ruby — Gemfile**
```ruby
gem 'bcrypt', '3.1.20'
gem 'jwt', '2.8.1'
```

**Rust — Cargo.toml**
```toml
[dependencies]
argon2 = "0.5.3"
jsonwebtoken = "9.3.0"
```

**C# — packages listed in csproj snippet at top of file**

If you are contributing a new language, add the appropriate dependency format to this document in a PR alongside your code.

---

## Comment Standards by Level

### Beginner Files

Beginner files are written for developers who are implementing this security control for the first time. Comments must explain:

- **Why this control exists** — what attack does it prevent, and what happens if it is skipped
- **What each significant line does** — not every single line, but any line that is not self-evident
- **What the developer must replace** — every placeholder value must be marked clearly
- **What not to do** — common mistakes that look correct but introduce vulnerabilities

Comments in beginner files should be written in plain English. Avoid jargon unless it is immediately explained. Write as if the reader is competent but encountering this specific concept for the first time.

### Intermediate Files

Intermediate files assume the reader understands the concept being implemented. Comments should:

- Explain non-obvious implementation choices
- Note configuration values that must be adjusted for different environments
- Flag anything that has a meaningful security implication if changed incorrectly

### Advanced Files

Advanced files are for experienced engineers who need a clean reference implementation. Comments should be minimal — only present when the code makes a non-obvious trade-off or when a specific value has a security implication that is not immediately apparent from context. Advanced files should be readable at a glance.

---

## The Required Header Block

Every code file must begin with this header, filled in completely:

```
# Feature        : [What this implements, in plain English]
# Language       : [Language name and version]
# Framework      : [Framework name and version, or "None — standard library only"]
# Level          : [Beginner / Intermediate / Advanced]
# OWASP          : [Category code and name, e.g. A07 - Identification and Authentication Failures]
# Protects       : [What attack or failure mode this prevents]
# Does NOT cover : [What this does not protect against — be specific]
# Dependencies   : [See requirements.txt / package.json / go.mod in this folder]
# Tested on      : [Language version, framework version, OS if relevant]
# Last reviewed  : [YYYY-MM-DD]
```

The language used in this header must match the language used in the file name. The OWASP category must match the folder the file lives in. If a snippet crosses categories, place it in the most relevant one and note the secondary category in the header.

---

## How to Submit a Pull Request

**Step one:** Fork the repository and create a branch named after what you are adding.

```bash
git checkout -b add/python-flask-jwt-beginner
git checkout -b fix/node-express-sql-injection-advanced
git checkout -b docs/improve-rbac-readme
```

**Step two:** Make your changes. Follow every standard in this document.

**Step three:** Test your code. Run it. If it is a snippet that requires a running server, test it against one. If it is a configuration file, validate it. If it is documentation, read it as if you are seeing it for the first time.

**Step four:** Open a pull request with a title that follows this format:

```
[add] Python Flask — JWT authentication (beginner)
[fix] Node Express — SQL injection prevention had unsafe fallback
[docs] RBAC README — clarified role hierarchy explanation
[lang] Go Fiber — add password hashing (intermediate)
```

**Step five:** Fill in the PR description with:
- What you added or changed and why
- What version you tested against
- Any known limitations or edge cases
- Whether this was a fix for an existing issue (link the issue if so)

Pull requests that do not follow this format will be asked to revise before review begins.

---

## Reviewing Others' Contributions

Code review on this repository is security review. When reviewing a PR, check:

- Does the code actually implement the security control it claims to?
- Are there any edge cases where the protection could be bypassed?
- Are the dependency versions pinned and current?
- Does the header accurately describe what the code does and does not protect against?
- Are the comments accurate and clear for the stated difficulty level?
- Does the file name follow the convention?

Leave specific, actionable feedback. If you find a vulnerability in a submitted snippet, describe it clearly but do not post a working exploit in the public review thread.

---

## Reporting a Broken or Insecure Snippet

If you find a snippet in this library that is itself insecure — a flawed implementation, an outdated cryptographic primitive, a dangerous default, or a vulnerable dependency — do not open a public issue.

Send an email to **lethabokhedama@gmail.com** with:

- The exact file path of the affected snippet
- A clear description of the vulnerability
- The impact: what an attacker could do by exploiting it
- If possible, a corrected version of the code

We treat these reports with the same seriousness as a vulnerability disclosure against production software. A security reference library with bad advice is more dangerous than no library at all.

---

## Code of Conduct

This project is a professional resource. Contributions are evaluated on technical merit and adherence to the standards in this document. Treat other contributors with respect. Disagreements about implementation choices are resolved through technical discussion, not personal criticism.

Any contributor who harasses, demeans, or acts in bad faith toward another contributor will be removed from the project.

---

Thank you for contributing. Every addition makes this library more useful for every developer who finds it.
