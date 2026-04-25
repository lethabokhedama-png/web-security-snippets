# SQL Injection Prevention

**OWASP:** A03 — Injection
**Risk Level:** Critical
**Applies to:** Any application that queries a relational database with user-supplied input

---

## What Is SQL Injection?

SQL injection occurs when user-supplied input is incorporated into a SQL query without proper handling, allowing an attacker to alter the query's logic. The database cannot distinguish between the intended SQL and the injected SQL — it executes whatever it receives.

A vulnerable login query constructed in code:

```
query = "SELECT * FROM users WHERE email = '" + user_email + "' AND password = '" + user_password + "'"
```

An attacker who enters `' OR '1'='1` as their email produces:

```sql
SELECT * FROM users WHERE email = '' OR '1'='1' AND password = '...'
```

Because `'1'='1'` is always true, this query returns all users. The attacker is authenticated as the first user in the table — typically the administrator. More destructive payloads can drop tables, read files from disk, extract the entire database schema and contents, or in some configurations execute operating system commands.

---

## The Defence: Parameterised Queries

A parameterised query separates the SQL command structure from the data values. The query template is sent to the database first and compiled. Data values are passed separately and are never interpreted as SQL syntax. The database driver handles everything — no manual escaping, no sanitisation required for SQL safety.

**Unsafe — string concatenation:**
```python
cursor.execute("SELECT * FROM users WHERE email = '" + email + "'")
```

**Safe — parameterised:**
```python
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

The difference is structural. A malicious input like `'; DROP TABLE users; --` is treated as a literal string value, not as SQL.

---

## ORMs Are Not Automatically Safe

SQLAlchemy, Django ORM, Sequelize, ActiveRecord, and GORM all use parameterised queries for their standard methods. However, every ORM also exposes a raw SQL interface — and raw SQL is just as vulnerable as manual queries. Any time you use `.execute()`, `.raw()`, `query()`, or `literalQuery()` with string concatenation, you are vulnerable. Use parameterisation even for raw queries.

---

## Second-Order Injection

Second-order injection occurs when data is stored safely (no first-order injection) but later retrieved and incorporated into another query without parameterisation. A username stored as `admin'--` is saved safely. A password-change feature that later builds a query using that stored username without parameterisation will fire the injection at that point. Every query must be parameterised regardless of whether its inputs came from the user directly or from the database.

---

## Least Privilege as Defence in Depth

The database account your application connects with should only have the permissions it needs. A read-only reporting service should use a read-only database user. No application account should have permission to DROP tables, GRANT permissions, or access system tables unless that is a documented requirement. This limits the impact of any successful injection.

---

## Available Snippets

| Language | Framework / Driver | Level | File |
|----------|--------------------|-------|------|
| Python | Flask + SQLAlchemy | 🟢 Beginner | python-flask-sqlalchemy-beginner.py |
| Python | Flask + SQLAlchemy | 🔴 Advanced | python-flask-sqlalchemy-advanced.py |
| Python | Django ORM | 🟡 Intermediate | python-django-intermediate.py |
| Python | psycopg2 raw | 🟡 Intermediate | python-psycopg2-intermediate.py |
| Node.js | Express + pg | 🟢 Beginner | node-express-pg-beginner.js |
| Node.js | Express + mysql2 | 🟢 Beginner | node-express-mysql-beginner.js |
| Node.js | Sequelize ORM | 🟡 Intermediate | node-sequelize-intermediate.js |
| Go | Gin + pgx | 🔴 Advanced | go-gin-pgx-advanced.go |
| Java | Spring Boot + JDBC | 🔴 Advanced | java-spring-jdbc-advanced.java |
| PHP | Laravel Eloquent | 🟢 Beginner | php-laravel-beginner.php |
| Ruby | Rails ActiveRecord | 🟢 Beginner | ruby-rails-beginner.rb |
| C# | ASP.NET + Dapper | 🟡 Intermediate | csharp-aspnet-dapper-intermediate.cs |