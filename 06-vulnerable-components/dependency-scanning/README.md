# Dependency Scanning

**OWASP:** A06 — Vulnerable and Outdated Components
**Risk Level:** High
**Applies to:** All projects with external dependencies

---

## Why Automated Scanning Is Non-Negotiable

CVE databases are updated continuously. A library that was safe yesterday may have a disclosed critical vulnerability today. No development team can manually track the security status of hundreds of dependencies across daily database updates. Automated scanning tools that integrate into your development workflow are the only practical solution.

The goal is to know about vulnerable dependencies as early as possible — ideally before they are merged into the codebase, and certainly before they reach production.

---

## Scanning at Each Stage

**Local development:** Developers run scans before committing. Catches issues at the cheapest possible point.

**Pull request / CI pipeline:** Automated scan runs on every PR. Fails the build if high or critical vulnerabilities are detected. Prevents vulnerabilities from being merged.

**Scheduled production scan:** A daily or weekly scan of the production dependency manifest. Catches newly disclosed CVEs for packages already deployed.

**Container image scanning:** If your application runs in Docker, scan the base image as well as your application dependencies. Base images contain OS-level packages with their own vulnerability surface.

---

## Per-Language Tooling

**Node.js / npm:**
```bash
# Built-in — runs against npm advisory database
npm audit

# For CI — exits with non-zero code if vulnerabilities found
npm audit --audit-level=high
```

**Python:**
```bash
# pip-audit — checks against PyPI advisory database and OSV
pip install pip-audit
pip-audit

# Specify requirements file
pip-audit -r requirements.txt
```

**Go:**
```bash
# govulncheck — official Go vulnerability checker
go install golang.org/x/vuln/cmd/govulncheck@latest
govulncheck ./...
```

**Rust:**
```bash
# cargo-audit — checks against RustSec advisory database
cargo install cargo-audit
cargo audit
```

**Java (Maven):**
```bash
# OWASP Dependency-Check plugin
mvn org.owasp:dependency-check-maven:check
```

**Ruby:**
```bash
# bundler-audit
gem install bundler-audit
bundle audit check --update
```

---

## Integrating With CI

Every CI pipeline should run a dependency scan and fail on high or critical findings. The exact threshold depends on your team's risk tolerance and the maturity of your vulnerability management process. Starting with `--audit-level=critical` and progressively tightening to `high` as your process matures is a reasonable approach.

Do not set the threshold so low that every build fails on informational findings — teams will disable the check rather than fix it.

---

## False Positives and Triaging

Not every detected vulnerability is exploitable in your specific application. Before marking a finding as a false positive, confirm:

1. Your application actually uses the affected code path (not just includes the library)
2. Exploitation requires conditions that do not exist in your environment
3. A mitigating control is already in place

Document your triage decisions. An auditor or security reviewer will ask why a known vulnerability was accepted.

---

## Available Snippets and Guides

| Tool | Language/Platform | Level | File |
|------|-------------------|-------|------|
| npm audit | Node.js | 🟢 Beginner | node-npm-audit-beginner.md |
| pip-audit | Python | 🟢 Beginner | python-pip-audit-beginner.md |
| govulncheck | Go | 🟡 Intermediate | go-govulncheck-intermediate.md |
| cargo audit | Rust | 🟡 Intermediate | rust-cargo-audit-intermediate.md |
| OWASP Dependency-Check | Java | 🔴 Advanced | java-dependency-check-advanced.md |
| bundler-audit | Ruby | 🟢 Beginner | ruby-bundler-audit-beginner.md |
| Snyk CI integration | Multi-language | 🟡 Intermediate | snyk-ci-intermediate.yml |
| GitHub Actions — npm audit | Node.js | 🟢 Beginner | github-actions-npm-beginner.yml |
| GitHub Actions — pip-audit | Python | 🟢 Beginner | github-actions-pip-beginner.yml |
| GitHub Actions — govulncheck | Go | 🟡 Intermediate | github-actions-go-intermediate.yml |
