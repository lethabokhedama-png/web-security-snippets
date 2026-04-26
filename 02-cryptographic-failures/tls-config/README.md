# TLS Configuration

**OWASP:** A02 — Cryptographic Failures
**Risk Level:** High
**Applies to:** Any web server or API handling HTTPS traffic

---

## Why TLS Configuration Matters Beyond Just Enabling HTTPS

Enabling HTTPS is necessary but not sufficient. A server configured to accept TLS 1.0 connections, weak cipher suites, or certificates with short key lengths is technically running HTTPS but is vulnerable to well-documented attacks. The configuration of TLS is as important as whether it is enabled at all.

---

## Protocol Versions

**TLS 1.3** — Current standard. Use this where supported. It removes support for weak cipher suites entirely and has a faster handshake.

**TLS 1.2** — Acceptable. Still widely deployed. Requires careful cipher suite selection.

**TLS 1.1** — Deprecated. Must not be enabled. Vulnerable to BEAST and other attacks.

**TLS 1.0** — Deprecated. Must not be enabled. Violates PCI-DSS compliance since 2018.

**SSL 2.0 and 3.0** — Never enable. Both are fundamentally broken.

---

## Cipher Suite Selection

A cipher suite defines the algorithms used for key exchange, authentication, encryption, and integrity checking. Many cipher suites have known weaknesses and must be disabled:

- **RC4** — Stream cipher with known biases. Banned by RFC 7465.
- **3DES** — Block cipher vulnerable to SWEET32 (birthday attack). Deprecated.
- **NULL ciphers** — No encryption at all. Never enable.
- **Anonymous DH/ECDH** — No server authentication. Vulnerable to man-in-the-middle.
- **EXPORT ciphers** — Intentionally weakened for US export compliance in the 1990s. Vulnerable to FREAK and Logjam attacks.

Enable only ciphers with:
- ECDHE or DHE key exchange (provides forward secrecy)
- AES-128-GCM or AES-256-GCM or CHACHA20-POLY1305 encryption
- SHA-256 or SHA-384 message authentication

---

## OCSP Stapling

Online Certificate Status Protocol (OCSP) stapling allows the server to include a pre-fetched, CA-signed assertion that the certificate has not been revoked. Enable it to avoid the privacy and performance implications of clients contacting the CA's OCSP server on every handshake.

---

## Available Snippets

| Server | Level | File |
|--------|-------|------|
| Nginx | 🟡 Intermediate | nginx-intermediate.conf |
| Apache | 🟡 Intermediate | apache-intermediate.conf |
| Node.js (built-in https) | 🟡 Intermediate | node-https-intermediate.js |
| Go (crypto/tls) | 🔴 Advanced | go-tls-advanced.go |
| Caddy | 🟢 Beginner | caddy-beginner.caddyfile |
