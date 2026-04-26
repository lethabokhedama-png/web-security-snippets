# Signed Git Commits

**OWASP:** A08 — Software and Data Integrity Failures
**Risk Level:** Medium
**Applies to:** Development teams that want to verify code authorship and detect tampering

---

## Why Sign Git Commits?

Git does not verify identity by default. Any user can set `user.name` and `user.email` to anything they like. A commit that claims to be from `Linus Torvalds <torvalds@linux-foundation.org>` may have been made by anyone. In a repository without commit signing, there is no cryptographic proof that a commit was made by the stated author.

Commit signing attaches a GPG or SSH signature to each commit. Anyone with the author's public key can verify that the commit was made by the holder of the corresponding private key and that the commit contents have not been changed since signing.

---

## Signing Methods

**GPG (GNU Privacy Guard):** The traditional and most widely supported method. Requires generating a GPG key pair, uploading the public key to GitHub/GitLab, and configuring Git to use the private key for signing.

**SSH keys:** GitHub and GitLab support SSH commit signing as an alternative to GPG. If you already use SSH for repository access, the same key pair can be used for signing without additional tooling.

**S/MIME:** Less common in open-source contexts, more common in enterprise environments with existing PKI infrastructure.

---

## Setting Up GPG Commit Signing

```bash
# Generate a GPG key
gpg --full-generate-key
# Select RSA and RSA, 4096 bits, no expiry (or set one), enter name and email

# List your keys and find the key ID
gpg --list-secret-keys --keyid-format=long

# Configure Git to use your key for signing
git config --global user.signingkey YOUR_KEY_ID
git config --global commit.gpgsign true

# Export your public key and add it to GitHub
gpg --armor --export YOUR_KEY_ID
```

---

## Enforcing Signed Commits on a Repository

GitHub, GitLab, and Bitbucket support branch protection rules that require signed commits. Enabling this on your main branch means that only commits with a verified signature can be merged, regardless of how they were created.

This does not require every developer to sign every commit during development. It requires that commits entering the protected branch are signed — which can be enforced at merge time.

---

## Available Guides

| Topic | File |
|-------|------|
| GPG setup for commit signing | gpg-setup-guide.md |
| SSH key signing setup | ssh-signing-guide.md |
| GitHub branch protection for signed commits | github-branch-protection-guide.md |
| GitLab push rules for signed commits | gitlab-push-rules-guide.md |
| Verifying signed commits in CI | ci-verification-guide.md |
