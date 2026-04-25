#!/bin/bash

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# web-security-snippets — Full Scaffold Script
# Run this from inside your cloned repo folder
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

echo "🔐 Scaffolding web-security-snippets..."

# ── ROOT FILES ──────────────────────────────────────

touch CONTRIBUTING.md
touch OWASP-MAP.md
touch LICENSE

# ── 01 BROKEN ACCESS CONTROL ────────────────────────

mkdir -p 01-broken-access-control/rbac
mkdir -p 01-broken-access-control/abac
mkdir -p 01-broken-access-control/api-key-validation
touch 01-broken-access-control/README.md
touch 01-broken-access-control/rbac/README.md
touch 01-broken-access-control/abac/README.md
touch 01-broken-access-control/api-key-validation/README.md

# ── 02 CRYPTOGRAPHIC FAILURES ───────────────────────

mkdir -p 02-cryptographic-failures/password-hashing
mkdir -p 02-cryptographic-failures/encryption-at-rest
mkdir -p 02-cryptographic-failures/tls-config
mkdir -p 02-cryptographic-failures/key-management
touch 02-cryptographic-failures/README.md
touch 02-cryptographic-failures/password-hashing/README.md
touch 02-cryptographic-failures/encryption-at-rest/README.md
touch 02-cryptographic-failures/tls-config/README.md
touch 02-cryptographic-failures/key-management/README.md

# ── 03 INJECTION ────────────────────────────────────

mkdir -p 03-injection/sql-injection/integrations
mkdir -p 03-injection/nosql-injection/integrations
mkdir -p 03-injection/command-injection/integrations
mkdir -p 03-injection/ldap-injection/integrations
mkdir -p 03-injection/xss/integrations
touch 03-injection/README.md
touch 03-injection/sql-injection/README.md
touch 03-injection/nosql-injection/README.md
touch 03-injection/command-injection/README.md
touch 03-injection/ldap-injection/README.md
touch 03-injection/xss/README.md

# ── 04 INSECURE DESIGN ──────────────────────────────

mkdir -p 04-insecure-design/rate-limiting/integrations
mkdir -p 04-insecure-design/input-validation/integrations
mkdir -p 04-insecure-design/threat-modeling-templates
touch 04-insecure-design/README.md
touch 04-insecure-design/rate-limiting/README.md
touch 04-insecure-design/input-validation/README.md
touch 04-insecure-design/threat-modeling-templates/README.md

# ── 05 SECURITY MISCONFIGURATION ────────────────────

mkdir -p 05-security-misconfiguration/security-headers/csp/integrations
mkdir -p 05-security-misconfiguration/security-headers/cors/integrations
mkdir -p 05-security-misconfiguration/security-headers/hsts/integrations
mkdir -p 05-security-misconfiguration/security-headers/x-frame-options/integrations
mkdir -p 05-security-misconfiguration/error-handling/integrations
mkdir -p 05-security-misconfiguration/server-hardening
touch 05-security-misconfiguration/README.md
touch 05-security-misconfiguration/security-headers/README.md
touch 05-security-misconfiguration/security-headers/csp/README.md
touch 05-security-misconfiguration/security-headers/cors/README.md
touch 05-security-misconfiguration/security-headers/hsts/README.md
touch 05-security-misconfiguration/security-headers/x-frame-options/README.md
touch 05-security-misconfiguration/error-handling/README.md
touch 05-security-misconfiguration/server-hardening/README.md

# ── 06 VULNERABLE COMPONENTS ────────────────────────

mkdir -p 06-vulnerable-components/dependency-scanning
mkdir -p 06-vulnerable-components/update-policies
touch 06-vulnerable-components/README.md
touch 06-vulnerable-components/dependency-scanning/README.md
touch 06-vulnerable-components/update-policies/README.md

# ── 07 AUTH FAILURES ────────────────────────────────

mkdir -p 07-auth-failures/jwt/integrations
mkdir -p 07-auth-failures/session-management/integrations
mkdir -p 07-auth-failures/mfa/integrations
mkdir -p 07-auth-failures/oauth2/integrations
mkdir -p 07-auth-failures/magic-links/integrations
mkdir -p 07-auth-failures/passkeys/integrations
touch 07-auth-failures/README.md
touch 07-auth-failures/jwt/README.md
touch 07-auth-failures/session-management/README.md
touch 07-auth-failures/mfa/README.md
touch 07-auth-failures/oauth2/README.md
touch 07-auth-failures/magic-links/README.md
touch 07-auth-failures/passkeys/README.md

# ── 08 SOFTWARE INTEGRITY ───────────────────────────

mkdir -p 08-software-integrity/subresource-integrity/integrations
mkdir -p 08-software-integrity/signed-commits
mkdir -p 08-software-integrity/ci-cd-security
touch 08-software-integrity/README.md
touch 08-software-integrity/subresource-integrity/README.md
touch 08-software-integrity/signed-commits/README.md
touch 08-software-integrity/ci-cd-security/README.md

# ── 09 LOGGING & MONITORING ─────────────────────────

mkdir -p 09-logging-monitoring/audit-logging/integrations
mkdir -p 09-logging-monitoring/intrusion-detection/integrations
mkdir -p 09-logging-monitoring/alerting/integrations
touch 09-logging-monitoring/README.md
touch 09-logging-monitoring/audit-logging/README.md
touch 09-logging-monitoring/intrusion-detection/README.md
touch 09-logging-monitoring/alerting/README.md

# ── 10 SSRF ─────────────────────────────────────────

mkdir -p 10-ssrf/url-validation/integrations
mkdir -p 10-ssrf/allowlist-patterns/integrations
touch 10-ssrf/README.md
touch 10-ssrf/url-validation/README.md
touch 10-ssrf/allowlist-patterns/README.md

# ── ADVANCED ────────────────────────────────────────

mkdir -p advanced/zero-trust
mkdir -p advanced/secrets-management
mkdir -p advanced/honeypots
mkdir -p advanced/canary-tokens
mkdir -p advanced/certificate-pinning
mkdir -p advanced/supply-chain-security
touch advanced/README.md
touch advanced/zero-trust/README.md
touch advanced/secrets-management/README.md
touch advanced/honeypots/README.md
touch advanced/canary-tokens/README.md
touch advanced/certificate-pinning/README.md
touch advanced/supply-chain-security/README.md

# ── INTEGRATIONS ────────────────────────────────────

mkdir -p integrations/add-jwt-to-existing-api
mkdir -p integrations/add-mfa-to-login
mkdir -p integrations/add-rate-limiting-to-login
mkdir -p integrations/add-rbac-to-existing-app
mkdir -p integrations/add-audit-logging
mkdir -p integrations/add-csp-headers
touch integrations/README.md
touch integrations/add-jwt-to-existing-api/README.md
touch integrations/add-mfa-to-login/README.md
touch integrations/add-rate-limiting-to-login/README.md
touch integrations/add-rbac-to-existing-app/README.md
touch integrations/add-audit-logging/README.md
touch integrations/add-csp-headers/README.md

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo "✅ Scaffold complete. Here's what was created:"
echo ""
find . -name "*.md" | sort
find . -name "LICENSE" | sort
echo ""
echo "📁 Total folders:"
find . -type d | grep -v "^\.$" | wc -l
echo ""
echo "📄 Total .md files:"
find . -name "*.md" | wc -l
echo ""
echo "🚀 Next: git add . && git commit -m '🏗️ Scaffold — full folder structure and empty README stubs' && git push origin main"

