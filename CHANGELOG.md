# Changelog

All notable changes to `web-security-snippets` are documented here.

This project follows [Semantic Versioning](https://semver.org/) for the library as a whole. Individual snippets are versioned through Git history — every change to a snippet is traceable to a commit with an explanation.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [Unreleased]

### In Progress
- Initial snippet implementations for all OWASP Top 10 categories
- Dependency files for all categories across all supported languages
- Integration guides for add-jwt-to-existing-api, add-mfa-to-login, add-rate-limiting-to-login, add-rbac-to-existing-app, add-audit-logging, add-csp-headers
- Advanced section: zero-trust, secrets-management, honeypots, canary-tokens, certificate-pinning, supply-chain-security
- GitHub Actions workflows for snippet validation and linting
- Issue templates and pull request template

---

## [0.1.0] — Initial Release

### Added
- Complete repository structure across all OWASP Top 10 categories
- Category-level README.md files with real-world breach examples, concept explanations, and snippet navigation tables
- Subcategory README.md files with detailed implementation guidance
- CONTRIBUTING.md with full contribution standards including snippet header format, file naming convention, dependency file requirements, and comment standards by difficulty level
- OWASP-MAP.md mapping every planned snippet to its OWASP category with coverage status
- SECURITY.md with private vulnerability disclosure policy
- LICENSE (MIT)
- .gitignore covering Python, Node.js, Go, Java, Rust, Ruby, C#, PHP, and common editor and OS files
- Placeholder files for all planned snippets — establishes the complete file structure before code is written
- Advanced section covering Zero Trust, Secrets Management, Honeypots, Canary Tokens, Certificate Pinning, and Supply Chain Security

### Structure
- 10 OWASP Top 10 category directories
- 1 Advanced section directory with 6 subcategories
- 1 Integrations directory with 6 integration guides
- 98 total directories
- 592 total files (placeholders + documentation)

---

## Versioning Policy

**Major versions (1.0.0, 2.0.0):** Significant restructuring of the repository, changes to the snippet header format, or changes that require existing users to update how they reference snippets.

**Minor versions (0.1.0, 0.2.0):** New categories, new languages, new integrations, or significant additions of snippets.

**Patch versions (0.1.1, 0.1.2):** Corrections to existing snippets (bug fixes, dependency updates, security fixes), documentation improvements, and minor additions within existing categories.

---

## Security Fixes

Security fixes to snippets in this library are documented here with the category and file affected, a description of the issue, and the corrected approach. Reporter credit is included where the reporter has consented.

*No security fixes recorded yet — library is in initial development.*

---

[Unreleased]: https://github.com/lethabokhedama-png/web-security-snippets/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/lethabokhedama-png/web-security-snippets/releases/tag/v0.1.0
