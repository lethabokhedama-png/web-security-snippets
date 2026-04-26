# A07 — Identification and Authentication Failures

**OWASP Rank:** 7 of 10
**Risk Level:** Critical
**Previously known as:** Broken Authentication

---

## What Is This Category?

Authentication is the process of verifying that a user is who they claim to be. Identification and authentication failures occur when this process is weak, bypassable, or implemented incorrectly — allowing attackers to compromise passwords, session tokens, or authentication flows to assume other users' identities.

This category is ranked seventh despite being critical because the industry has made meaningful progress with password managers, MFA adoption, and identity provider standardisation. The vulnerabilities that remain are concentrated in custom authentication implementations — teams that build their own login systems rather than using well-tested libraries and identity providers.

---

## Real-World Breaches

**Dropbox (2012):** An employee reused a password from another site that had been breached. Attackers used the credential to access an internal Dropbox tool that listed user email addresses. 68 million user credentials were eventually leaked. The attack chain started with a single reused password.

**Twitter (2020):** Attackers used social engineering to compromise internal admin tools by targeting Twitter employees by phone. The tools allowed account takeover for high-profile accounts including Barack Obama, Elon Musk, and Joe Biden. The attack bypassed technical authentication controls entirely by targeting the humans with access.

**Uber (2022):** An attacker obtained a contractor's VPN credentials through social engineering, then exhausted the contractor with MFA push notifications until they approved one (MFA fatigue attack). From the VPN, they accessed internal systems including Slack, the bug bounty platform, and AWS console.

---

## Common Authentication Failures

**Credential stuffing vulnerability:** Allowing unlimited login attempts with no rate limiting, CAPTCHA, or account lockout enables automated testing of breach databases against your application. Modern credential stuffing tools can test thousands of combinations per minute.

**Weak password policies:** Permitting short passwords, dictionary words, or passwords matching the username. NIST SP 800-63B recommends minimum 8 characters, no composition rules (requiring uppercase/number/symbol), and checking against breach databases.

**Insecure password recovery:** Password reset flows that use predictable tokens, security questions with guessable answers, or tokens that do not expire are a common authentication bypass target.

**Session tokens that do not invalidate on logout:** A user who logs out expects their session to be ended. If the session token remains valid after logout, an attacker who obtains it (through XSS, network interception, or physical access) has persistent access.

**Missing or bypassable MFA:** Applications without MFA rely entirely on a single secret (the password). Applications with MFA that can be bypassed through account recovery or alternative authentication flows provide no real additional protection.

**Insecure token storage:** JWTs or session tokens stored in localStorage are accessible to any JavaScript on the page — including injected scripts. Tokens stored in httpOnly cookies are not accessible to JavaScript.

---

## What This Section Covers

**JWT** — JSON Web Token implementation, validation, algorithm selection, and common pitfalls. Includes both symmetric (HS256) and asymmetric (RS256) implementations.

**Session Management** — Secure session configuration, server-side session storage, session invalidation on logout, and session fixation prevention.

**MFA** — Time-based One-Time Password (TOTP) compatible with authenticator apps, SMS OTP, and email OTP. Includes QR code generation for TOTP setup.

**OAuth2** — Implementing OAuth2 Authorization Code Flow and PKCE for third-party authentication.

**Magic Links** — Passwordless authentication via time-limited, single-use email links.

**Passkeys** — WebAuthn/FIDO2 implementation for phishing-resistant, passwordless authentication.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Issue and validate JWT tokens | jwt/ |
| Implement secure session-based auth | session-management/ |
| Add a second factor to login | mfa/ |
| Integrate Google, GitHub, or any OAuth2 provider | oauth2/ |
| Implement passwordless email login | magic-links/ |
| Implement WebAuthn / passkey login | passkeys/ |
