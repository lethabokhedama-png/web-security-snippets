# A02 — Cryptographic Failures

**OWASP Rank:** 2 of 10
**Previously known as:** Sensitive Data Exposure
**Risk Level:** Critical

---

## What Are Cryptographic Failures?

Cryptographic failures occur when data that should be protected is exposed because it was never encrypted, was encrypted using a broken or outdated algorithm, or was encrypted correctly but the keys were managed poorly. The data at risk includes passwords, credit card numbers, health records, personal identification numbers, session tokens, and any other information that would cause harm if disclosed.

The category was renamed from Sensitive Data Exposure to Cryptographic Failures in the 2021 OWASP Top 10 to emphasise that the root cause is almost always a failure of cryptography — not simply the exposure itself.

---

## Real-World Breaches

**RockYou2021:** A compilation of 8.4 billion password entries leaked in 2021, built largely from previous breaches where passwords were stored in plain text or with MD5, a cryptographic hash function that was broken for password storage purposes in the early 2000s. MD5 can be cracked at billions of hashes per second on modern hardware.

**LinkedIn (2012):** 117 million passwords hashed with unsalted SHA-1. SHA-1 without a salt means identical passwords produce identical hashes. Rainbow table attacks allowed attackers to crack the majority of the dataset within days of the breach becoming public.

**Adobe (2013):** 153 million user records exposed. Passwords were encrypted (not hashed) with 3DES in ECB mode — a symmetric encryption algorithm rather than a hashing algorithm. This meant passwords could be decrypted if the key was found. The ECB mode also allowed patterns in the data to be visible, allowing researchers to identify users who shared the same password.

**Heartbleed (2014):** A vulnerability in OpenSSL's implementation of the TLS heartbeat extension allowed attackers to read 64KB of server memory per request, including private keys, session tokens, and in-memory passwords. This was a failure of the implementation of cryptographic protocols, not the algorithms themselves.

---

## What This Category Covers

**Password Hashing** — Passwords must be hashed, not encrypted. Hashing is a one-way operation: given a hash, you cannot recover the original password. The snippets here use bcrypt and Argon2, which are designed specifically for password storage and include work factors that make brute-force attacks slow.

**Encryption at Rest** — Data stored in databases, file systems, or object storage must be encrypted when its exposure would cause harm. The snippets here use AES-256-GCM, the current standard for symmetric encryption, with authenticated encryption that protects against tampering.

**TLS Configuration** — Encrypting data in transit requires not just enabling HTTPS but configuring it correctly. Weak cipher suites, old protocol versions (TLS 1.0, 1.1), and missing HSTS headers leave connections vulnerable. The snippets here cover secure Nginx and Apache configurations.

**Key Management** — Encryption is only as strong as the secrecy of the keys. Keys that are hardcoded in source code, committed to version control, or stored alongside the data they protect undermine every other cryptographic control. The snippets here cover environment-based key management and integrations with secret management services.

---

## The Hierarchy of Cryptographic Failures

From most to least severe:

1. **No encryption at all** — Data stored or transmitted in plain text
2. **Encryption with a broken algorithm** — MD5, SHA-1, DES, RC4, 3DES, RSA below 2048 bits
3. **Correct algorithm, incorrect mode** — AES in ECB mode, unauthenticated encryption
4. **Correct algorithm and mode, poor key management** — Keys in source code, keys in environment variables without rotation
5. **Correct implementation, no forward secrecy** — TLS without ECDHE cipher suites, meaning historical traffic can be decrypted if the server's private key is later compromised

All five levels are addressed in this section of the library.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Hash user passwords for storage | password-hashing/ |
| Encrypt sensitive fields in a database | encryption-at-rest/ |
| Configure HTTPS correctly on my server | tls-config/ |
| Store and retrieve cryptographic keys and secrets | key-management/ |
