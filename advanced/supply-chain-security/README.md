# Supply Chain Security

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Malicious or compromised code reaching production through the build and dependency pipeline
**Audience:** Senior engineers, platform teams, DevSecOps

---

## What Is Software Supply Chain Security?

Your application's supply chain is every piece of software, every tool, every service, and every process involved in taking source code to a running production system. It includes:

- Open-source dependencies pulled from package registries
- Build tools and compilers
- CI/CD platforms and the actions they execute
- Container base images
- Infrastructure provisioning tools
- Third-party services integrated into the build pipeline

A supply chain attack compromises one of these upstream components to inject malicious code into downstream systems. Because the attack occurs in trusted infrastructure (the build system, a dependency, a CI action), it bypasses application-level security controls and often evades detection for extended periods.

---

## Software Bill of Materials (SBOM)

An SBOM is a formal, machine-readable inventory of all software components — direct and transitive dependencies — included in a software artifact. It is the software equivalent of a food ingredient list.

SBOMs enable:
- **Vulnerability management:** When a new CVE is published, you can quickly determine which of your applications use the affected component
- **Licence compliance:** Verify all components have licences compatible with your distribution requirements
- **Incident response:** If a supply chain compromise is discovered in a specific version of a package, you can immediately identify affected applications

SBOM formats: **SPDX** (Linux Foundation) and **CycloneDX** (OWASP) are the two dominant open standards. Both are supported by major tooling.

---

## Container Image Signing with Sigstore/cosign

Cosign is part of the Sigstore project — a set of tools for signing, verifying, and protecting software supply chain integrity. It allows you to sign container images with a cryptographic signature and verify those signatures in deployment pipelines.

A deployment pipeline that verifies image signatures before pulling to production prevents deployment of unsigned or tampered images — even if an attacker compromises your container registry.

```bash
# Sign an image
cosign sign --key cosign.key ghcr.io/yourorg/yourapp:v1.2.3

# Verify before deployment
cosign verify --key cosign.pub ghcr.io/yourorg/yourapp:v1.2.3
```

---

## SLSA — Supply Chain Levels for Software Artifacts

SLSA (pronounced "salsa") is a security framework from Google that defines a set of incrementally adoptable security requirements for software build pipelines. It has four levels:

- **SLSA 1:** Build process is documented and scripted
- **SLSA 2:** Build service generates provenance (a signed record of how the artifact was built)
- **SLSA 3:** Build service is hardened against tampering, provenance is verified
- **SLSA 4:** Hermetic, reproducible builds with two-party review

Most organisations begin at SLSA 1 and work toward SLSA 3 as a realistic production target.

---

## Available Snippets and Guides

| Tool | Subject | Level | File |
|------|---------|-------|------|
| Syft | SBOM generation | Intermediate | sbom-generation-guide.md |
| Grype | SBOM vulnerability scanning | Intermediate | sbom-vuln-scan-guide.md |
| cosign | Container image signing | Advanced | cosign-signing-guide.md |
| cosign | Verify before deploy — GitHub Actions | Advanced | cosign-verify-action.yml |
| in-toto | Build attestation | Advanced | in-toto-guide.md |
| SLSA | Level 1–3 implementation guide | Advanced | slsa-implementation-guide.md |
