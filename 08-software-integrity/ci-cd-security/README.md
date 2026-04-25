# CI/CD Pipeline Security

**OWASP:** A08 — Software and Data Integrity Failures
**Risk Level:** High
**Applies to:** All teams using automated CI/CD pipelines

---

## Why CI/CD Pipelines Are High-Value Targets

CI/CD pipelines have broad access to everything needed to ship software: source code, production secrets, cloud credentials, signing keys, package registries, and deployment targets. A compromised pipeline can inject malicious code into every build, exfiltrate secrets, push to production, and cover its tracks — all automatically, at speed, before anyone notices.

The Codecov attack (2021) demonstrated this: a single compromised CI script exfiltrated environment variables from thousands of CI pipelines within weeks, because pipelines across the industry trusted that script without verification.

---

## GitHub Actions Security

GitHub Actions is the most widely used CI platform. Its security model has several nuances that create common vulnerabilities:

**Pin action versions to commit hashes, not tags.** Tags are mutable — `actions/checkout@v4` can be changed to point to a different commit by the repository owner or an attacker who gains access. A commit hash (`actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683`) is immutable. Pin all actions to commit hashes in production workflows.

**Never pass untrusted input to `run` steps without sanitisation.** Pull request titles, branch names, commit messages, and issue bodies can contain shell injection payloads. The `${{ github.event.pull_request.title }}` expression in a `run:` block executes whatever the PR title contains.

**Limit GITHUB_TOKEN permissions.** By default, the GITHUB_TOKEN has broad permissions. Scope it to the minimum required using the `permissions` block:

```yaml
permissions:
  contents: read
  pull-requests: write
```

**Do not expose secrets to pull requests from forks.** Secrets are not passed to workflows triggered by pull requests from forked repositories by default. Do not change this. Workflows that need secrets for PR checks must use the `pull_request_target` event carefully — with explicit checkout of the PR code in an isolated step, never with secrets in scope.

**Separate untrusted and trusted stages.** Build stages that handle untrusted code (linting, testing user-submitted contributions) must be isolated from stages that have access to production secrets and deployment targets.

---

## Supply Chain Security for CI

**Verify checksums of downloaded tools.** If your pipeline downloads external tools or scripts, verify their SHA-256 checksum before executing them.

**Use fixed, versioned base images.** Docker base images tagged `latest` can change. Pin to a specific digest (`ubuntu@sha256:...`) to ensure your builds are reproducible and cannot be silently altered.

**Scan for secrets before they reach the pipeline.** Use pre-commit hooks (git-secrets, gitleaks) and CI-level secret scanning to catch accidentally committed credentials before they are ever executed.

---

## Available Snippets

| Platform | Subject | Level | File |
|----------|---------|-------|------|
| GitHub Actions | Pinned actions and minimal permissions | 🟡 Intermediate | github-actions-hardened-intermediate.yml |
| GitHub Actions | Secret scanning workflow | 🟡 Intermediate | github-actions-secret-scan-intermediate.yml |
| GitHub Actions | Dependency vulnerability gate | 🟢 Beginner | github-actions-vuln-gate-beginner.yml |
| GitHub Actions | OIDC-based cloud auth (no static secrets) | 🔴 Advanced | github-actions-oidc-advanced.yml |
| GitLab CI | Hardened pipeline template | 🔴 Advanced | gitlab-ci-hardened-advanced.yml |
| Pre-commit | gitleaks secret detection hook | 🟢 Beginner | pre-commit-gitleaks-beginner.yaml |