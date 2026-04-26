# A04 — Insecure Design

**OWASP Rank:** 4 of 10
**Risk Level:** High
**New in 2021 OWASP Top 10:** Yes

---

## What Is Insecure Design?

Insecure design is a category that covers missing or fundamentally ineffective security controls that result from decisions made during the design phase — before a single line of code is written. It is distinct from insecure implementation: implementation bugs can be patched. Insecure design cannot be fixed by writing better code. The architecture itself must change.

This distinction matters in practice. A SQL injection vulnerability is an implementation flaw. Parameterise the query and the vulnerability disappears. An application that allows unlimited password reset attempts, or that uses predictable resource identifiers by design, or that stores all user data in one database without any tenant isolation — these are design flaws. You cannot add a parameter binding and call it fixed.

---

## Why This Category Was Added in 2021

The 2021 OWASP Top 10 added this category specifically to push the industry's attention earlier in the development lifecycle. Security historically received attention during code review, penetration testing, and post-breach retrospectives. The earlier in the development process a security control is considered, the cheaper it is to implement correctly and the less likely it is to be skipped under time pressure.

Threat modelling — structured thinking about what could go wrong during the design phase — is the primary practice this category encourages.

---

## Real-World Examples

**Credential stuffing via no rate limiting:** Applications that allow unlimited login attempts can be attacked with credential stuffing — automated testing of username/password combinations obtained from other breaches. Rate limiting and account lockout must be designed in from the start. Adding them retroactively to an application that handles millions of requests per day requires careful architectural work.

**Predictable resource IDs:** An e-commerce application that uses sequential order IDs (`/orders/10042`) without checking whether the authenticated user owns order 10042 exposes every order in the system to any authenticated user. This is not a SQL injection — the query is correct. The design is wrong.

**Insufficient multi-tenancy isolation:** A SaaS application that shares a single database for all customers without proper tenant isolation allows a bug in one customer's query to leak another customer's data. Fixing this requires redesigning the data layer, not patching a function.

---

## What This Section Covers

**Rate Limiting** — Controls that prevent automated abuse of endpoints. Login forms, password reset flows, OTP verification, API endpoints, and any resource-intensive operation must be rate limited. Rate limiting that lives only at the application layer can be bypassed by distributed attacks — the snippets here cover both in-process and Redis-backed distributed rate limiting.

**Input Validation** — Validating the shape, type, length, and range of all incoming data at the application boundary. Input validation is not a substitute for parameterised queries or output encoding, but it is an important layer that catches malformed data before it reaches business logic.

**Threat Modelling Templates** — Structured documents and frameworks for identifying threats during the design phase. Includes a STRIDE template, a data flow diagram template, and a security requirements checklist for new features.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Prevent automated abuse of login or API endpoints | rate-limiting/ |
| Validate the shape and type of incoming request data | input-validation/ |
| Identify security risks in a new feature before building it | threat-modeling-templates/ |
