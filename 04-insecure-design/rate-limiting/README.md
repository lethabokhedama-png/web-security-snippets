# Rate Limiting

**OWASP:** A04 — Insecure Design
**Risk Level:** High
**Applies to:** Login endpoints, password reset flows, OTP verification, API endpoints, any resource-intensive operation

---

## What Is Rate Limiting and Why Is It a Design Concern?

Rate limiting controls how many requests a client can make to an endpoint within a defined time window. Without it, an attacker can attempt unlimited login combinations (brute force), test thousands of OTP codes in seconds (OTP brute force), enumerate valid usernames through response timing, or exhaust computational resources through repeated expensive operations.

Rate limiting is described as a design concern because it must be considered when the endpoint is designed, not added as an afterthought. An endpoint that accepts 10,000 requests per second and was never designed to handle rate limit state has fundamentally different behaviour after rate limiting is added — and that change may expose other issues.

---

## Types of Rate Limiting

**Fixed window:** Count requests in a fixed time window (e.g., 5 requests per minute). Simple to implement but vulnerable to burst attacks at window boundaries — an attacker can make 5 requests at 11:59:59 and 5 more at 12:00:00, effectively making 10 requests in two seconds.

**Sliding window:** Count requests in a rolling window relative to each request's timestamp. More accurate than fixed window. Requires either a sorted set data structure or an approximation algorithm.

**Token bucket:** A bucket fills with tokens at a constant rate. Each request consumes a token. Requests are rejected when the bucket is empty. Allows bursts up to the bucket size while enforcing an average rate. Used by most API gateways.

**Leaky bucket:** Requests queue and are processed at a constant rate. Acts as a smoothing function — no bursts reach the downstream service. Useful for protecting expensive backend operations.

---

## In-Process vs Distributed Rate Limiting

**In-process rate limiting** stores state in application memory. It is simple, has zero latency overhead, and requires no additional infrastructure. It fails when you run more than one application instance — each instance has its own counter, so the effective rate limit is multiplied by the number of instances. Use in-process rate limiting only for single-instance applications or during development.

**Distributed rate limiting** stores state in a shared data store, typically Redis. Every application instance reads and writes to the same counters. This is the correct approach for production applications running multiple instances. The trade-off is that every rate-limited request makes a network call to Redis — typically 1–2ms, which is acceptable for most applications.

---

## What to Rate Limit On

**IP address:** The most common dimension. Effective against attacks from a single source. Ineffective against distributed attacks from botnets. Can incorrectly block legitimate users behind shared NAT (corporate networks, university networks) where many users share one IP.

**User account:** Rate limit login attempts per user account regardless of source IP. This prevents distributed credential stuffing that rotates IPs. Requires knowing the account being targeted, which is usually available from the request parameters.

**IP + user account combined:** The most effective approach for login endpoints. Rate limit both dimensions independently. A distributed attack that rotates IPs still hits the per-account limit. A single IP attacking many accounts still hits the per-IP limit.

**API key:** For authenticated APIs, rate limit on the API key or authenticated user ID rather than IP. This ties the rate limit to the identity that agreed to usage terms, not to a network address that may be shared.

---

## Responding to Rate Limit Violations

Always return HTTP 429 (Too Many Requests) with a `Retry-After` header indicating when the client may try again. Do not return 401 or 403 — these imply authentication or authorisation failure, not rate limiting.

For login endpoints specifically, consider whether to reveal that rate limiting is active. Telling an attacker "you have been rate limited" confirms that their credential stuffing tool is working. Some security teams prefer a deliberate delay response over an explicit 429 for login endpoints.

Log every rate limit event. A burst of 429 responses for the same account or IP is a signal that warrants investigation. Without logging, you cannot detect ongoing attacks.

---

## Available Snippets

| Language | Framework | Backend | Level | File |
|----------|-----------|---------|-------|------|
| Python | Flask | In-memory | 🟢 Beginner | python-flask-memory-beginner.py |
| Python | Flask | Redis | 🟡 Intermediate | python-flask-redis-intermediate.py |
| Python | FastAPI | Redis | 🔴 Advanced | python-fastapi-redis-advanced.py |
| Node.js | Express | In-memory | 🟢 Beginner | node-express-memory-beginner.js |
| Node.js | Express | Redis | 🟡 Intermediate | node-express-redis-intermediate.js |
| Node.js | Fastify | Redis | 🔴 Advanced | node-fastify-redis-advanced.js |
| Go | Gin | Redis | 🔴 Advanced | go-gin-redis-advanced.go |
| Go | Gin | In-memory | 🟡 Intermediate | go-gin-memory-intermediate.go |
| Java | Spring Boot | Redis | 🔴 Advanced | java-spring-redis-advanced.java |
| PHP | Laravel | Redis | 🟡 Intermediate | php-laravel-redis-intermediate.php |
| Ruby | Rails | Redis | 🟡 Intermediate | ruby-rails-redis-intermediate.rb |