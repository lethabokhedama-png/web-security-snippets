# Input Validation

**OWASP:** A04 — Insecure Design
**Risk Level:** High
**Applies to:** Any application that accepts data from external sources

---

## What Is Input Validation?

Input validation is the process of verifying that data entering your application conforms to what you expect before using it. It checks the type, format, length, range, and structure of incoming data at the boundary of your application — before that data touches business logic, reaches the database, or gets rendered in a response.

Input validation is a defence-in-depth measure. It is not a substitute for parameterised queries, output encoding, or other primary defences. An attacker who understands your validation rules may be able to craft inputs that pass validation but still cause harm at a later stage. Use validation as a first gate, not a final one.

---

## What to Validate

**Type:** Is this value the type you expect? A user's age should be an integer, not a string or an object. An email address should be a string, not an array.

**Format:** Does this value match the expected format? An email address should match the pattern of an email address. A date should be a valid date in the expected format. A UUID should match the UUID format.

**Length:** Is this value within acceptable bounds? A username should probably be between 3 and 64 characters. A comment might be limited to 5,000 characters. A value that is much longer than expected is either a bug or an attack.

**Range:** For numeric values, is this within the expected range? An item quantity of -500 or 999,999,999 likely indicates a problem.

**Allowlist vs blocklist:** Where possible, validate against an allowlist of acceptable values or patterns rather than a blocklist of known bad values. Blocklists are always incomplete. An allowlist defines exactly what is acceptable and rejects everything else.

**Business logic constraints:** Some validation is domain-specific. A check-in date must be before a check-out date. A discount percentage must be between 0 and 100. A username must not be an existing reserved word.

---

## Where to Validate

**At the boundary:** Validate all external input at the entry point to your application — in middleware, in route handlers before business logic runs, or in a dedicated validation layer. Never assume that data has been validated because it passed through one layer.

**At the model/schema level:** Use schema validation libraries that define expected shapes declaratively. Pydantic for Python, Joi or Zod for Node.js, Bean Validation for Java. These libraries centralise validation rules, make them readable, and generate useful error messages.

**Client-side validation is supplemental:** Validating in the browser provides a better user experience — faster feedback without a round trip. But it provides no security. Any request can be crafted without using your UI. Client-side validation must always be duplicated server-side.

---

## Handling Validation Failures

Return a clear, structured error response that tells the client what was wrong without revealing internal structure. A response that says "email field: must be a valid email address" is helpful. A response that reveals your database schema, stack trace, or internal field names is a security issue.

Log validation failures. A sudden spike in validation failures for a specific endpoint or from a specific IP indicates fuzzing or automated testing of your input boundaries.

Do not attempt to "fix" invalid input by guessing what the user meant. Reject it and return a clear error. Silent normalisation of invalid input hides bugs and can be exploited.

---

## Available Snippets

| Language | Library | Framework | Level | File |
|----------|---------|-----------|-------|------|
| Python | Pydantic v2 | FastAPI | 🟢 Beginner | python-pydantic-fastapi-beginner.py |
| Python | Pydantic v2 | Flask | 🟡 Intermediate | python-pydantic-flask-intermediate.py |
| Python | marshmallow | Flask | 🟡 Intermediate | python-marshmallow-intermediate.py |
| Node.js | Joi | Express | 🟢 Beginner | node-joi-express-beginner.js |
| Node.js | Zod | Express | 🟡 Intermediate | node-zod-express-intermediate.js |
| Node.js | class-validator | NestJS | 🟡 Intermediate | node-nestjs-intermediate.ts |
| Go | go-playground/validator | Gin | 🔴 Advanced | go-gin-validator-advanced.go |
| Java | Bean Validation | Spring Boot | 🟡 Intermediate | java-spring-intermediate.java |
| PHP | Laravel validation | Laravel | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | dry-validation | Rails | 🟡 Intermediate | ruby-rails-intermediate.rb |
| C# | FluentValidation | ASP.NET | 🟡 Intermediate | csharp-fluentvalidation-intermediate.cs |
