# Key Management

**OWASP:** A02 — Cryptographic Failures
**Risk Level:** Critical
**Applies to:** Any application using cryptographic keys, API keys, database credentials, or secrets

---

## The Problem with Keys

Cryptographic strength means nothing if the key is exposed. A database encrypted with AES-256 is trivially readable if the encryption key is stored in a comment in the same file as the database connection string. Key management is the practice of generating, storing, rotating, distributing, and revoking cryptographic material securely.

The most common key management failures are also the simplest: keys hardcoded in source code, keys committed to version control, keys stored in plain text in configuration files, and keys that never expire or rotate.

---

## Levels of Key Management

**Level 1 — Environment variables:** Keys are not in source code but are injected at runtime via environment variables. Better than hardcoding. Still vulnerable to process listing, environment dumps, and accidental logging. Appropriate for development and small-scale production.

**Level 2 — Secrets management service:** Keys are stored in a dedicated secrets manager (HashiCorp Vault, AWS Secrets Manager, GCP Secret Manager, Azure Key Vault). The application authenticates to the secrets manager using its own identity (an IAM role, a Kubernetes service account) and retrieves secrets at startup or on demand. Secrets are never stored on disk. Rotation can be automated.

**Level 3 — Hardware Security Module (HSM):** Cryptographic operations happen inside tamper-evident hardware. The key never leaves the HSM. Used for high-value keys like root certificate authorities, payment processing, and government systems.

---

## The Twelve-Factor App Principle

The Twelve-Factor methodology (a widely adopted framework for building cloud-native applications) specifies that credentials and configuration must be stored in the environment, not in the code. A codebase that is open-sourced at any point must not expose credentials. A developer laptop that is lost or stolen must not expose production credentials.

The consequence of violating this is real: GitHub's secret scanning service detects thousands of accidentally committed credentials every day. Many of those credentials are used to attack systems within minutes of the commit.

---

## Available Snippets

| Pattern | Language | Level | File |
|---------|----------|-------|------|
| Environment variable loading | Python | 🟢 Beginner | python-env-beginner.py |
| Environment variable loading | Node.js | 🟢 Beginner | node-env-beginner.js |
| HashiCorp Vault — KV secrets | Python | 🔴 Advanced | python-vault-advanced.py |
| HashiCorp Vault — KV secrets | Go | 🔴 Advanced | go-vault-advanced.go |
| AWS Secrets Manager | Node.js | 🔴 Advanced | node-aws-secrets-advanced.js |
| AWS Secrets Manager | Python | 🔴 Advanced | python-aws-secrets-advanced.py |
| GCP Secret Manager | Python | 🔴 Advanced | python-gcp-secrets-advanced.py |
| Key rotation pattern | Python | 🟡 Intermediate | python-rotation-intermediate.py |
