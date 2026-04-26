# Role-Based Access Control (RBAC)

**OWASP:** A01 — Broken Access Control
**Risk Level:** Critical
**Applies to:** Any application where different users have different permissions

---

## What Is RBAC?

Role-Based Access Control is a method of restricting system access based on the roles assigned to individual users. Instead of granting permissions directly to users, permissions are granted to roles, and roles are assigned to users. A user who has the role `moderator` inherits all permissions that the `moderator` role holds.

This model makes permission management tractable at scale. When you need to change what moderators can do, you update the role definition once. Without RBAC, you would need to update every individual user record.

RBAC has three core components:

- **Users** — the authenticated identities in your system
- **Roles** — named collections of permissions (admin, editor, viewer, moderator)
- **Permissions** — specific actions that can be performed (read:posts, write:posts, delete:users)

A user can hold multiple roles. A role can hold multiple permissions. The access decision for any given action is: does this user hold a role that includes this permission?

---

## When to Use RBAC

RBAC is the right model when:
- Your application has a defined, relatively stable set of user types
- The rules for what each type can do are consistent regardless of context
- You need to manage permissions for tens to thousands of users

RBAC becomes unwieldy when access decisions depend heavily on context — for example, whether the resource belongs to the requesting user, or what time of day it is. In those cases, look at Attribute-Based Access Control (ABAC) in the adjacent folder.

---

## How the Snippets in This Folder Work

All RBAC snippets in this folder follow the same logical structure regardless of language or framework:

1. The user authenticates and receives a token or session that includes their role(s)
2. Protected routes are decorated or wrapped with a middleware that checks the required role
3. The middleware extracts the user's role from the token or session
4. If the role satisfies the requirement, the request proceeds. If not, a 403 Forbidden response is returned immediately
5. The application never relies on the client to report the user's role — the server always derives it from a trusted source (the token or session)

---

## Role Hierarchy

Many real applications need a role hierarchy where higher roles inherit the permissions of lower ones. For example:

```
viewer   → can read content
editor   → can read and write content (inherits viewer)
admin    → can read, write, and delete content (inherits editor)
```

The snippets in this folder show both flat role checking (does the user have this exact role?) and hierarchical role checking (does the user have this role or any role above it?).

---

## Common Mistakes in RBAC Implementations

**Checking role on the front end only.** A React app that hides an admin button is not access control. The API endpoint behind that button must enforce the role check independently.

**Storing roles in a client-modifiable location.** If a JWT's role claim is set and never verified against a server-side source, an attacker who can modify their token claims can grant themselves any role. Either sign and verify tokens properly, or store the authoritative role in the session server-side.

**Missing role checks on related endpoints.** If you protect `DELETE /users/:id` with an admin check but forget to protect `PATCH /users/:id/role`, an attacker can elevate their own role through the unprotected endpoint.

**Conflating authentication with authorisation.** Checking that a user is logged in (authenticated) is not the same as checking that they are allowed to perform this action (authorised). Every protected action needs both checks.

**Not logging authorisation failures.** A series of 403 responses for the same user is a signal worth monitoring. Without logging, you cannot detect privilege escalation attempts.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Python | Flask | 🟢 Beginner | python-flask-beginner.py |
| Python | Flask | 🔴 Advanced | python-flask-advanced.py |
| Python | Django | 🟡 Intermediate | python-django-intermediate.py |
| Node.js | Express | 🟢 Beginner | node-express-beginner.js |
| Node.js | Express | 🔴 Advanced | node-express-advanced.js |
| Node.js | NestJS | 🟡 Intermediate | node-nestjs-intermediate.ts |
| Go | Gin | 🔴 Advanced | go-gin-advanced.go |
| Java | Spring Boot | 🔴 Advanced | java-spring-advanced.java |
| PHP | Laravel | 🟡 Intermediate | php-laravel-intermediate.php |
| Ruby | Rails | 🟡 Intermediate | ruby-rails-intermediate.rb |

---

## Dependencies

See the dependency file for your language in this folder. All versions are pinned.

Install before running any snippet:

- **Python:** `pip install -r requirements.txt`
- **Node.js:** `npm install`
- **Go:** `go mod tidy`
- **Java:** `mvn install` or `gradle build`
- **PHP:** `composer install`
- **Ruby:** `bundle install`
