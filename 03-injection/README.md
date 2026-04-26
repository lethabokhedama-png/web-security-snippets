# A03 — Injection

**OWASP Rank:** 3 of 10
**Risk Level:** Critical

---

## What Is Injection?

Injection occurs when untrusted data is sent to an interpreter as part of a command or query. The interpreter cannot distinguish between the intended command and the attacker-supplied data, and executes both. The attacker controls what the interpreter does.

Injection is one of the oldest and most well-understood vulnerability classes. It has been in the OWASP Top 10 since its inception. Despite this, it remains prevalent because developers continue to construct queries and commands by concatenating user-supplied strings.

---

## Real-World Breaches

**Heartland Payment Systems (2008):** SQL injection allowed attackers to install malware on the company's systems and steal 130 million credit card numbers. At the time, it was the largest data breach in history.

**Sony Pictures (2011):** A simple SQL injection attack exposed the personal data of over one million users. The attackers later stated the attack took less than an hour.

**TalkTalk (2015):** SQL injection exposed the personal and financial data of 157,000 customers. The attacker was a 17-year-old using a published technique. The company was fined £400,000 by the UK Information Commissioner's Office.

---

## Injection Types Covered in This Section

**SQL Injection** — The most common type. User input is interpolated directly into a SQL query. The attacker can read, modify, or delete data, call stored procedures, and in some configurations execute system commands.

**NoSQL Injection** — MongoDB and similar document databases are vulnerable to injection through different mechanisms than relational databases. The structure of the query (a JSON document) can be manipulated with operator injection.

**Command Injection** — User input is passed to a system shell or subprocess. The attacker can execute arbitrary operating system commands with the permissions of the application process.

**LDAP Injection** — User input is incorporated into an LDAP query without sanitisation. Attackers can bypass authentication, extract directory information, or modify directory entries.

**Cross-Site Scripting (XSS)** — Strictly a form of injection where malicious scripts are injected into web pages viewed by other users. Covered here for completeness; the primary defence is output encoding.

---

## The Universal Defence: Never Construct Queries by String Concatenation

The root cause of all injection vulnerabilities is the same: treating user-supplied data as part of an executable command rather than as data. The universal defence is also the same: use parameterised queries, prepared statements, or structured query APIs that keep data and command structure separate.

For SQL: use parameterised queries or an ORM. For shell commands: avoid calling the shell at all; use APIs that accept argument lists. For LDAP: use parameterised search filters. For HTML output: use a templating engine that escapes output by default.

Input validation and sanitisation are secondary defences. They are useful but they are not sufficient on their own. Blocklists of dangerous characters are always incomplete. Use structured APIs first; sanitise defensively on top.

---

## Which Snippet Should You Use?

| I need to protect against... | Go to... |
|---|---|
| Database query injection | sql-injection/ |
| MongoDB or other NoSQL query injection | nosql-injection/ |
| Shell command injection | command-injection/ |
| LDAP directory query injection | ldap-injection/ |
| Script injection into HTML output | xss/ |
