# OAuth2 and OpenID Connect

**OWASP:** A07 — Identification and Authentication Failures
**Risk Level:** High
**Applies to:** Applications integrating third-party identity providers (Google, GitHub, Microsoft, Auth0, etc.)

---

## What Is OAuth2?

OAuth2 is an authorisation framework that allows a user to grant a third-party application limited access to their account on another service, without sharing their password. It is the protocol behind "Sign in with Google," "Continue with GitHub," and similar social login buttons.

OpenID Connect (OIDC) is an identity layer built on top of OAuth2. Where OAuth2 answers "is this user allowed to access this resource?", OIDC answers "who is this user?" For authentication purposes, you almost always want OIDC, which extends the OAuth2 flow to include an ID token containing verified user information.

---

## The Authorization Code Flow

The most secure OAuth2 flow for web applications:

1. Your application redirects the user to the identity provider's authorisation endpoint, including your client ID, requested scopes, and a randomly generated `state` parameter
2. The user authenticates with the identity provider and grants permission
3. The identity provider redirects back to your application's callback URL with an authorisation code and the `state` parameter
4. Your application verifies the `state` matches what you generated (CSRF protection), then exchanges the code for tokens by making a server-side POST request to the provider's token endpoint
5. The token response includes an access token, a refresh token, and (with OIDC) an ID token containing verified user claims

---

## PKCE — Proof Key for Code Exchange

PKCE (pronounced "pixie") is an extension to the Authorization Code Flow that protects against authorisation code interception attacks. It is required for public clients (single-page applications, mobile apps) that cannot store a client secret, and recommended for all OAuth2 implementations.

PKCE works by having the client generate a random `code_verifier`, hash it to produce a `code_challenge`, send the challenge with the authorisation request, and send the verifier with the token exchange. The server verifies that the verifier matches the challenge it received earlier. An attacker who intercepts the authorisation code cannot exchange it without the verifier.

---

## Critical Security Checks

**Validate the `state` parameter.** The `state` is your CSRF protection. If the state returned in the callback does not match what you stored before the redirect, the request has been tampered with. Reject it.

**Validate the `id_token` signature.** The ID token is a JWT signed by the identity provider. Verify the signature against the provider's published public keys. Never trust claims from an ID token you have not verified.

**Validate `iss`, `aud`, and `exp` claims.** The issuer must match your identity provider. The audience must match your client ID. The token must not be expired.

**Do not use the Implicit Flow.** The Implicit Flow (which returns tokens directly in the redirect URL) has been deprecated in OAuth 2.1. Tokens in URLs end up in server logs, referrer headers, and browser history. Always use the Authorization Code Flow.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express | 🟡 Intermediate | node-express-intermediate.js |
| Node.js | Next.js | 🟡 Intermediate | node-nextjs-intermediate.js |
| Python | Flask | 🟡 Intermediate | python-flask-intermediate.py |
| Python | FastAPI | 🟡 Intermediate | python-fastapi-intermediate.py |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| Java | Spring Boot | 🔴 Advanced | java-spring-advanced.java |
| PHP | Laravel + Socialite | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails + OmniAuth | 🟢 Beginner | ruby-rails-beginner.rb |
| JavaScript | SPA + PKCE | 🔴 Advanced | javascript-pkce-spa-advanced.js |
