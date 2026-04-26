# Zero Trust Architecture

**Category:** Advanced — Beyond OWASP Top 10
**Risk addressed:** Lateral movement after perimeter breach, insider threat, compromised service accounts
**Audience:** Senior engineers, architects, platform and infrastructure teams

---

## The Zero Trust Principle

Zero trust is an architectural philosophy based on one premise: never trust any network location, user, device, or service by default — regardless of whether it is inside the corporate network perimeter. Every access request must be continuously authenticated, authorised, and encrypted.

Traditional perimeter security models assume that anything inside the network boundary is trusted. When this boundary is breached — through a VPN credential compromise, a phishing attack, or a supply chain compromise — an attacker who reaches the internal network has broad access to internal services that trust each other implicitly. The SolarWinds attack exploited exactly this: once inside the network, the attacker moved laterally through systems that trusted traffic from other internal systems.

Zero trust removes this assumption. An internal service receives a request from another internal service and asks: who are you, are you authorised for this action, and can I verify this cryptographically?

---

## Mutual TLS (mTLS) for Service-to-Service Authentication

In a traditional TLS connection, only the server presents a certificate. The client verifies the server is who it claims to be, but the server accepts any client. In mutual TLS, both parties present certificates and verify each other. This means a compromised service cannot make authenticated requests to other internal services without also possessing a valid client certificate issued by the trusted CA.

mTLS is the primary mechanism for zero-trust service-to-service authentication. Implementing it across a service mesh (Istio, Linkerd, Consul Connect) automates certificate issuance, rotation, and enforcement without requiring application code changes.

---

## SPIFFE and SPIRE

SPIFFE (Secure Production Identity Framework for Everyone) is an open standard for service identity in dynamic, multi-cloud environments. SPIRE (the SPIFFE Runtime Environment) is the reference implementation.

SPIFFE assigns every workload a SPIFFE ID — a URI that uniquely identifies the workload regardless of where it is running. SPIRE automatically issues and rotates short-lived X.509 certificates encoding the SPIFFE ID. These certificates can be used for mTLS without any manual certificate management.

---

## Available Snippets

| Pattern | Technology | Level | File |
|---------|------------|-------|------|
| mTLS — Go server and client | Go | Advanced | go-mtls-server.go / go-mtls-client.go |
| mTLS — Python client | Python | Advanced | python-mtls-client.py |
| mTLS — Node.js server | Node.js | Advanced | node-mtls-server.js |
| mTLS — Nginx proxy config | Nginx | Advanced | nginx-mtls.conf |
| SPIFFE — workload attestation | Go + SPIRE | Advanced | go-spiffe-attestation.go |
| Istio — mTLS policy | Kubernetes + Istio | Advanced | istio-mtls-policy.yaml |
