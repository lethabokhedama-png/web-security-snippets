---
name: Bug Report — Snippet Error
about: Report broken code, incorrect output, or a mistake in an existing snippet
title: "[BUG] <category>/<subcategory>/<filename> — <one line description>"
labels: bug
assignees: lethabokhedama-png
---

## Affected File

Provide the exact file path relative to the repository root.

**File path:**
**Language:**
**Language version:**
**Framework:**
**Framework version:**

---

## What Is Wrong

Describe the problem clearly. Choose the most relevant type:

- [ ] The code throws an exception or error when run
- [ ] The code runs but produces incorrect output or behaviour
- [ ] The code has a logic error that does not cause a visible failure
- [ ] The code uses a deprecated function or library that has since been updated
- [ ] The dependency file pins an incorrect or vulnerable version
- [ ] The comments or documentation in the file are inaccurate or misleading
- [ ] The snippet header contains incorrect information

If the problem is a **security vulnerability in a snippet** — meaning the snippet itself introduces a vulnerability — **do not open a public issue**. Follow the private disclosure process in [SECURITY.md](../../SECURITY.md) instead.

---

## Steps to Reproduce

Provide the exact steps needed to observe the problem. Include the install command, any environment setup, and the exact command or code that triggers the issue.

1.
2.
3.

---

## Expected Behaviour

Describe what the snippet should do when working correctly.

---

## Actual Behaviour

Describe what actually happens. If the snippet throws an exception, paste the full error output including the traceback.

```
paste error output here
```

---

## Your Environment

| Item | Value |
|------|-------|
| Operating system | |
| Language version | |
| Framework version | |
| Dependency versions | (paste from your installed packages) |

---

## Suggested Fix

If you know what the correction should be, describe it here or paste the corrected code. This is optional but significantly speeds up resolution.

```python
# paste corrected code here
```

---

## Additional Context

Anything else that would help diagnose or understand the problem. Links to documentation, related issues, or similar bugs in other projects are welcome.
