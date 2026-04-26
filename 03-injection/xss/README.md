# Cross-Site Scripting (XSS) Prevention

**OWASP:** A03 — Injection
**Risk Level:** High
**Applies to:** Any application that renders user-supplied content in a browser

---

## What Is XSS?

Cross-site scripting injects malicious scripts into web pages viewed by other users. The browser trusts content from your domain and executes it. An attacker's script runs with your application's privileges — reading session cookies, making authenticated requests on behalf of victims, exfiltrating data, or silently redirecting users.

---

## Types of XSS

**Reflected XSS:** The payload is in the request and reflected in the response. Delivered via crafted URLs. The server never stores it.

**Stored XSS:** The payload is stored server-side and served to every user who loads the affected page. The most dangerous type — a single injection affects all users indefinitely until removed.

**DOM-based XSS:** The payload never leaves the browser. Client-side JavaScript reads from an attacker-controlled source (URL fragment, `document.referrer`) and writes to a dangerous sink (`innerHTML`, `eval`). Server-side encoding does not prevent this type.

---

## The Primary Defence: Context-Aware Output Encoding

Encode user data before rendering it. Encoding depends on context:

- **HTML context:** Encode `<`, `>`, `&`, `"`, `'`
- **JavaScript context:** Use JSON encoding or a JavaScript string encoder
- **URL context:** URL-encode the value
- **CSS context:** Use CSS hex encoding

Modern templating engines (Jinja2, Django templates, Handlebars, Thymeleaf) auto-encode HTML context. The risk comes from unsafe directives that bypass this: `|safe` in Jinja2, `{{{value}}}` in Handlebars, `v-html` in Vue, `dangerouslySetInnerHTML` in React. Treat every use of these as a finding that requires review.

---

## Available Snippets

| Language | Framework | Level | File |
|----------|-----------|-------|------|
| Python | Flask + Jinja2 | 🟢 Beginner | python-flask-beginner.py |
| Python | Django templates | 🟢 Beginner | python-django-beginner.py |
| Node.js | Express + helmet | 🟢 Beginner | node-express-beginner.js |
| JavaScript | DOMPurify (client-side) | 🟡 Intermediate | javascript-dompurify-intermediate.js |
| Go | html/template | 🟡 Intermediate | go-intermediate.go |
| PHP | Laravel Blade | 🟢 Beginner | php-laravel-beginner.php |
| Java | Spring + Thymeleaf | 🟡 Intermediate | java-spring-intermediate.java |
