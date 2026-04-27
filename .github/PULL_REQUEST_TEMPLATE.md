## Summary

Describe what this pull request adds, changes, or fixes in one clear paragraph. Do not use bullet points here — write a proper description that gives reviewers context before they look at the code.

---

## Type of Change

Select all that apply and delete the rest.

- [ ] **New snippet** — adding a language or framework not yet covered in an existing category
- [ ] **New difficulty level** — adding beginner, intermediate, or advanced for an existing snippet
- [ ] **Bug fix** — correcting broken or incorrect code in an existing snippet
- [ ] **Security fix** — correcting a snippet that introduces a vulnerability *(should have been reported privately first — see SECURITY.md)*
- [ ] **Dependency update** — updating a pinned version in a dependency file
- [ ] **Documentation** — improving a README.md, fixing incorrect guidance, adding context
- [ ] **New integration** — adding a complete integration guide under integrations/
- [ ] **New category** — adding a new security pattern area *(coordinate in an issue first)*
- [ ] **Repository maintenance** — .gitignore, workflows, templates, configuration

---

## Snippet Header

Every new code file must begin with the required header. Paste it here so reviewers can check it without opening the file.

```
# Feature        :
# Language       :
# Framework      :
# Level          :
# OWASP          :
# Protects       :
# Does NOT cover :
# Dependencies   :
# Tested on      :
# Last reviewed  :
```

If this PR does not add a code file, delete this section.

---

## Testing

Describe exactly how you tested this. Reviewers need to be able to reproduce your test.

**Steps:**
1.
2.
3.

**Result:** Describe what happened and why it confirms the snippet is correct.

---

## Versions Tested

| Language | Version | Framework | Framework Version | OS |
|----------|---------|-----------|------------------|----|
| | | | | |

---

## Checklist

Complete every item before marking the PR ready for review. PRs with unchecked items will not be reviewed until they are resolved.

### Code quality
- [ ] The file is named following `{language}-{framework}-{level}.{extension}` exactly
- [ ] The file begins with the required header block and all fields are filled in correctly
- [ ] The OWASP category in the header matches the folder the file lives in
- [ ] All placeholder values are clearly marked with `# REPLACE:` or `// REPLACE:` comments
- [ ] I have run this code and confirmed it works as described in the header

### Comment standards
- [ ] **Beginner files:** Every non-obvious decision has a plain-English explanation. The WHY is explained, not just the WHAT. Every REPLACE marker is present.
- [ ] **Intermediate files:** Non-obvious choices and any values requiring configuration are explained.
- [ ] **Advanced files:** Comments are minimal — only present where a non-obvious trade-off or security implication exists.
- [ ] *(Delete the levels that do not apply to this PR)*

### Dependencies
- [ ] The dependency file for this language exists in this folder
- [ ] All dependency versions are pinned to exact versions — no `^`, `~`, `>=`, or `*`
- [ ] I have verified that the pinned versions do not have known CVEs at the time of submission
- [ ] The dependency file includes a comment explaining what to run to install

### Documentation
- [ ] The category `README.md` snippet table has been updated to include this snippet
- [ ] `OWASP-MAP.md` has been updated to reflect this addition (status changed from Needed to Available or In Progress)
- [ ] If this is a new subcategory, a `README.md` has been written for it

### For integrations/
- [ ] The integration includes a before-and-after example showing where the code goes
- [ ] The integration `README.md` lists prerequisites and step-by-step integration instructions
- [ ] The integration has been tested against a real (not mocked) application structure

---

## Related Issues

Link any issues this PR addresses. Use the format `Closes #123` or `Relates to #456`.

---

## Notes for Reviewers

Anything reviewers should pay particular attention to. Known limitations, edge cases you considered and rejected, alternative approaches you evaluated, or specific lines you are uncertain about.
