# Password Hashing

**OWASP:** A02 — Cryptographic Failures
**Risk Level:** Critical
**Applies to:** Any application that stores user passwords

---

## The Fundamental Rule

Passwords must never be stored in plain text. They must never be encrypted. They must be hashed using an algorithm specifically designed for password storage.

Hashing is a one-way operation: given a hash, you cannot recover the original password. If an attacker obtains your database, properly hashed passwords give them a computation problem that is designed to be expensive. The difference between a general-purpose hash (MD5, SHA-256) and a password-specific hash (bcrypt, Argon2) is that general-purpose hashes are designed to be fast — attackers can compute billions per second. Password hash functions are designed to be slow and configurable so that as hardware improves, you can increase the cost factor.

---

## Which Algorithm to Use

**Argon2id** is the current best recommendation. Use it for all new systems. It is the winner of the Password Hashing Competition (2015) and is resistant to GPU-based attacks through memory-hardness.

**bcrypt** is mature, battle-tested, and available in every major language. Use it when Argon2 is unavailable or when maintaining an existing system. Do not set a cost factor below 10. Recommended minimum is 12.

**Do not use MD5, SHA-1, SHA-256, or SHA-512 for password hashing.** They are not designed for this purpose. They are too fast.

---

## Cost Factor Guidance

For bcrypt: minimum 10, recommended 12, high-security 14+. For Argon2id: 19 MB memory, 2 iterations, 1 parallelism thread (OWASP minimum). Benchmark on your hardware — hashing should take 100–300ms per operation. If faster, increase the cost.

---

## Available Snippets

| Language | Algorithm | Level | File |
|----------|-----------|-------|------|
| Python | bcrypt | 🟢 Beginner | python-bcrypt-beginner.py |
| Python | Argon2id | 🔴 Advanced | python-argon2-advanced.py |
| Node.js | bcrypt | 🟢 Beginner | node-bcrypt-beginner.js |
| Go | bcrypt | 🟢 Beginner | go-bcrypt-beginner.go |
| Go | Argon2id | 🔴 Advanced | go-argon2-advanced.go |
| Java | bcrypt (Spring) | 🟡 Intermediate | java-spring-intermediate.java |
| PHP | password_hash | 🟢 Beginner | php-beginner.php |
| Ruby | bcrypt | 🟢 Beginner | ruby-beginner.rb |
| Rust | Argon2id | 🔴 Advanced | rust-argon2-advanced.rs |
