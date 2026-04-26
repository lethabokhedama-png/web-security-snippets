# A01 — Broken Access Control

**OWASP Rank:** 1 of 10
**Prevalence:** Found in 94% of applications tested
**Risk Level:** Critical

---

## What Is Broken Access Control?

Access control enforces a policy that prevents users from acting outside their intended permissions. Broken access control occurs when those restrictions are improperly implemented, allowing attackers to access functionality or data they should not be able to reach.

This is not a subtle category. It includes attackers reading other users' account data by changing a URL parameter, elevating their own account to administrator, accessing the admin panel without authentication, replaying or tampering with a JWT to gain additional roles, and making API calls the front end does not expose but the back end does not protect.

The reason it is ranked first is that it is both common and consistently impactful. Unlike some vulnerability classes that require specific conditions to exploit, broken access control failures often require nothing more than changing a number in a URL or removing a header.

---

## Real-World Breaches Caused by Broken Access Control

**Optus (2022):** A public-facing API that did not require authentication exposed the personal data of 9.8 million current and former customers including passport and driver's licence numbers. The endpoint was accessible to anyone who found it.

**Parler (2021):** An API that allowed sequential enumeration of post IDs without authentication allowed researchers to archive all public posts, including deleted ones, before the platform went offline. The lack of rate limiting and access controls made bulk data extraction trivial.

**Facebook (2018 — Cambridge Analytica):** Third-party applications were permitted to access the friend networks of any user who installed them, without those friends having consented. This was a design-level access control failure that exposed up to 87 million profiles.

**Instagram (2019):** A vulnerability in the password reset flow allowed an attacker to bypass rate limiting and brute-force reset codes for any account, including high-profile verified accounts.

---

## What This Category Covers

This section of the library contains implementations for three primary access control patterns:

**Role-Based Access Control (RBAC)** assigns permissions to roles and assigns roles to users. A user with the role `editor` can do what editors are allowed to do. A user with the role `admin` can do more. This is the most common access control model and the right choice for most applications.

**Attribute-Based Access Control (ABAC)** evaluates access based on attributes of the user, the resource, and the environment. It is more expressive than RBAC but also more complex. It is appropriate when access decisions depend on context — for example, allowing a user to edit a document only if they are the author and it was created within the last 30 days and the current time is within business hours.

**API Key Validation** covers the pattern of issuing, storing, and validating API keys for machine-to-machine access. It includes key hashing (so compromised storage does not expose keys), key scoping (so a key can only access what it needs to), and key rotation patterns.

---

## Common Mistakes This Section Helps You Avoid

**Relying on the front end to hide functionality.** If the back end does not check whether a user is authorised to perform an action, hiding a button in the UI provides no protection. An attacker does not use your UI.

**Insecure direct object references.** Using sequential IDs like `/invoice/1042` without checking whether the authenticated user owns that invoice allows any user to access any other user's invoices by incrementing the number.

**Missing function-level authorisation.** Administrative functions that check authentication (is the user logged in?) but not authorisation (is the user allowed to do this?) are a common failure. Checking for a valid session token is not the same as checking for the admin role.

**JWT trust without verification.** Accepting a JWT and reading its claims without verifying the signature, or using `none` as an accepted algorithm, allows an attacker to forge any identity.

**Hardcoded role checks scattered through the codebase.** Access control logic that lives in every route handler instead of in a centralised middleware or policy engine is hard to audit and easy to miss during code review.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Restrict routes by user role | rbac/ |
| Build fine-grained, context-aware access rules | abac/ |
| Authenticate machine-to-machine API requests | api-key-validation/ |

Each subfolder contains a README.md that explains the pattern in depth, lists the snippets available, and tells you which dependencies to install.

---

## Further Reading

- OWASP — Access Control Cheat Sheet: https://cheatsheetseries.owasp.org/cheatsheets/Access_Control_Cheat_Sheet.html
- OWASP — Insecure Direct Object Reference Prevention: https://cheatsheetseries.owasp.org/cheatsheets/Insecure_Direct_Object_Reference_Prevention_Cheat_Sheet.html
- NIST — Guide to Attribute Based Access Control: https://nvlpubs.nist.gov/nistpubs/specialpublications/NIST.SP.800-162.pdf
