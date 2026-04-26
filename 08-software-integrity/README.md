# A08 — Software and Data Integrity Failures

**OWASP Rank:** 8 of 10
**Risk Level:** High
**New in 2021 OWASP Top 10:** Yes

---

## What Is This Category?

Software and data integrity failures occur when code or infrastructure updates, critical data, and CI/CD pipelines are used without verifying their integrity. An attacker who can inject malicious code into a dependency, a CI pipeline, or an update mechanism can compromise every application that consumes from that source — often at a scale impossible with direct attacks.

This category encompasses supply chain attacks, where the attack vector is not the target application itself but a trusted component of its build or runtime environment.

---

## Real-World Breaches

**SolarWinds (2020):** One of the most significant supply chain attacks in history. Attackers compromised SolarWinds' build system and inserted malicious code into Orion, a widely used IT monitoring product. The malware was digitally signed by SolarWinds' legitimate certificate and distributed to approximately 18,000 organisations through normal software updates. Victims included the US Treasury, the US Department of Homeland Security, NATO, and thousands of private companies. Detection took months.

**Codecov (2021):** Attackers gained access to Codecov's CI/CD infrastructure and modified the Bash Uploader script used by developers to submit code coverage reports. The modified script exfiltrated environment variables — including CI secrets and credentials — from any CI pipeline that used it. Thousands of organisations were affected, including Twilio, Hashicorp, and Rapid7.

**event-stream (2018):** A malicious npm package hidden as a transitive dependency of a popular Node.js package. The package contained obfuscated code targeting a specific cryptocurrency wallet application. It had 1.5 million weekly downloads and was present in the dependency tree of thousands of applications.

---

## What This Section Covers

**Subresource Integrity (SRI)** — Browser mechanism for verifying that resources loaded from CDNs have not been tampered with. Covers implementation in HTML and template engines.

**Signed Commits** — GPG signing of Git commits to verify that code was authored by a known identity and has not been modified after signing.

**CI/CD Security** — Hardening GitHub Actions and other CI pipelines against secret leakage, action injection, and supply chain compromise. Includes pinning action versions to specific commit hashes, using minimal permission tokens, and separating secret access from untrusted code.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Verify CDN resources have not been tampered with | subresource-integrity/ |
| Cryptographically sign my Git commits | signed-commits/ |
| Harden my GitHub Actions CI pipeline | ci-cd-security/ |
