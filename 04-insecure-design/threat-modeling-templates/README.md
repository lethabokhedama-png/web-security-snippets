# Threat Modelling Templates

**OWASP:** A04 — Insecure Design
**Risk Level:** Structural
**Applies to:** All new features, systems, and integrations before implementation begins

---

## What Is Threat Modelling?

Threat modelling is a structured process for identifying security risks in a system during its design phase. It answers four questions:

1. **What are we building?** — A description of the system, its components, and how data flows through it
2. **What can go wrong?** — A systematic enumeration of potential threats
3. **What are we doing about it?** — The controls that address each threat
4. **Did we do a good enough job?** — Review and validation of the model

The goal is to find and address security issues when fixing them is cheapest — before the code exists. A threat identified during design costs almost nothing to address. The same threat identified during a penetration test costs development time, regression testing, and potentially a deployment cycle. Identified post-breach, it costs everything.

---

## STRIDE — The Standard Threat Classification Framework

STRIDE is a threat classification model developed at Microsoft. It provides a systematic checklist of threat types to consider for every component and data flow in a system.

**S — Spoofing:** An attacker pretends to be someone or something they are not. Affects: authentication, identity, API key management.

**T — Tampering:** An attacker modifies data in transit or at rest. Affects: data integrity, message signing, database access controls.

**R — Repudiation:** A user or attacker performs an action and then denies doing it. Affects: audit logging, non-repudiation mechanisms.

**I — Information Disclosure:** Sensitive data is revealed to an unauthorised party. Affects: encryption, access controls, error handling, logging.

**D — Denial of Service:** Legitimate users are prevented from accessing the system. Affects: rate limiting, resource allocation, availability controls.

**E — Elevation of Privilege:** An attacker gains more permissions than they should have. Affects: authorisation, role management, privilege separation.

Apply STRIDE to every component in your system and every data flow between components. For each threat, document whether it is mitigated, accepted, avoided, or transferred.

---

## How to Use the Templates in This Folder

**STRIDE-template.md** — A blank threat modelling document structured around the STRIDE framework. Fill it in before implementing any new feature or system.

**data-flow-diagram-guide.md** — Instructions and notation for drawing data flow diagrams (DFDs), which are the standard input to a STRIDE analysis.

**security-requirements-checklist.md** — A checklist of security requirements to evaluate during the design phase of any new feature. Covers authentication, authorisation, data handling, logging, and third-party integrations.

**feature-threat-review.md** — A shorter, faster template for reviewing individual features rather than entire systems. Appropriate for sprint-level security review.

---

## Who Should Do Threat Modelling?

Threat modelling is most effective when it includes both the developers who understand the implementation and someone who understands the threat landscape — a security engineer, a security-aware architect, or a developer who has studied common attack patterns.

It does not require a dedicated security team. A development team that has read and understood the OWASP Top 10 can conduct a useful threat model. The discipline of asking "what can go wrong?" systematically — even without perfect answers — produces better security outcomes than shipping and hoping.

---

## Available Templates

| Template | Format | Purpose |
|----------|--------|---------|
| STRIDE threat model | Markdown | Full system threat analysis |
| Data flow diagram guide | Markdown | DFD notation and drawing instructions |
| Security requirements checklist | Markdown | Pre-implementation security review |
| Feature threat review | Markdown | Lightweight per-feature security review |
| Attack tree template | Markdown | Goal-oriented attacker perspective analysis |
