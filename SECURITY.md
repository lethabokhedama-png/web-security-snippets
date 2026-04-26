# Security Policy

## Reporting a Vulnerability in This Library

This repository is a security reference library. If you have found a snippet, implementation, or piece of documentation within this library that is itself insecure — a flawed implementation, a dangerous pattern, a deprecated cryptographic primitive, a vulnerable pinned dependency, or incorrect security guidance — please report it privately before opening a public issue.

Publishing a security flaw in a security library publicly without notice gives malicious actors an opportunity to exploit every developer who has already copied that snippet into a production application before a fix can be issued.

---

## How to Report

**Email:** lethabokhedama@gmail.com

**Subject line:** `[SECURITY] web-security-snippets — <brief description>`

**Include in your report:**

- The exact file path of the affected snippet or documentation
- A clear description of the vulnerability or incorrect guidance
- The impact: what risk does this create for developers who use this snippet?
- The affected versions or the date range during which the flaw was present in the repository
- If possible, a corrected version of the code or documentation
- Your preferred attribution, if you would like to be credited in the fix commit

---

## What Qualifies for Private Disclosure

Report privately if you have found:

- A code snippet that introduces a vulnerability rather than preventing one (e.g., a JWT implementation that skips signature verification, a password hashing snippet using MD5, a CORS configuration that allows all origins)
- A dependency file that pins to a version with a known, exploitable CVE
- Documentation that gives incorrect security guidance which, if followed, would create a vulnerability
- A snippet that demonstrates the wrong approach while claiming to demonstrate the correct one

Do not report privately if you have found:

- A general question about how a snippet works
- A request to add a new snippet or language
- A disagreement about the best approach to a security control (open an issue for discussion)

---

## Response Timeline

We aim to acknowledge receipt of security reports within 48 hours. We aim to have a corrected snippet committed within 7 days of confirmation that a reported issue is valid. For critical issues affecting commonly copied snippets, we will prioritise same-day or next-day correction.

---

## Scope

This policy covers all code files, configuration files, and documentation in the main branch of the `web-security-snippets` repository at `github.com/lethabokhedama-png/web-security-snippets`.

Forks of this repository are outside scope. If you find a security issue in a fork, contact the fork's maintainer.

---

## Supported Versions

We maintain and patch the `main` branch only. Older commits are not supported. After a security fix is committed to `main`, the corrected version is the only supported version.

---

## Credit and Disclosure

After a fix is merged, we will credit the reporter in the fix commit message and in the relevant file's header comment (with the reporter's permission). We follow a coordinated disclosure model — we will not disclose the vulnerability publicly until a fix is available, at which point we will add a brief note to `CHANGELOG.md` describing what was corrected.

---

## A Note on Responsible Use

The snippets in this library are reference implementations for defensive security controls. They are not exploit code and are not intended to be used offensively. If you are using material from this library for purposes other than building secure applications, that use is outside the scope of this project.