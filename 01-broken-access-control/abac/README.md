# Attribute-Based Access Control (ABAC)

**OWASP:** A01 — Broken Access Control
**Risk Level:** Critical
**Applies to:** Applications with complex, context-sensitive access rules

---

## What Is ABAC?

Attribute-Based Access Control is an access control model that evaluates access decisions based on attributes rather than fixed roles. Where RBAC asks "what roles does this user have?", ABAC asks "given all the attributes of this user, this resource, and this environment, should access be granted?"

Attributes can describe anything:

- **Subject attributes** — who the user is: their department, clearance level, employment status, whether they have completed MFA
- **Resource attributes** — what is being accessed: the owner of a document, the classification level of a file, the status of an order
- **Action attributes** — what is being attempted: read, write, delete, approve, export
- **Environment attributes** — the context of the request: the current time, the user's IP address, whether they are on a corporate network, whether the system is in maintenance mode

An ABAC policy might read: "Allow access if the user is an employee of the legal department AND the document is classified as legal-internal AND the current time is between 08:00 and 18:00 on a weekday."

---

## When to Use ABAC Instead of RBAC

ABAC is more expressive and more powerful than RBAC. It is also more complex to implement, test, and audit. Use it when:

- Access decisions depend on the relationship between the user and the resource (e.g., users can only edit documents they own)
- Access decisions depend on environmental context (e.g., access is restricted outside business hours or from untrusted networks)
- The number of distinct permission combinations makes RBAC role definitions unwieldy
- Compliance requirements demand fine-grained, auditable access policies

For most applications, RBAC is sufficient and simpler. If you find yourself creating dozens of very specific roles to handle edge cases, ABAC may be a better fit.

---

## ABAC Architecture

A well-designed ABAC system has four components:

**Policy Enforcement Point (PEP)** — the part of the application that intercepts access requests and delegates the access decision to the PDP. In a web application, this is typically a middleware layer.

**Policy Decision Point (PDP)** — the engine that evaluates policies against the attributes of the request and returns an allow or deny decision.

**Policy Information Point (PIP)** — the source of attribute data. This might be the user's profile in the database, an LDAP directory, or an external identity provider.

**Policy Administration Point (PAP)** — the system where policies are written and managed.

The snippets in this folder implement lightweight versions of this architecture suitable for single-application use cases. They are not full-scale XACML (eXtensible Access Control Markup Language) implementations, which are appropriate for enterprise environments with centralised policy management.

---

## Common Mistakes in ABAC Implementations

**Incomplete attribute collection.** An ABAC decision is only as good as the attributes available to the policy engine. If you make an access decision based on the user's department but retrieve that attribute from a cache that has not been invalidated since the user was reassigned, the decision will be wrong.

**Policy logic in application code.** Scattering attribute checks throughout route handlers creates policies that are impossible to audit, test in isolation, or update consistently. All policy logic must live in a centralised policy module.

**Missing deny-by-default.** Any attribute check that fails or returns an unexpected value should result in a deny, not a pass-through. Never allow access when the attribute evaluation is ambiguous.

**Not logging attribute-based decisions.** ABAC decisions are more complex than role checks and harder to reconstruct after the fact. Log the full set of attributes that informed each decision, not just the outcome.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Python | FastAPI | 🔴 Advanced | python-fastapi-advanced.py |
| Python | Flask | 🟡 Intermediate | python-flask-intermediate.py |
| Node.js | Express | 🟡 Intermediate | node-express-intermediate.js |
| Node.js | NestJS | 🔴 Advanced | node-nestjs-advanced.ts |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |

---

## Dependencies

See the dependency file for your language in this folder. All versions are pinned.
