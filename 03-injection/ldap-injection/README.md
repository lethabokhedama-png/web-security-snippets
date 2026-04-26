# LDAP Injection Prevention

**OWASP:** A03 — Injection
**Risk Level:** High
**Applies to:** Applications that query LDAP or Active Directory for authentication or user lookup

---

## What Is LDAP Injection?

LDAP search filters use a prefix notation with special characters. An application that incorporates user input into an LDAP filter without escaping allows an attacker to alter the filter's logic — bypassing authentication, extracting directory information, or enumerating all users.

A vulnerable authentication filter:

```
(&(uid=<user_input>)(userPassword=<password_input>))
```

Supplying `*)(uid=*))(|(uid=*` as the username manipulates the filter to always return a result. Authentication is bypassed.

---

## Defences

**Escape special characters:** LDAP special characters requiring escaping include `* ( ) \ NUL`. Use your LDAP library's built-in escaping — do not write your own.

**Input validation:** Usernames have predictable character sets (alphanumeric, underscores, dots, hyphens). Reject input containing unexpected characters before it reaches the LDAP layer.

**Least privilege:** The service account binding to LDAP should be read-only and scoped to only the attributes your application needs.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Java | Spring Boot + Spring LDAP | 🔴 Advanced | java-spring-advanced.java |
| Python | python-ldap | 🟡 Intermediate | python-intermediate.py |
| Node.js | ldapts | 🟡 Intermediate | node-intermediate.js |
| C# | ASP.NET + DirectoryServices | 🔴 Advanced | csharp-advanced.cs |
