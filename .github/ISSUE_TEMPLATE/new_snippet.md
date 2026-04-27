---
name: New Snippet Request
about: Request a snippet for a language, framework, or difficulty level not yet covered
title: "[SNIPPET] <category> — <language>/<framework> (<level>)"
labels: new-snippet
assignees: lethabokhedama-png
---

## Snippet Details

Fill in all fields. Incomplete requests will be asked to revise before they are reviewed.

**Category:**
(e.g. `07-auth-failures/jwt`, `03-injection/sql-injection`, `02-cryptographic-failures/password-hashing`)

**Language:**
(e.g. Python, Node.js, Go, Java, PHP, Ruby, Rust, C#)

**Framework:**
(e.g. Flask, Express, Gin, Spring Boot — or "None / standard library only")

**Difficulty level:**
- [ ] Beginner — heavy comments, step-by-step explanations, clearly marked REPLACE values
- [ ] Intermediate — moderate comments, explains non-obvious choices
- [ ] Advanced — minimal comments, production-ready, clean reference implementation

**Dependency file format needed:**
- [ ] requirements.txt (Python)
- [ ] package.json (Node.js / TypeScript)
- [ ] go.mod (Go)
- [ ] Gemfile (Ruby)
- [ ] pom.xml (Java/Maven)
- [ ] Cargo.toml (Rust)
- [ ] composer.json (PHP)
- [ ] None — standard library only

---

## Why This Is Needed

Explain clearly why this language and framework combination is missing and why it matters.

- How widely is this language/framework used for this type of application?
- Is there something about this language or framework that makes the implementation non-obvious or different from existing snippets?
- Are there known footguns or common mistakes in this language/framework for this security pattern?

---

## Existing Coverage

Confirm you have checked that this snippet does not already exist.

- [ ] I have looked in the category folder and the snippet is not there
- [ ] I have checked the OWASP-MAP.md and confirmed the status is "Needed"

---

## Are You Willing to Write It?

- [ ] Yes — I intend to write this snippet and submit a pull request following CONTRIBUTING.md
- [ ] No — I am requesting it for someone else to implement
- [ ] Maybe — I can contribute part of it but would need help with specific sections

If yes, please open a draft pull request referencing this issue when you begin work so others know it is in progress.

---

## Reference Material

Links to official documentation, existing implementations in other languages in this repo, relevant RFCs, or OWASP guidance that should inform the implementation.

---

## Additional Context

Anything else that would help a contributor write this snippet correctly. Known edge cases, version-specific considerations, or integration requirements.
