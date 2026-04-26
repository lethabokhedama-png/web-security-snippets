# A05 — Security Misconfiguration

**OWASP Rank:** 5 of 10
**Risk Level:** High
**Prevalence:** Extremely common — found in the majority of applications

---

## What Is Security Misconfiguration?

Security misconfiguration occurs when a system is configured in a way that creates a security weakness. Unlike injection or cryptographic failures, misconfiguration is rarely the result of a deliberate design choice gone wrong. It is almost always an omission — a security control that was not configured, a default that was not changed, or a setting that was correct in development but wrong in production.

It is the most preventable category in the OWASP Top 10. Every item in this section is caused not by a complex vulnerability but by something that was not done.

---

## Real-World Breaches

**Capital One (2019):** A misconfigured Web Application Firewall allowed a server-side request forgery (SSRF) attack that exposed the AWS EC2 metadata service. The attacker obtained temporary credentials with broad IAM permissions and exfiltrated 100 million customer records. The root cause was a firewall rule that permitted outbound requests to internal AWS metadata endpoints.

**Microsoft Power Apps (2021):** Default configuration in Microsoft's Power Apps portal left data exposed through OData APIs without requiring authentication. 38 million records containing sensitive personal data across multiple organisations were exposed before Microsoft changed the defaults. Every affected organisation had simply not changed a default setting.

**Elasticsearch public exposure:** Throughout 2017–2021, thousands of Elasticsearch instances were deployed with no authentication and bound to public network interfaces — the default configuration for older versions. Researchers found billions of records exposed including medical data, financial records, and credentials. Every affected installation was using default settings.

---

## Common Misconfiguration Patterns

**Missing or permissive security headers:** HTTP security headers like Content-Security-Policy, Strict-Transport-Security, X-Frame-Options, and X-Content-Type-Options communicate security policies to browsers. Missing headers allow attacks that these policies prevent — XSS, clickjacking, protocol downgrade, MIME sniffing.

**Overly permissive CORS:** Cross-Origin Resource Sharing headers that allow requests from any origin (`Access-Control-Allow-Origin: *`) expose APIs to cross-site request forgery and credential theft from any domain on the internet.

**Verbose error messages:** Stack traces, database query text, and file paths in error responses reveal implementation details useful to attackers. Production systems must suppress this information entirely.

**Default credentials:** Admin panels, databases, monitoring tools, and cloud services often ship with default username/password combinations. These are documented publicly. Change all defaults before any system is reachable from a network.

**Unnecessary features enabled:** Debug endpoints, directory listing, administrative interfaces, sample applications, and unused services expand the attack surface. Disable everything that is not required.

**Insecure cloud storage defaults:** Object storage services (S3, GCS, Azure Blob) default to private in recent versions but older configurations and accidental policy changes regularly expose buckets publicly. Every storage resource must have explicit access policies reviewed.

---

## What This Section Covers

**Security Headers** — HTTP response headers that instruct browsers to enforce security policies. Includes CSP, CORS, HSTS, X-Frame-Options, X-Content-Type-Options, and Referrer-Policy.

**Error Handling** — Patterns for returning useful error responses without revealing implementation details. Covers structured error responses, environment-specific error detail, and centralised error handling middleware.

**Server Hardening** — Configuration guides for reducing the attack surface of web servers, including disabling unnecessary modules, securing directory permissions, and removing default content.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Add security headers to my application | security-headers/ |
| Configure CORS for my API | security-headers/cors/ |
| Enable HSTS on my site | security-headers/hsts/ |
| Prevent my site from being framed | security-headers/x-frame-options/ |
| Stop stack traces appearing in production | error-handling/ |
| Harden my web server configuration | server-hardening/ |
