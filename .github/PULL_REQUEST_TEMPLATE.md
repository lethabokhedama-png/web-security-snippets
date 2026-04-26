## What This PR Does

<!-- Describe clearly what you are adding, fixing, or improving. One paragraph is enough. -->

---

## Type of Change

<!-- Check all that apply -->

- [ ] New snippet — adding a language or framework not yet covered in an existing category
- [ ] New difficulty level — adding beginner/intermediate/advanced to an existing snippet
- [ ] Bug fix — correcting an error in an existing snippet
- [ ] Security fix — correcting a snippet that introduces a vulnerability (please report via email first — see SECURITY.md)
- [ ] Documentation — improving a README, adding context, fixing incorrect guidance
- [ ] New integration — adding a complete integration guide
- [ ] New category or subcategory — adding a new security pattern area
- [ ] Dependency update — updating a pinned version in a dependency file
- [ ] Repository maintenance — .gitignore, workflows, templates, etc.

---

## Checklist

Before submitting, confirm every item applies to your PR:

### Snippet Requirements
- [ ] File is named following the `{language}-{framework}-{level}.{extension}` convention
- [ ] File begins with the required header block (see CONTRIBUTING.md)
- [ ] Header accurately states what the snippet protects against and what it does not cover
- [ ] OWASP category in the header matches the folder the file lives in
- [ ] All placeholder values are clearly marked with `# REPLACE:` or equivalent comments
- [ ] Code has been tested against the language and framework versions stated in the header

### Comment Standards
- [ ] Beginner files: every non-obvious decision has an inline explanation in plain English
- [ ] Intermediate files: non-obvious choices and configuration values are explained
- [ ] Advanced files: comments are minimal and only present where a non-obvious trade-off exists

### Dependencies
- [ ] The appropriate dependency file (`requirements.txt`, `package.json`, `go.mod`, etc.) exists in this folder
- [ ] All dependency versions are pinned to exact versions (no `>=`, `^`, `~`, or `*`)
- [ ] Dependencies have been verified as non-vulnerable at the pinned version

### Documentation
- [ ] The category README.md's snippet table has been updated to include this snippet
- [ ] OWASP-MAP.md has been updated to reflect this addition

### Testing
- [ ] I have run this code and confirmed it behaves as the header describes
- [ ] I have tested the install step using the dependency file I included

---

## Languages and Versions Tested

| Language | Version | Framework | Framework Version | OS |
|----------|---------|-----------|------------------|----|
| | | | | |

---

## Additional Context

<!-- Anything else reviewers should know. Known limitations, edge cases, decisions you made that could be done differently, related issues. -->

---

## Related Issues

<!-- Link any issues this PR addresses: "Closes #42" or "Relates to #17" -->
