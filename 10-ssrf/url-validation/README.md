# URL Validation for SSRF Prevention

**OWASP:** A10 — Server-Side Request Forgery (SSRF)
**Risk Level:** High
**Applies to:** Any feature that fetches a user-supplied URL server-side

---

## The Challenge of Validating URLs for SSRF

URL validation for SSRF prevention is harder than it looks. The obvious approach — check whether the URL contains `169.254.169.254` — fails immediately against hex encoding, decimal encoding, IPv6, and DNS names that resolve to private addresses.

A robust URL validator must:

1. Parse the URL into its components (scheme, host, port, path)
2. Reject disallowed schemes (`file://`, `gopher://`, `dict://`, `ftp://` — only `https://` should be accepted for most use cases)
3. Resolve the hostname to an IP address
4. Check the resolved IP address against private and reserved ranges — not the hostname string
5. Make the HTTP request
6. Check that the final destination (after any redirects) also resolves to an allowed IP

Step 4 is critical: checking the hostname string `169.254.169.254` is not enough. Checking the resolved IP address is what actually provides protection.

---

## DNS Rebinding: The Advanced Attack

DNS rebinding is an attack that defeats URL validation performed before the HTTP request is made. The attack works as follows:

1. The attacker controls a DNS server for `attacker.com`
2. The attacker configures `ssrf.attacker.com` with a very short TTL (0 or 1 second)
3. On the first DNS resolution (during your validation), `ssrf.attacker.com` resolves to a public IP that passes your check
4. On the second DNS resolution (when your HTTP client makes the actual request), `ssrf.attacker.com` now resolves to `169.254.169.254`
5. Your HTTP client connects to the metadata service

The defence is to resolve the hostname once, validate the resolved IP, and then connect directly to the IP — not to re-resolve the hostname for the connection.

---

## Private and Reserved IP Ranges to Block

These IP ranges must never be the target of server-side requests based on user input:

```
10.0.0.0/8          — Private network (RFC 1918)
172.16.0.0/12       — Private network (RFC 1918)
192.168.0.0/16      — Private network (RFC 1918)
127.0.0.0/8         — Loopback (localhost)
169.254.0.0/16      — Link-local (AWS/GCP metadata)
0.0.0.0/8           — This network
100.64.0.0/10       — Shared address space (RFC 6598)
198.18.0.0/15       — Network benchmarking (RFC 2544)
::1/128             — IPv6 loopback
fc00::/7            — IPv6 unique local
fe80::/10           — IPv6 link-local
fd00:ec2::254       — AWS IPv6 metadata endpoint
```

---

## Available Snippets

| Language | Level | File |
|----------|-------|------|
| Python | 🟢 Beginner | python-beginner.py |
| Python | 🔴 Advanced | python-advanced.py |
| Node.js | 🟢 Beginner | node-beginner.js |
| Node.js | 🔴 Advanced | node-advanced.js |
| Go | 🔴 Advanced | go-advanced.go |
| Java | 🔴 Advanced | java-advanced.java |
| PHP | 🟡 Intermediate | php-intermediate.php |
| Ruby | 🟡 Intermediate | ruby-intermediate.rb |
