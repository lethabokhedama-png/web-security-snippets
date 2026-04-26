# Subresource Integrity (SRI)

**OWASP:** A08 — Software and Data Integrity Failures
**Risk Level:** Medium
**Applies to:** Web applications that load scripts or stylesheets from CDNs or third-party hosts

---

## What Is SRI?

Subresource Integrity is a browser security feature that allows you to verify that resources fetched from external sources have not been tampered with. When you load jQuery from a CDN, you are trusting that CDN to serve the legitimate library. If the CDN is compromised, it could serve a modified version that contains malicious code — and your users would execute it in the context of your application.

SRI solves this by including a cryptographic hash of the expected resource in your HTML. The browser fetches the resource, hashes it, and compares the result to the hash you specified. If they do not match, the resource is blocked.

---

## How SRI Works

```html
<script
  src="https://cdn.example.com/library.min.js"
  integrity="sha384-oqVuAfXRKap7fdgcCY5uykM6+R9GqQ8K/ux9E7gHPYh8aBXMvJkzUFe74NWK0Q=="
  crossorigin="anonymous">
</script>
```

The `integrity` attribute contains the hash algorithm (`sha384`) and the base64-encoded hash of the resource. The `crossorigin="anonymous"` attribute is required for SRI to work with cross-origin resources — it instructs the browser to make a CORS request without credentials.

---

## Generating SRI Hashes

**Online:** srihash.org accepts a URL and generates the integrity attribute.

**Command line:**
```bash
# SHA-384 hash of a local file
cat library.min.js | openssl dgst -sha384 -binary | openssl base64 -A

# Or using shasum
shasum -b -a 384 library.min.js | awk '{ print $1 }' | xxd -r -p | base64
```

**npm package (for build tooling integration):**
```bash
npm install --save-dev webpack-subresource-integrity
```

---

## Limitations

SRI only verifies that the file has not changed since you generated the hash. It does not verify that the original file was legitimate before you hashed it. If you generate the hash from an already-compromised file, SRI will faithfully verify the compromised version.

SRI must be regenerated whenever the CDN resource updates. This can be a maintenance burden for frequently updated libraries. Some teams use SRI only for locked versions of libraries (e.g., `jquery-3.7.1.min.js`) rather than floating `latest` references.

---

## Available Snippets

| Type | Level | File |
|------|-------|------|
| HTML — static SRI tags | 🟢 Beginner | html-static-beginner.html |
| Node.js — SRI generation script | 🟡 Intermediate | node-sri-generator-intermediate.js |
| Python — SRI generation helper | 🟡 Intermediate | python-sri-generator-intermediate.py |
| Webpack — SRI plugin integration | 🔴 Advanced | webpack-sri-advanced.js |
| Nginx — SRI header generation | 🔴 Advanced | nginx-sri-advanced.conf |
