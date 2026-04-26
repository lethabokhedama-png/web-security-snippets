# Certificate Pinning

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Man-in-the-middle attacks by entities with trusted CA certificates
**Audience:** Senior engineers building mobile apps or high-security API clients

---

## What Is Certificate Pinning?

TLS normally trusts any certificate signed by any of the hundreds of certificate authorities pre-loaded in the operating system's trust store. An attacker who can obtain a valid certificate from any of those CAs — through compromise, coercion, or a mis-issued certificate — can conduct a man-in-the-middle attack that passes standard TLS verification.

Certificate pinning binds a client to a specific certificate or public key. The client not only verifies that the server's certificate is signed by a trusted CA but also verifies that the certificate or public key matches a pre-loaded expectation. A certificate from a different CA — even a fully valid, trusted one — will fail this check.

---

## Pinning Strategies

**Pin the leaf certificate:** Pin the specific certificate your server is currently using. Maximum security — any change to the certificate, even a renewal, breaks the pin and requires a client update. Operationally difficult.

**Pin the public key:** Pin the server's public key rather than the certificate. Allows certificate renewal (which generates a new certificate containing the same public key) without breaking the pin. More operationally viable.

**Pin the intermediate CA:** Pin the intermediate certificate authority that issued your certificate. All certificates issued by that CA pass. Useful for organisations that control their own PKI. Less common for publicly trusted certificates.

**Pin multiple certificates (backup pins):** Always pin at least two certificates — your primary and a backup. If you must rotate to the backup pin, clients still work while you push an update with new pins. HPKP (now deprecated) required at least one backup pin for this reason.

---

## The Update Problem

Certificate pinning creates an operational risk: if the server's certificate changes and clients are not updated, those clients cannot connect to the server. This can cause a service outage affecting all users who have not updated the client.

Mitigations:
- Always maintain a backup pin
- Use key pinning rather than certificate pinning to allow renewal
- Test certificate rotation procedures before they are needed
- Maintain a short HPKP-equivalent max-age so pins can be quickly invalidated
- Have a clear procedure for emergency pin rotation

---

## Where Certificate Pinning Is Appropriate

Certificate pinning makes operational sense for:
- Mobile applications communicating with a known, controlled API
- IoT devices communicating with a specific cloud endpoint
- High-security enterprise applications with a controlled client distribution mechanism

It is generally not appropriate for general-purpose browsers or any client that must connect to arbitrary servers.

---

## Available Snippets

| Platform | Language | Level | File |
|----------|----------|-------|------|
| Mobile API client | Python (requests) | Advanced | python-requests-pinning.py |
| Mobile API client | Node.js (https) | Advanced | node-https-pinning.js |
| Mobile API client | Go | Advanced | go-pinning.go |
| Android | Kotlin | Advanced | android-kotlin-pinning.kt |
| iOS | Swift | Advanced | ios-swift-pinning.swift |
| Server config | Nginx | Intermediate | nginx-pinning-guide.md |
