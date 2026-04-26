# NoSQL Injection Prevention

**OWASP:** A03 — Injection
**Risk Level:** High
**Applies to:** Applications using MongoDB, CouchDB, Firebase, or other document/NoSQL databases

---

## What Is NoSQL Injection?

NoSQL injection manipulates the query structure — typically a JSON object — rather than a SQL string. MongoDB queries are JSON documents, and several MongoDB operators become dangerous when an attacker can inject them through user-controlled input.

A vulnerable authentication query:

```javascript
db.users.findOne({ email: req.body.email, password: req.body.password })
```

If the request body is parsed as JSON and the attacker sends:

```json
{ "email": "admin@example.com", "password": { "$ne": null } }
```

The `$ne` operator (not equal to) makes the password check always true. The attacker authenticates without knowing the password.

---

## Dangerous Operators to Block

MongoDB operators that must never appear in user-supplied data unless explicitly validated:

- `$where` — evaluates JavaScript inside the database engine
- `$ne`, `$gt`, `$lt`, `$gte`, `$lte` — comparison operators that bypass equality checks
- `$in`, `$nin` — array membership operators
- `$regex` — can cause ReDoS (Regular Expression Denial of Service)
- `$exists` — field existence check that reveals schema structure

---

## Defences

**Type enforcement:** If you expect a string, verify it is a string before using it. NoSQL injection most commonly works by replacing a scalar value with an operator object. A strict type check blocks most attacks before they reach the query.

**Schema validation:** Use Joi, Zod, Pydantic, or an equivalent to validate the shape and type of all incoming request data at the boundary of your application.

**Avoid `$where`:** The `$where` operator executes JavaScript inside MongoDB. Disable it at the database level if possible and never construct queries that use it with user input.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Node.js | Express + Mongoose | 🟢 Beginner | node-mongoose-beginner.js |
| Node.js | Express + native driver | 🟡 Intermediate | node-native-intermediate.js |
| Python | Flask + PyMongo | 🟡 Intermediate | python-flask-intermediate.py |
| Python | FastAPI + Motor | 🔴 Advanced | python-fastapi-advanced.py |
