# Dependency Update Policies

**OWASP:** A06 — Vulnerable and Outdated Components
**Risk Level:** High
**Applies to:** All projects with external dependencies

---

## Why Keeping Dependencies Updated Is a Security Practice

The Equifax breach happened because a patch was available and not applied. This is not an isolated case — the gap between a CVE being published and an attacker having a working exploit is often measured in hours. The gap between a CVE being published and organisations applying the fix is often measured in months.

Keeping dependencies updated is not about chasing the latest features. It is about closing known vulnerabilities before attackers exploit them. The question is not whether to update, but how to do it safely and consistently.

---

## Automated Update Tools

**Dependabot (GitHub):** A GitHub-native tool that monitors your dependency files and opens pull requests when updates are available. Configurable by ecosystem, update frequency, and which packages to watch. Free for all GitHub repositories. Security updates (for packages with known CVEs) are prioritised and can be configured to auto-merge.

**Renovate:** An open-source alternative to Dependabot with more configuration options. Supports grouping related updates into a single PR, custom schedules, semantic versioning strategies, and automatic merging with tests. Can be self-hosted or used as a GitHub/GitLab app.

---

## Balancing Safety and Velocity

Automated dependency updates carry risk. A new version may introduce breaking changes, regressions, or its own vulnerabilities. The mitigations are:

**Good test coverage:** Automated updates only make sense if your test suite catches regressions. A PR that updates a library and breaks your application should fail your test suite, not reach production.

**Staged rollout:** Review automated update PRs before merging. Do not configure auto-merge for major version updates without manual review.

**Separate security updates from feature updates:** Security updates should be applied promptly. Feature updates can be batched and reviewed on a schedule. Configure your tools to distinguish between the two.

**Semantic versioning discipline:** Patch updates (1.2.3 → 1.2.4) are low risk. Minor updates (1.2.3 → 1.3.0) are medium risk. Major updates (1.2.3 → 2.0.0) are high risk and require manual review. Configure automation accordingly.

---

## Available Snippets and Guides

| Tool | Platform | Level | File |
|------|----------|-------|------|
| Dependabot configuration | GitHub | 🟢 Beginner | dependabot-beginner.yml |
| Dependabot — security updates only | GitHub | 🟢 Beginner | dependabot-security-only-beginner.yml |
| Renovate — basic configuration | Any | 🟡 Intermediate | renovate-intermediate.json |
| Renovate — advanced grouping config | Any | 🔴 Advanced | renovate-advanced.json |
| Update policy documentation template | Any | 🟢 Beginner | update-policy-template.md |
