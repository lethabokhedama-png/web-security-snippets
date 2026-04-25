# A10 — Server-Side Request Forgery (SSRF)

**OWASP Rank:** 10 of 10
**Risk Level:** High
**New in 2021 OWASP Top 10:** Yes (added from community survey data)

---

## What Is SSRF?

Server-Side Request Forgery (SSRF) is a vulnerability that allows an attacker to induce the server to make HTTP requests to an arbitrary destination — typically an internal address that is not accessible from the internet. The request originates from the server itself, bypassing network controls that would block direct access from an attacker's machine.

SSRF occurs in features that accept user-supplied URLs or resource identifiers and fetch them server-side: webhook configuration, URL preview generation, image loading from a URL, PDF generation from a URL, server-side RSS feed fetching, and any feature that retrieves remote content.

---

## Real-World Breaches

**Capital One (2019):** The most cited SSRF breach in recent history. A misconfigured Web Application Firewall allowed SSRF requests to reach the AWS EC2 instance metadata service at `169.254.169.254`. This service returns IAM credentials for the instance role. The attacker used those credentials to access S3 buckets containing 100 million customer records. The SSRF was the pivot point — without it, the attacker had no privileged access.

**GitLab (multiple CVEs):** GitLab's repository import feature, webhook system, and integrations have been repeatedly targeted by SSRF vulnerabilities that allowed attackers to reach internal GitLab services, Redis instances, and cloud metadata endpoints. SSRF is a persistent challenge for any platform that fetches user-supplied URLs.

---

## Why Cloud Environments Are Especially Vulnerable

Cloud providers expose a metadata service on a link-local IP address accessible from any EC2 instance, GCE instance, or equivalent virtual machine. These services return:

- Instance role credentials (AWS IAM, GCP service account)
- Instance metadata including internal hostnames and network configuration
- User-supplied instance metadata (sometimes including secrets passed as user data)

On AWS, the endpoint is `http://169.254.169.254/latest/meta-data/`. On GCP, it is `http://metadata.google.internal/computeMetadata/v1/`. An SSRF vulnerability on an EC2 instance gives an attacker access to these endpoints and potentially to production credentials.

---

## Defence: Allowlist, Not Blocklist

The primary defence against SSRF is validating user-supplied URLs against an allowlist of permitted destinations rather than a blocklist of dangerous ones. Blocklists always have gaps:

- `169.254.169.254` → blocked
- `169.254.169.254.attacker.com` → resolves to `169.254.169.254` (DNS rebinding)
- `0x00a9fea9` → hex representation of `169.254.169.254`
- `2852039337` → decimal representation of `169.254.169.254`
- `169.254.169.254` → blocked, but `fd00:ec2::254` (IPv6 equivalent) is not

Allowlists avoid this problem by rejecting anything not explicitly permitted.

---

## What This Section Covers

**URL Validation** — Validating user-supplied URLs against allowlists, blocking private IP ranges, and safe URL parsing patterns.

**Allowlist Patterns** — Domain-based and IP-based allowlisting with DNS rebinding protection.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Validate a user-supplied URL before fetching it | url-validation/ |
| Build an allowlist of permitted fetch destinations | allowlist-patterns/ |