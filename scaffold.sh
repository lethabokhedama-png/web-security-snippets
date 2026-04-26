#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# web-security-snippets — Full Scaffold Script
# Run from INSIDE your cloned repo folder:
#   cd /storage/6A8E-8C42/web-security-snippets
#   bash scaffold.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e
echo ""
echo "🔐 web-security-snippets — Full Scaffold"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── HELPER ───────────────────────────────────────────────
mk() { mkdir -p "$@"; }
t()  { touch "$@"; }

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# .github
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 Creating .github infrastructure..."
mk .github/ISSUE_TEMPLATE
mk .github/workflows
t .github/ISSUE_TEMPLATE/bug_report.md
t .github/ISSUE_TEMPLATE/new_snippet.md
t .github/ISSUE_TEMPLATE/security_report.md
t .github/PULL_REQUEST_TEMPLATE.md
t .github/workflows/lint.yml
t .github/workflows/validate-snippets.yml

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Root files
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📄 Creating root files..."
t .gitignore
t README.md
t CONTRIBUTING.md
t OWASP-MAP.md
t SECURITY.md
t CHANGELOG.md
t LICENSE

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 01 — Broken Access Control
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 01-broken-access-control..."
mk 01-broken-access-control/rbac
mk 01-broken-access-control/abac
mk 01-broken-access-control/api-key-validation
t 01-broken-access-control/README.md

# rbac
t 01-broken-access-control/rbac/README.md
t 01-broken-access-control/rbac/requirements.txt
t 01-broken-access-control/rbac/package.json
t 01-broken-access-control/rbac/go.mod
t 01-broken-access-control/rbac/Gemfile
t 01-broken-access-control/rbac/composer.json
t 01-broken-access-control/rbac/pom.xml
t 01-broken-access-control/rbac/python-flask-beginner.py
t 01-broken-access-control/rbac/python-flask-advanced.py
t 01-broken-access-control/rbac/python-django-intermediate.py
t 01-broken-access-control/rbac/python-fastapi-advanced.py
t 01-broken-access-control/rbac/node-express-beginner.js
t 01-broken-access-control/rbac/node-express-advanced.js
t 01-broken-access-control/rbac/node-nestjs-intermediate.ts
t 01-broken-access-control/rbac/go-gin-advanced.go
t 01-broken-access-control/rbac/java-spring-advanced.java
t 01-broken-access-control/rbac/php-laravel-intermediate.php
t 01-broken-access-control/rbac/ruby-rails-intermediate.rb
t 01-broken-access-control/rbac/csharp-aspnet-intermediate.cs

# abac
t 01-broken-access-control/abac/README.md
t 01-broken-access-control/abac/requirements.txt
t 01-broken-access-control/abac/package.json
t 01-broken-access-control/abac/go.mod
t 01-broken-access-control/abac/python-fastapi-advanced.py
t 01-broken-access-control/abac/python-flask-intermediate.py
t 01-broken-access-control/abac/node-express-intermediate.js
t 01-broken-access-control/abac/node-nestjs-advanced.ts
t 01-broken-access-control/abac/go-gin-advanced.go

# api-key-validation
t 01-broken-access-control/api-key-validation/README.md
t 01-broken-access-control/api-key-validation/requirements.txt
t 01-broken-access-control/api-key-validation/package.json
t 01-broken-access-control/api-key-validation/go.mod
t 01-broken-access-control/api-key-validation/Gemfile
t 01-broken-access-control/api-key-validation/python-flask-beginner.py
t 01-broken-access-control/api-key-validation/python-fastapi-intermediate.py
t 01-broken-access-control/api-key-validation/node-express-beginner.js
t 01-broken-access-control/api-key-validation/node-express-advanced.js
t 01-broken-access-control/api-key-validation/go-gin-advanced.go
t 01-broken-access-control/api-key-validation/ruby-rails-intermediate.rb

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 02 — Cryptographic Failures
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 02-cryptographic-failures..."
mk 02-cryptographic-failures/password-hashing
mk 02-cryptographic-failures/encryption-at-rest
mk 02-cryptographic-failures/tls-config
mk 02-cryptographic-failures/key-management
t 02-cryptographic-failures/README.md

# password-hashing
t 02-cryptographic-failures/password-hashing/README.md
t 02-cryptographic-failures/password-hashing/requirements.txt
t 02-cryptographic-failures/password-hashing/package.json
t 02-cryptographic-failures/password-hashing/go.mod
t 02-cryptographic-failures/password-hashing/Gemfile
t 02-cryptographic-failures/password-hashing/Cargo.toml
t 02-cryptographic-failures/password-hashing/composer.json
t 02-cryptographic-failures/password-hashing/pom.xml
t 02-cryptographic-failures/password-hashing/python-bcrypt-beginner.py
t 02-cryptographic-failures/password-hashing/python-bcrypt-advanced.py
t 02-cryptographic-failures/password-hashing/python-argon2-advanced.py
t 02-cryptographic-failures/password-hashing/node-bcrypt-beginner.js
t 02-cryptographic-failures/password-hashing/node-argon2-intermediate.js
t 02-cryptographic-failures/password-hashing/go-bcrypt-beginner.go
t 02-cryptographic-failures/password-hashing/go-argon2-advanced.go
t 02-cryptographic-failures/password-hashing/java-spring-bcrypt-intermediate.java
t 02-cryptographic-failures/password-hashing/php-beginner.php
t 02-cryptographic-failures/password-hashing/ruby-bcrypt-beginner.rb
t 02-cryptographic-failures/password-hashing/rust-argon2-advanced.rs

# encryption-at-rest
t 02-cryptographic-failures/encryption-at-rest/README.md
t 02-cryptographic-failures/encryption-at-rest/requirements.txt
t 02-cryptographic-failures/encryption-at-rest/package.json
t 02-cryptographic-failures/encryption-at-rest/go.mod
t 02-cryptographic-failures/encryption-at-rest/Gemfile
t 02-cryptographic-failures/encryption-at-rest/python-aes-gcm-intermediate.py
t 02-cryptographic-failures/encryption-at-rest/node-aes-gcm-intermediate.js
t 02-cryptographic-failures/encryption-at-rest/go-aes-gcm-advanced.go
t 02-cryptographic-failures/encryption-at-rest/java-aes-gcm-advanced.java
t 02-cryptographic-failures/encryption-at-rest/ruby-aes-gcm-intermediate.rb

# tls-config
t 02-cryptographic-failures/tls-config/README.md
t 02-cryptographic-failures/tls-config/nginx-intermediate.conf
t 02-cryptographic-failures/tls-config/apache-intermediate.conf
t 02-cryptographic-failures/tls-config/node-https-intermediate.js
t 02-cryptographic-failures/tls-config/go-tls-advanced.go
t 02-cryptographic-failures/tls-config/caddy-beginner.caddyfile

# key-management
t 02-cryptographic-failures/key-management/README.md
t 02-cryptographic-failures/key-management/requirements.txt
t 02-cryptographic-failures/key-management/package.json
t 02-cryptographic-failures/key-management/go.mod
t 02-cryptographic-failures/key-management/python-env-beginner.py
t 02-cryptographic-failures/key-management/python-vault-advanced.py
t 02-cryptographic-failures/key-management/python-aws-secrets-advanced.py
t 02-cryptographic-failures/key-management/python-gcp-secrets-advanced.py
t 02-cryptographic-failures/key-management/python-rotation-intermediate.py
t 02-cryptographic-failures/key-management/node-env-beginner.js
t 02-cryptographic-failures/key-management/node-aws-secrets-advanced.js
t 02-cryptographic-failures/key-management/go-vault-advanced.go

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 03 — Injection
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 03-injection..."
mk 03-injection/sql-injection
mk 03-injection/nosql-injection
mk 03-injection/command-injection
mk 03-injection/ldap-injection
mk 03-injection/xss
t 03-injection/README.md

# sql-injection
t 03-injection/sql-injection/README.md
t 03-injection/sql-injection/requirements.txt
t 03-injection/sql-injection/package.json
t 03-injection/sql-injection/go.mod
t 03-injection/sql-injection/Gemfile
t 03-injection/sql-injection/composer.json
t 03-injection/sql-injection/pom.xml
t 03-injection/sql-injection/python-flask-sqlalchemy-beginner.py
t 03-injection/sql-injection/python-flask-sqlalchemy-advanced.py
t 03-injection/sql-injection/python-django-intermediate.py
t 03-injection/sql-injection/python-psycopg2-intermediate.py
t 03-injection/sql-injection/node-express-pg-beginner.js
t 03-injection/sql-injection/node-express-mysql-beginner.js
t 03-injection/sql-injection/node-sequelize-intermediate.js
t 03-injection/sql-injection/go-gin-pgx-advanced.go
t 03-injection/sql-injection/go-stdlib-intermediate.go
t 03-injection/sql-injection/java-spring-jdbc-advanced.java
t 03-injection/sql-injection/java-hibernate-intermediate.java
t 03-injection/sql-injection/php-laravel-beginner.php
t 03-injection/sql-injection/php-pdo-intermediate.php
t 03-injection/sql-injection/ruby-rails-beginner.rb
t 03-injection/sql-injection/csharp-aspnet-dapper-intermediate.cs

# nosql-injection
t 03-injection/nosql-injection/README.md
t 03-injection/nosql-injection/requirements.txt
t 03-injection/nosql-injection/package.json
t 03-injection/nosql-injection/node-mongoose-beginner.js
t 03-injection/nosql-injection/node-native-intermediate.js
t 03-injection/nosql-injection/python-flask-intermediate.py
t 03-injection/nosql-injection/python-fastapi-advanced.py

# command-injection
t 03-injection/command-injection/README.md
t 03-injection/command-injection/requirements.txt
t 03-injection/command-injection/package.json
t 03-injection/command-injection/go.mod
t 03-injection/command-injection/Gemfile
t 03-injection/command-injection/pom.xml
t 03-injection/command-injection/python-beginner.py
t 03-injection/command-injection/python-advanced.py
t 03-injection/command-injection/node-beginner.js
t 03-injection/command-injection/go-advanced.go
t 03-injection/command-injection/ruby-intermediate.rb
t 03-injection/command-injection/java-intermediate.java

# ldap-injection
t 03-injection/ldap-injection/README.md
t 03-injection/ldap-injection/requirements.txt
t 03-injection/ldap-injection/package.json
t 03-injection/ldap-injection/pom.xml
t 03-injection/ldap-injection/java-spring-advanced.java
t 03-injection/ldap-injection/python-intermediate.py
t 03-injection/ldap-injection/node-intermediate.js
t 03-injection/ldap-injection/csharp-advanced.cs

# xss
t 03-injection/xss/README.md
t 03-injection/xss/requirements.txt
t 03-injection/xss/package.json
t 03-injection/xss/go.mod
t 03-injection/xss/Gemfile
t 03-injection/xss/composer.json
t 03-injection/xss/pom.xml
t 03-injection/xss/python-flask-beginner.py
t 03-injection/xss/python-django-beginner.py
t 03-injection/xss/node-express-beginner.js
t 03-injection/xss/node-dompurify-intermediate.js
t 03-injection/xss/javascript-dompurify-intermediate.js
t 03-injection/xss/go-intermediate.go
t 03-injection/xss/php-laravel-beginner.php
t 03-injection/xss/java-spring-intermediate.java

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 04 — Insecure Design
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 04-insecure-design..."
mk 04-insecure-design/rate-limiting
mk 04-insecure-design/input-validation
mk 04-insecure-design/threat-modeling-templates
t 04-insecure-design/README.md

# rate-limiting
t 04-insecure-design/rate-limiting/README.md
t 04-insecure-design/rate-limiting/requirements.txt
t 04-insecure-design/rate-limiting/package.json
t 04-insecure-design/rate-limiting/go.mod
t 04-insecure-design/rate-limiting/Gemfile
t 04-insecure-design/rate-limiting/composer.json
t 04-insecure-design/rate-limiting/pom.xml
t 04-insecure-design/rate-limiting/python-flask-memory-beginner.py
t 04-insecure-design/rate-limiting/python-flask-redis-intermediate.py
t 04-insecure-design/rate-limiting/python-fastapi-redis-advanced.py
t 04-insecure-design/rate-limiting/node-express-memory-beginner.js
t 04-insecure-design/rate-limiting/node-express-redis-intermediate.js
t 04-insecure-design/rate-limiting/node-fastify-redis-advanced.js
t 04-insecure-design/rate-limiting/go-gin-memory-intermediate.go
t 04-insecure-design/rate-limiting/go-gin-redis-advanced.go
t 04-insecure-design/rate-limiting/java-spring-redis-advanced.java
t 04-insecure-design/rate-limiting/php-laravel-redis-intermediate.php
t 04-insecure-design/rate-limiting/ruby-rails-redis-intermediate.rb

# input-validation
t 04-insecure-design/input-validation/README.md
t 04-insecure-design/input-validation/requirements.txt
t 04-insecure-design/input-validation/package.json
t 04-insecure-design/input-validation/go.mod
t 04-insecure-design/input-validation/Gemfile
t 04-insecure-design/input-validation/composer.json
t 04-insecure-design/input-validation/pom.xml
t 04-insecure-design/input-validation/python-pydantic-fastapi-beginner.py
t 04-insecure-design/input-validation/python-pydantic-flask-intermediate.py
t 04-insecure-design/input-validation/python-marshmallow-intermediate.py
t 04-insecure-design/input-validation/node-joi-express-beginner.js
t 04-insecure-design/input-validation/node-zod-express-intermediate.js
t 04-insecure-design/input-validation/node-nestjs-intermediate.ts
t 04-insecure-design/input-validation/go-gin-validator-advanced.go
t 04-insecure-design/input-validation/java-spring-intermediate.java
t 04-insecure-design/input-validation/php-laravel-beginner.php
t 04-insecure-design/input-validation/ruby-rails-intermediate.rb
t 04-insecure-design/input-validation/csharp-fluentvalidation-intermediate.cs

# threat-modeling-templates
t 04-insecure-design/threat-modeling-templates/README.md
t 04-insecure-design/threat-modeling-templates/stride-template.md
t 04-insecure-design/threat-modeling-templates/data-flow-diagram-guide.md
t 04-insecure-design/threat-modeling-templates/security-requirements-checklist.md
t 04-insecure-design/threat-modeling-templates/feature-threat-review.md
t 04-insecure-design/threat-modeling-templates/attack-tree-template.md

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 05 — Security Misconfiguration
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 05-security-misconfiguration..."
mk 05-security-misconfiguration/security-headers/csp
mk 05-security-misconfiguration/security-headers/cors
mk 05-security-misconfiguration/security-headers/hsts
mk 05-security-misconfiguration/security-headers/x-frame-options
mk 05-security-misconfiguration/error-handling
mk 05-security-misconfiguration/server-hardening
t 05-security-misconfiguration/README.md
t 05-security-misconfiguration/security-headers/README.md

# csp
t 05-security-misconfiguration/security-headers/csp/README.md
t 05-security-misconfiguration/security-headers/csp/requirements.txt
t 05-security-misconfiguration/security-headers/csp/package.json
t 05-security-misconfiguration/security-headers/csp/go.mod
t 05-security-misconfiguration/security-headers/csp/composer.json
t 05-security-misconfiguration/security-headers/csp/pom.xml
t 05-security-misconfiguration/security-headers/csp/node-express-beginner.js
t 05-security-misconfiguration/security-headers/csp/node-express-advanced.js
t 05-security-misconfiguration/security-headers/csp/python-flask-beginner.py
t 05-security-misconfiguration/security-headers/csp/python-fastapi-intermediate.py
t 05-security-misconfiguration/security-headers/csp/go-gin-intermediate.go
t 05-security-misconfiguration/security-headers/csp/php-laravel-beginner.php
t 05-security-misconfiguration/security-headers/csp/java-spring-intermediate.java
t 05-security-misconfiguration/security-headers/csp/nginx-intermediate.conf

# cors
t 05-security-misconfiguration/security-headers/cors/README.md
t 05-security-misconfiguration/security-headers/cors/requirements.txt
t 05-security-misconfiguration/security-headers/cors/package.json
t 05-security-misconfiguration/security-headers/cors/go.mod
t 05-security-misconfiguration/security-headers/cors/Gemfile
t 05-security-misconfiguration/security-headers/cors/composer.json
t 05-security-misconfiguration/security-headers/cors/pom.xml
t 05-security-misconfiguration/security-headers/cors/node-express-beginner.js
t 05-security-misconfiguration/security-headers/cors/node-express-advanced.js
t 05-security-misconfiguration/security-headers/cors/node-fastify-intermediate.js
t 05-security-misconfiguration/security-headers/cors/python-flask-beginner.py
t 05-security-misconfiguration/security-headers/cors/python-fastapi-intermediate.py
t 05-security-misconfiguration/security-headers/cors/go-gin-advanced.go
t 05-security-misconfiguration/security-headers/cors/java-spring-advanced.java
t 05-security-misconfiguration/security-headers/cors/php-laravel-beginner.php
t 05-security-misconfiguration/security-headers/cors/ruby-rails-intermediate.rb
t 05-security-misconfiguration/security-headers/cors/csharp-aspnet-intermediate.cs

# hsts
t 05-security-misconfiguration/security-headers/hsts/README.md
t 05-security-misconfiguration/security-headers/hsts/requirements.txt
t 05-security-misconfiguration/security-headers/hsts/package.json
t 05-security-misconfiguration/security-headers/hsts/go.mod
t 05-security-misconfiguration/security-headers/hsts/node-express-beginner.js
t 05-security-misconfiguration/security-headers/hsts/python-flask-beginner.py
t 05-security-misconfiguration/security-headers/hsts/go-gin-intermediate.go
t 05-security-misconfiguration/security-headers/hsts/java-spring-intermediate.java
t 05-security-misconfiguration/security-headers/hsts/nginx-intermediate.conf
t 05-security-misconfiguration/security-headers/hsts/apache-intermediate.conf

# x-frame-options
t 05-security-misconfiguration/security-headers/x-frame-options/README.md
t 05-security-misconfiguration/security-headers/x-frame-options/requirements.txt
t 05-security-misconfiguration/security-headers/x-frame-options/package.json
t 05-security-misconfiguration/security-headers/x-frame-options/go.mod
t 05-security-misconfiguration/security-headers/x-frame-options/composer.json
t 05-security-misconfiguration/security-headers/x-frame-options/pom.xml
t 05-security-misconfiguration/security-headers/x-frame-options/node-express-beginner.js
t 05-security-misconfiguration/security-headers/x-frame-options/python-flask-beginner.py
t 05-security-misconfiguration/security-headers/x-frame-options/go-gin-intermediate.go
t 05-security-misconfiguration/security-headers/x-frame-options/php-laravel-beginner.php
t 05-security-misconfiguration/security-headers/x-frame-options/java-spring-intermediate.java
t 05-security-misconfiguration/security-headers/x-frame-options/nginx-beginner.conf

# error-handling
t 05-security-misconfiguration/error-handling/README.md
t 05-security-misconfiguration/error-handling/requirements.txt
t 05-security-misconfiguration/error-handling/package.json
t 05-security-misconfiguration/error-handling/go.mod
t 05-security-misconfiguration/error-handling/Gemfile
t 05-security-misconfiguration/error-handling/composer.json
t 05-security-misconfiguration/error-handling/pom.xml
t 05-security-misconfiguration/error-handling/python-flask-beginner.py
t 05-security-misconfiguration/error-handling/python-fastapi-intermediate.py
t 05-security-misconfiguration/error-handling/python-django-intermediate.py
t 05-security-misconfiguration/error-handling/node-express-beginner.js
t 05-security-misconfiguration/error-handling/node-fastify-intermediate.js
t 05-security-misconfiguration/error-handling/go-gin-advanced.go
t 05-security-misconfiguration/error-handling/java-spring-intermediate.java
t 05-security-misconfiguration/error-handling/php-laravel-beginner.php
t 05-security-misconfiguration/error-handling/ruby-rails-beginner.rb
t 05-security-misconfiguration/error-handling/csharp-aspnet-intermediate.cs

# server-hardening
t 05-security-misconfiguration/server-hardening/README.md
t 05-security-misconfiguration/server-hardening/nginx-hardening-guide.conf
t 05-security-misconfiguration/server-hardening/apache-hardening-guide.conf
t 05-security-misconfiguration/server-hardening/linux-baseline.sh
t 05-security-misconfiguration/server-hardening/docker-security-guide.md
t 05-security-misconfiguration/server-hardening/ssh-hardening-guide.conf

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 06 — Vulnerable Components
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 06-vulnerable-components..."
mk 06-vulnerable-components/dependency-scanning
mk 06-vulnerable-components/update-policies
t 06-vulnerable-components/README.md

t 06-vulnerable-components/dependency-scanning/README.md
t 06-vulnerable-components/dependency-scanning/node-npm-audit-beginner.md
t 06-vulnerable-components/dependency-scanning/python-pip-audit-beginner.md
t 06-vulnerable-components/dependency-scanning/go-govulncheck-intermediate.md
t 06-vulnerable-components/dependency-scanning/rust-cargo-audit-intermediate.md
t 06-vulnerable-components/dependency-scanning/java-dependency-check-advanced.md
t 06-vulnerable-components/dependency-scanning/ruby-bundler-audit-beginner.md
t 06-vulnerable-components/dependency-scanning/snyk-ci-intermediate.yml
t 06-vulnerable-components/dependency-scanning/github-actions-npm-beginner.yml
t 06-vulnerable-components/dependency-scanning/github-actions-pip-beginner.yml
t 06-vulnerable-components/dependency-scanning/github-actions-go-intermediate.yml

t 06-vulnerable-components/update-policies/README.md
t 06-vulnerable-components/update-policies/dependabot-beginner.yml
t 06-vulnerable-components/update-policies/dependabot-security-only-beginner.yml
t 06-vulnerable-components/update-policies/renovate-intermediate.json
t 06-vulnerable-components/update-policies/renovate-advanced.json
t 06-vulnerable-components/update-policies/update-policy-template.md

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 07 — Authentication Failures
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 07-auth-failures..."
mk 07-auth-failures/jwt
mk 07-auth-failures/session-management
mk 07-auth-failures/mfa
mk 07-auth-failures/oauth2
mk 07-auth-failures/magic-links
mk 07-auth-failures/passkeys
t 07-auth-failures/README.md

# jwt
t 07-auth-failures/jwt/README.md
t 07-auth-failures/jwt/requirements.txt
t 07-auth-failures/jwt/package.json
t 07-auth-failures/jwt/go.mod
t 07-auth-failures/jwt/Gemfile
t 07-auth-failures/jwt/Cargo.toml
t 07-auth-failures/jwt/composer.json
t 07-auth-failures/jwt/pom.xml
t 07-auth-failures/jwt/python-flask-hs256-beginner.py
t 07-auth-failures/jwt/python-flask-rs256-advanced.py
t 07-auth-failures/jwt/python-fastapi-rs256-advanced.py
t 07-auth-failures/jwt/node-express-hs256-beginner.js
t 07-auth-failures/jwt/node-express-rs256-advanced.js
t 07-auth-failures/jwt/node-express-jwks-advanced.js
t 07-auth-failures/jwt/go-gin-rs256-advanced.go
t 07-auth-failures/jwt/java-spring-rs256-advanced.java
t 07-auth-failures/jwt/php-laravel-intermediate.php
t 07-auth-failures/jwt/ruby-rails-intermediate.rb
t 07-auth-failures/jwt/rust-axum-advanced.rs
t 07-auth-failures/jwt/csharp-aspnet-advanced.cs

# session-management
t 07-auth-failures/session-management/README.md
t 07-auth-failures/session-management/requirements.txt
t 07-auth-failures/session-management/package.json
t 07-auth-failures/session-management/go.mod
t 07-auth-failures/session-management/Gemfile
t 07-auth-failures/session-management/composer.json
t 07-auth-failures/session-management/pom.xml
t 07-auth-failures/session-management/python-flask-beginner.py
t 07-auth-failures/session-management/python-flask-redis-intermediate.py
t 07-auth-failures/session-management/python-django-beginner.py
t 07-auth-failures/session-management/node-express-memory-beginner.js
t 07-auth-failures/session-management/node-express-redis-intermediate.js
t 07-auth-failures/session-management/go-gin-redis-advanced.go
t 07-auth-failures/session-management/php-laravel-beginner.php
t 07-auth-failures/session-management/ruby-rails-beginner.rb
t 07-auth-failures/session-management/java-spring-redis-intermediate.java
t 07-auth-failures/session-management/csharp-aspnet-intermediate.cs

# mfa
t 07-auth-failures/mfa/README.md
t 07-auth-failures/mfa/requirements.txt
t 07-auth-failures/mfa/package.json
t 07-auth-failures/mfa/go.mod
t 07-auth-failures/mfa/Gemfile
t 07-auth-failures/mfa/composer.json
t 07-auth-failures/mfa/pom.xml
t 07-auth-failures/mfa/python-flask-totp-intermediate.py
t 07-auth-failures/mfa/python-fastapi-totp-intermediate.py
t 07-auth-failures/mfa/node-express-totp-intermediate.js
t 07-auth-failures/mfa/node-express-sms-intermediate.js
t 07-auth-failures/mfa/node-express-email-beginner.js
t 07-auth-failures/mfa/go-gin-totp-advanced.go
t 07-auth-failures/mfa/java-spring-totp-advanced.java
t 07-auth-failures/mfa/php-laravel-totp-intermediate.php
t 07-auth-failures/mfa/ruby-rails-totp-intermediate.rb
t 07-auth-failures/mfa/backup-codes-pattern.md

# oauth2
t 07-auth-failures/oauth2/README.md
t 07-auth-failures/oauth2/requirements.txt
t 07-auth-failures/oauth2/package.json
t 07-auth-failures/oauth2/go.mod
t 07-auth-failures/oauth2/Gemfile
t 07-auth-failures/oauth2/composer.json
t 07-auth-failures/oauth2/pom.xml
t 07-auth-failures/oauth2/node-express-intermediate.js
t 07-auth-failures/oauth2/node-nextjs-intermediate.js
t 07-auth-failures/oauth2/python-flask-intermediate.py
t 07-auth-failures/oauth2/python-fastapi-intermediate.py
t 07-auth-failures/oauth2/go-gin-advanced.go
t 07-auth-failures/oauth2/java-spring-advanced.java
t 07-auth-failures/oauth2/php-laravel-beginner.php
t 07-auth-failures/oauth2/ruby-rails-beginner.rb
t 07-auth-failures/oauth2/javascript-pkce-spa-advanced.js

# magic-links
t 07-auth-failures/magic-links/README.md
t 07-auth-failures/magic-links/requirements.txt
t 07-auth-failures/magic-links/package.json
t 07-auth-failures/magic-links/go.mod
t 07-auth-failures/magic-links/Gemfile
t 07-auth-failures/magic-links/composer.json
t 07-auth-failures/magic-links/node-express-intermediate.js
t 07-auth-failures/magic-links/node-express-nodemailer-beginner.js
t 07-auth-failures/magic-links/python-flask-intermediate.py
t 07-auth-failures/magic-links/python-fastapi-intermediate.py
t 07-auth-failures/magic-links/go-gin-advanced.go
t 07-auth-failures/magic-links/php-laravel-intermediate.php
t 07-auth-failures/magic-links/ruby-rails-intermediate.rb

# passkeys
t 07-auth-failures/passkeys/README.md
t 07-auth-failures/passkeys/requirements.txt
t 07-auth-failures/passkeys/package.json
t 07-auth-failures/passkeys/go.mod
t 07-auth-failures/passkeys/pom.xml
t 07-auth-failures/passkeys/node-express-advanced.js
t 07-auth-failures/passkeys/javascript-client-advanced.js
t 07-auth-failures/passkeys/python-flask-advanced.py
t 07-auth-failures/passkeys/go-gin-advanced.go
t 07-auth-failures/passkeys/java-spring-advanced.java

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 08 — Software Integrity
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 08-software-integrity..."
mk 08-software-integrity/subresource-integrity
mk 08-software-integrity/signed-commits
mk 08-software-integrity/ci-cd-security
t 08-software-integrity/README.md

t 08-software-integrity/subresource-integrity/README.md
t 08-software-integrity/subresource-integrity/requirements.txt
t 08-software-integrity/subresource-integrity/package.json
t 08-software-integrity/subresource-integrity/html-static-beginner.html
t 08-software-integrity/subresource-integrity/node-sri-generator-intermediate.js
t 08-software-integrity/subresource-integrity/python-sri-generator-intermediate.py
t 08-software-integrity/subresource-integrity/webpack-sri-advanced.js

t 08-software-integrity/signed-commits/README.md
t 08-software-integrity/signed-commits/gpg-setup-guide.md
t 08-software-integrity/signed-commits/ssh-signing-guide.md
t 08-software-integrity/signed-commits/github-branch-protection-guide.md
t 08-software-integrity/signed-commits/gitlab-push-rules-guide.md
t 08-software-integrity/signed-commits/ci-verification-guide.md

t 08-software-integrity/ci-cd-security/README.md
t 08-software-integrity/ci-cd-security/github-actions-hardened-intermediate.yml
t 08-software-integrity/ci-cd-security/github-actions-secret-scan-intermediate.yml
t 08-software-integrity/ci-cd-security/github-actions-vuln-gate-beginner.yml
t 08-software-integrity/ci-cd-security/github-actions-oidc-advanced.yml
t 08-software-integrity/ci-cd-security/gitlab-ci-hardened-advanced.yml
t 08-software-integrity/ci-cd-security/pre-commit-gitleaks-beginner.yaml

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 09 — Logging and Monitoring
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 09-logging-monitoring..."
mk 09-logging-monitoring/audit-logging
mk 09-logging-monitoring/intrusion-detection
mk 09-logging-monitoring/alerting
t 09-logging-monitoring/README.md

t 09-logging-monitoring/audit-logging/README.md
t 09-logging-monitoring/audit-logging/requirements.txt
t 09-logging-monitoring/audit-logging/package.json
t 09-logging-monitoring/audit-logging/go.mod
t 09-logging-monitoring/audit-logging/Gemfile
t 09-logging-monitoring/audit-logging/composer.json
t 09-logging-monitoring/audit-logging/pom.xml
t 09-logging-monitoring/audit-logging/python-flask-structlog-beginner.py
t 09-logging-monitoring/audit-logging/python-fastapi-structlog-intermediate.py
t 09-logging-monitoring/audit-logging/python-django-structlog-intermediate.py
t 09-logging-monitoring/audit-logging/node-express-winston-beginner.js
t 09-logging-monitoring/audit-logging/node-express-pino-intermediate.js
t 09-logging-monitoring/audit-logging/node-fastify-pino-intermediate.js
t 09-logging-monitoring/audit-logging/go-gin-zerolog-advanced.go
t 09-logging-monitoring/audit-logging/java-spring-logback-intermediate.java
t 09-logging-monitoring/audit-logging/php-laravel-beginner.php
t 09-logging-monitoring/audit-logging/ruby-rails-intermediate.rb
t 09-logging-monitoring/audit-logging/csharp-serilog-intermediate.cs

t 09-logging-monitoring/intrusion-detection/README.md
t 09-logging-monitoring/intrusion-detection/requirements.txt
t 09-logging-monitoring/intrusion-detection/package.json
t 09-logging-monitoring/intrusion-detection/go.mod
t 09-logging-monitoring/intrusion-detection/python-flask-login-tracking-intermediate.py
t 09-logging-monitoring/intrusion-detection/python-flask-redis-advanced.py
t 09-logging-monitoring/intrusion-detection/node-express-intermediate.js
t 09-logging-monitoring/intrusion-detection/node-express-redis-advanced.js
t 09-logging-monitoring/intrusion-detection/go-gin-advanced.go
t 09-logging-monitoring/intrusion-detection/java-spring-advanced.java

t 09-logging-monitoring/alerting/README.md
t 09-logging-monitoring/alerting/requirements.txt
t 09-logging-monitoring/alerting/package.json
t 09-logging-monitoring/alerting/go.mod
t 09-logging-monitoring/alerting/python-slack-beginner.py
t 09-logging-monitoring/alerting/python-pagerduty-advanced.py
t 09-logging-monitoring/alerting/python-email-beginner.py
t 09-logging-monitoring/alerting/node-slack-beginner.js
t 09-logging-monitoring/alerting/node-pagerduty-advanced.js
t 09-logging-monitoring/alerting/go-slack-intermediate.go
t 09-logging-monitoring/alerting/alerting-thresholds-guide.md
t 09-logging-monitoring/alerting/escalation-policy-template.md

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 10 — SSRF
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 10-ssrf..."
mk 10-ssrf/url-validation
mk 10-ssrf/allowlist-patterns
t 10-ssrf/README.md

t 10-ssrf/url-validation/README.md
t 10-ssrf/url-validation/requirements.txt
t 10-ssrf/url-validation/package.json
t 10-ssrf/url-validation/go.mod
t 10-ssrf/url-validation/Gemfile
t 10-ssrf/url-validation/composer.json
t 10-ssrf/url-validation/pom.xml
t 10-ssrf/url-validation/python-beginner.py
t 10-ssrf/url-validation/python-advanced.py
t 10-ssrf/url-validation/node-beginner.js
t 10-ssrf/url-validation/node-advanced.js
t 10-ssrf/url-validation/go-advanced.go
t 10-ssrf/url-validation/java-advanced.java
t 10-ssrf/url-validation/php-intermediate.php
t 10-ssrf/url-validation/ruby-intermediate.rb

t 10-ssrf/allowlist-patterns/README.md
t 10-ssrf/allowlist-patterns/requirements.txt
t 10-ssrf/allowlist-patterns/package.json
t 10-ssrf/allowlist-patterns/go.mod
t 10-ssrf/allowlist-patterns/python-domain-allowlist-intermediate.py
t 10-ssrf/allowlist-patterns/python-ip-allowlist-intermediate.py
t 10-ssrf/allowlist-patterns/python-combined-advanced.py
t 10-ssrf/allowlist-patterns/node-domain-allowlist-intermediate.js
t 10-ssrf/allowlist-patterns/node-ip-allowlist-intermediate.js
t 10-ssrf/allowlist-patterns/go-combined-advanced.go
t 10-ssrf/allowlist-patterns/java-advanced.java

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# advanced/
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 advanced/..."
mk advanced/zero-trust
mk advanced/secrets-management
mk advanced/honeypots
mk advanced/canary-tokens
mk advanced/certificate-pinning
mk advanced/supply-chain-security
t advanced/README.md

t advanced/zero-trust/README.md
t advanced/zero-trust/requirements.txt
t advanced/zero-trust/package.json
t advanced/zero-trust/go.mod
t advanced/zero-trust/go-mtls-server.go
t advanced/zero-trust/go-mtls-client.go
t advanced/zero-trust/go-spiffe-attestation.go
t advanced/zero-trust/python-mtls-client.py
t advanced/zero-trust/node-mtls-server.js
t advanced/zero-trust/nginx-mtls.conf
t advanced/zero-trust/istio-mtls-policy.yaml

t advanced/secrets-management/README.md
t advanced/secrets-management/requirements.txt
t advanced/secrets-management/package.json
t advanced/secrets-management/go.mod
t advanced/secrets-management/python-vault-kv.py
t advanced/secrets-management/python-aws-secrets.py
t advanced/secrets-management/python-gcp-secrets.py
t advanced/secrets-management/python-azure-keyvault.py
t advanced/secrets-management/go-vault-dynamic-db.go
t advanced/secrets-management/node-vault-approle.js
t advanced/secrets-management/node-aws-secrets.js
t advanced/secrets-management/rotation-pattern.md

t advanced/honeypots/README.md
t advanced/honeypots/requirements.txt
t advanced/honeypots/package.json
t advanced/honeypots/go.mod
t advanced/honeypots/python-flask-honeypot.py
t advanced/honeypots/node-express-honeypot.js
t advanced/honeypots/go-gin-honeypot.go
t advanced/honeypots/python-honey-records.py
t advanced/honeypots/nginx-honeypot.conf
t advanced/honeypots/honey-token-guide.md

t advanced/canary-tokens/README.md
t advanced/canary-tokens/requirements.txt
t advanced/canary-tokens/package.json
t advanced/canary-tokens/python-db-canary.py
t advanced/canary-tokens/python-url-canary.py
t advanced/canary-tokens/node-url-canary.js
t advanced/canary-tokens/placement-strategy-guide.md
t advanced/canary-tokens/self-hosted-setup-guide.md

t advanced/certificate-pinning/README.md
t advanced/certificate-pinning/requirements.txt
t advanced/certificate-pinning/package.json
t advanced/certificate-pinning/go.mod
t advanced/certificate-pinning/python-requests-pinning.py
t advanced/certificate-pinning/node-https-pinning.js
t advanced/certificate-pinning/go-pinning.go
t advanced/certificate-pinning/android-kotlin-pinning.kt
t advanced/certificate-pinning/ios-swift-pinning.swift
t advanced/certificate-pinning/nginx-pinning-guide.md

t advanced/supply-chain-security/README.md
t advanced/supply-chain-security/sbom-generation-guide.md
t advanced/supply-chain-security/sbom-vuln-scan-guide.md
t advanced/supply-chain-security/cosign-signing-guide.md
t advanced/supply-chain-security/cosign-verify-action.yml
t advanced/supply-chain-security/in-toto-guide.md
t advanced/supply-chain-security/slsa-implementation-guide.md

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# integrations/
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo "📁 integrations/..."
mk integrations/add-jwt-to-existing-api/node-express
mk integrations/add-jwt-to-existing-api/python-flask
mk integrations/add-jwt-to-existing-api/python-fastapi
mk integrations/add-jwt-to-existing-api/go-gin
mk integrations/add-mfa-to-login/node-express
mk integrations/add-mfa-to-login/python-flask
mk integrations/add-mfa-to-login/go-gin
mk integrations/add-rate-limiting-to-login/node-express
mk integrations/add-rate-limiting-to-login/python-flask
mk integrations/add-rate-limiting-to-login/go-gin
mk integrations/add-rbac-to-existing-app/node-express
mk integrations/add-rbac-to-existing-app/python-flask
mk integrations/add-rbac-to-existing-app/go-gin
mk integrations/add-audit-logging/node-express
mk integrations/add-audit-logging/python-flask
mk integrations/add-audit-logging/go-gin
mk integrations/add-csp-headers/node-express
mk integrations/add-csp-headers/python-flask
mk integrations/add-csp-headers/go-gin
t integrations/README.md

# add-jwt-to-existing-api
t integrations/add-jwt-to-existing-api/README.md
t integrations/add-jwt-to-existing-api/requirements.txt
t integrations/add-jwt-to-existing-api/package.json
t integrations/add-jwt-to-existing-api/go.mod
t integrations/add-jwt-to-existing-api/Gemfile
t integrations/add-jwt-to-existing-api/composer.json
t integrations/add-jwt-to-existing-api/pom.xml
t integrations/add-jwt-to-existing-api/node-express/middleware.js
t integrations/add-jwt-to-existing-api/node-express/routes-before.js
t integrations/add-jwt-to-existing-api/node-express/routes-after.js
t integrations/add-jwt-to-existing-api/python-flask/middleware.py
t integrations/add-jwt-to-existing-api/python-flask/routes-before.py
t integrations/add-jwt-to-existing-api/python-flask/routes-after.py
t integrations/add-jwt-to-existing-api/python-fastapi/dependencies.py
t integrations/add-jwt-to-existing-api/python-fastapi/routes-after.py
t integrations/add-jwt-to-existing-api/go-gin/middleware.go
t integrations/add-jwt-to-existing-api/go-gin/routes-after.go

# add-mfa-to-login
t integrations/add-mfa-to-login/README.md
t integrations/add-mfa-to-login/requirements.txt
t integrations/add-mfa-to-login/package.json
t integrations/add-mfa-to-login/go.mod
t integrations/add-mfa-to-login/node-express/totp-setup.js
t integrations/add-mfa-to-login/node-express/totp-verify.js
t integrations/add-mfa-to-login/node-express/routes-after.js
t integrations/add-mfa-to-login/python-flask/totp-setup.py
t integrations/add-mfa-to-login/python-flask/totp-verify.py
t integrations/add-mfa-to-login/python-flask/routes-after.py
t integrations/add-mfa-to-login/go-gin/totp-setup.go
t integrations/add-mfa-to-login/go-gin/totp-verify.go

# add-rate-limiting-to-login
t integrations/add-rate-limiting-to-login/README.md
t integrations/add-rate-limiting-to-login/requirements.txt
t integrations/add-rate-limiting-to-login/package.json
t integrations/add-rate-limiting-to-login/go.mod
t integrations/add-rate-limiting-to-login/node-express/rate-limiter.js
t integrations/add-rate-limiting-to-login/node-express/routes-after.js
t integrations/add-rate-limiting-to-login/python-flask/rate-limiter.py
t integrations/add-rate-limiting-to-login/python-flask/routes-after.py
t integrations/add-rate-limiting-to-login/go-gin/rate-limiter.go
t integrations/add-rate-limiting-to-login/go-gin/routes-after.go

# add-rbac-to-existing-app
t integrations/add-rbac-to-existing-app/README.md
t integrations/add-rbac-to-existing-app/requirements.txt
t integrations/add-rbac-to-existing-app/package.json
t integrations/add-rbac-to-existing-app/go.mod
t integrations/add-rbac-to-existing-app/node-express/rbac-middleware.js
t integrations/add-rbac-to-existing-app/node-express/roles.js
t integrations/add-rbac-to-existing-app/node-express/routes-after.js
t integrations/add-rbac-to-existing-app/python-flask/rbac-middleware.py
t integrations/add-rbac-to-existing-app/python-flask/roles.py
t integrations/add-rbac-to-existing-app/python-flask/routes-after.py
t integrations/add-rbac-to-existing-app/go-gin/rbac-middleware.go
t integrations/add-rbac-to-existing-app/go-gin/routes-after.go

# add-audit-logging
t integrations/add-audit-logging/README.md
t integrations/add-audit-logging/requirements.txt
t integrations/add-audit-logging/package.json
t integrations/add-audit-logging/go.mod
t integrations/add-audit-logging/node-express/audit-logger.js
t integrations/add-audit-logging/node-express/middleware.js
t integrations/add-audit-logging/python-flask/audit-logger.py
t integrations/add-audit-logging/python-flask/middleware.py
t integrations/add-audit-logging/go-gin/audit-logger.go
t integrations/add-audit-logging/go-gin/middleware.go

# add-csp-headers
t integrations/add-csp-headers/README.md
t integrations/add-csp-headers/requirements.txt
t integrations/add-csp-headers/package.json
t integrations/add-csp-headers/go.mod
t integrations/add-csp-headers/node-express/csp-middleware.js
t integrations/add-csp-headers/python-flask/csp-middleware.py
t integrations/add-csp-headers/go-gin/csp-middleware.go

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Scaffold complete"
echo ""
echo "📄 Total files : $(find . -type f | wc -l)"
echo "📁 Total dirs  : $(find . -type d | wc -l)"
echo ""
echo "Next step:"
echo "  git add ."
echo "  git commit -m '🏗️ Full scaffold — all dirs and placeholder files'"
echo "  git push origin main"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
