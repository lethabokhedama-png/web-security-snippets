# Enterprise Secrets Management

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Secret exposure through environment variables, config files, logs, and insider access
**Audience:** Senior engineers, DevOps/platform teams, security architects

---

## Why Dedicated Secrets Management Infrastructure

Environment variables are an improvement over hardcoded secrets but have significant limitations at scale:

- They appear in process listings, crash dumps, container inspection output, and sometimes logs
- Rotating them requires redeploying the application
- There is no audit trail of who accessed them or when
- They cannot be automatically rotated when a compromise is suspected
- Each deployment environment must independently manage its own copy

A dedicated secrets manager addresses all of these. Applications retrieve secrets at runtime by authenticating to the secrets manager using their own identity (an IAM role, a Kubernetes service account, a SPIFFE identity). The secrets manager returns the secret and logs the access. Secrets are never stored on disk. Rotation can be automated.

---

## HashiCorp Vault

Vault is the most widely deployed open-source secrets manager. It provides:

**Static secrets:** Versioned key-value pairs. Applications read the current version of a secret. Rotation updates the secret version.

**Dynamic secrets:** Generated on demand with limited lifetime. Vault generates a unique database credential for each application instance with a 1-hour TTL. When the TTL expires, the credential is automatically revoked. A compromised credential is useful only for its remaining TTL — typically minutes to hours rather than indefinitely.

**Transit secrets engine:** Encryption as a service. Applications send plaintext to Vault and receive ciphertext. The encryption key never leaves Vault. This removes the key management burden from application teams.

**PKI secrets engine:** Vault as an internal certificate authority. Issues short-lived TLS certificates on demand. Enables mTLS between services without manual certificate management.

---

## Cloud-Native Secrets Managers

**AWS Secrets Manager:** Native AWS service for storing and rotating secrets. Integrates with RDS for automatic database credential rotation. Applications use IAM roles to authenticate — no separate credentials required.

**GCP Secret Manager:** Google Cloud equivalent. Integrates with Cloud IAM. Supports secret versions and automatic rotation triggers via Cloud Functions.

**Azure Key Vault:** Microsoft Azure equivalent. Stores secrets, keys, and certificates. Integrates with Azure Managed Identities for credential-free application authentication.

---

## Available Snippets

| Tool | Language | Pattern | File |
|------|----------|---------|------|
| HashiCorp Vault | Python | KV v2 secrets read | python-vault-kv.py |
| HashiCorp Vault | Go | Dynamic database credentials | go-vault-dynamic-db.go |
| HashiCorp Vault | Node.js | AppRole authentication | node-vault-approle.js |
| AWS Secrets Manager | Python | Secret retrieval with caching | python-aws-secrets.py |
| AWS Secrets Manager | Node.js | Secret retrieval | node-aws-secrets.js |
| GCP Secret Manager | Python | Secret retrieval | python-gcp-secrets.py |
| Azure Key Vault | Python | Secret retrieval | python-azure-keyvault.py |
| Any | Any | Secret rotation pattern | rotation-pattern.md |
