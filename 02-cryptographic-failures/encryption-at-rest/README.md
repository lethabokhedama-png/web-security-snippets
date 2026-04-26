# Encryption at Rest

**OWASP:** A02 — Cryptographic Failures
**Risk Level:** Critical
**Applies to:** Applications storing sensitive data in databases, file systems, or object storage

---

## What Is Encryption at Rest?

Encryption at rest means encrypting data before it is written to persistent storage so that a raw read of the storage medium — a stolen hard drive, an exposed database backup, a misconfigured S3 bucket — does not reveal the underlying data.

It is distinct from encryption in transit (covered in tls-config/) which protects data moving between systems, and from password hashing (covered in password-hashing/) which is a specialised case of one-way transformation.

---

## What to Encrypt

Not everything needs to be encrypted at rest. Encrypted fields are harder to query, index, and sort. The trade-off is worth it for data whose exposure would cause significant harm: government ID numbers, health records, financial account details, full payment card numbers (though PANs should generally not be stored at all under PCI-DSS), private messages, and biometric data.

A useful heuristic: would exposure of this field appear in a breach notification to users or regulators? If yes, encrypt it.

---

## The Right Algorithm: AES-256-GCM

AES-256-GCM (Advanced Encryption Standard, 256-bit key, Galois/Counter Mode) is the current standard for symmetric encryption at rest. It provides:

- **Confidentiality** — the data cannot be read without the key
- **Integrity** — any tampering with the ciphertext is detectable (this is the G and M in GCM: Galois/Counter Mode with Message Authentication Code)
- **Performance** — AES is hardware-accelerated on modern processors

Do not use AES in ECB mode (Electronic Code Book). ECB mode encrypts each block independently, which means identical plaintext blocks produce identical ciphertext blocks. This allows patterns in the data to remain visible — the most famous demonstration is the ECB-encrypted Linux penguin image that still shows the penguin's outline.

---

## Initialisation Vectors

Every encryption operation must use a unique, randomly generated initialisation vector (IV). The IV does not need to be secret, but it must be unique for each encryption operation with the same key. Store the IV alongside the ciphertext — you need it to decrypt.

Reusing an IV with the same key in GCM mode catastrophically breaks the authentication guarantee and leaks the key stream.

---

## Key Rotation

Encryption keys must be rotatable. When a key is compromised, suspected of compromise, or past its rotation schedule, you need to re-encrypt existing data with a new key. Design your storage schema to support key versioning from the start — add a `key_version` or `encryption_key_id` field alongside the ciphertext.

---

## Available Snippets

| Language | Algorithm | Level | File |
|----------|-----------|-------|------|
| Python | AES-256-GCM | 🟡 Intermediate | python-aes-gcm-intermediate.py |
| Node.js | AES-256-GCM | 🟡 Intermediate | node-aes-gcm-intermediate.js |
| Go | AES-256-GCM | 🔴 Advanced | go-aes-gcm-advanced.go |
| Java | AES-256-GCM | 🔴 Advanced | java-aes-gcm-advanced.java |
| Ruby | AES-256-GCM | 🟡 Intermediate | ruby-aes-gcm-intermediate.rb |
