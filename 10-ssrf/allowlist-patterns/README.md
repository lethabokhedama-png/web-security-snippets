# Allowlist Patterns for SSRF Prevention

**OWASP:** A10 — Server-Side Request Forgery (SSRF)
**Risk Level:** High
**Applies to:** Features that fetch user-supplied URLs or accept user-configured integration endpoints

---

## Allowlist vs Blocklist

The consistent recommendation from security professionals for SSRF prevention is to use an allowlist (permit only explicitly specified destinations) rather than a blocklist (deny known bad destinations). This is because blocklists are inherently incomplete.

An attacker who knows your blocklist will find a representation of a blocked address that your blocklist does not recognise. An allowlist does not have this problem — anything not on the list is denied by default, regardless of how it is encoded.

---

## Types of Allowlists

**Domain-based allowlist:** A list of permitted domain names. Requests are only permitted to these specific domains. Wildcard subdomains (allowing all subdomains of `trusted.com`) must be implemented carefully — ensure the matching does not permit `evil.com?redirect=trusted.com` or similar path-based tricks.

**IP-based allowlist:** A list of specific IP addresses or CIDR ranges that are permitted targets. More precise than domain-based allowlists. Requires updating when destination IPs change, which can be a maintenance burden for third-party services.

**Combined domain + IP verification:** Resolve the domain to an IP, verify the IP is in the allowlist, then connect directly to the IP. This is the most robust approach — it provides domain-name usability while being resistant to DNS rebinding.

---

## Designing a Practical Allowlist System

For applications where users configure their own webhook URLs (a common SSRF surface), consider:

1. Validate the URL at configuration time against your allowlist
2. Store the validated URL and the resolved IP at configuration time
3. At runtime, connect to the stored IP directly (bypassing DNS resolution entirely)
4. Periodically re-validate stored URLs in case destinations change

This approach minimises the window for DNS rebinding and makes configuration-time validation practical.

---

## Available Snippets

| Language | Pattern | Level | File |
|----------|---------|-------|------|
| Python | Domain allowlist with DNS resolution | 🟡 Intermediate | python-domain-allowlist-intermediate.py |
| Python | IP range allowlist | 🟡 Intermediate | python-ip-allowlist-intermediate.py |
| Python | Combined domain + IP validation | 🔴 Advanced | python-combined-advanced.py |
| Node.js | Domain allowlist with DNS resolution | 🟡 Intermediate | node-domain-allowlist-intermediate.js |
| Node.js | IP range allowlist | 🟡 Intermediate | node-ip-allowlist-intermediate.js |
| Go | Combined validation with DNS pinning | 🔴 Advanced | go-combined-advanced.go |
| Java | Allowlist validator | 🔴 Advanced | java-advanced.java |
