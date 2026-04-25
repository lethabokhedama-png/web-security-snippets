# A06 — Vulnerable and Outdated Components

**OWASP Rank:** 6 of 10
**Risk Level:** High
**Prevalence:** Nearly universal in applications with any significant dependency tree

---

## What Is This Category?

Every application depends on code written by others — frameworks, libraries, drivers, and runtimes. When a vulnerability is discovered in one of these components, every application using that version is at risk. The attack does not target your code. It targets the library your code relies on, using a publicly documented exploit that may have a working proof-of-concept published the same day the CVE is issued.

The challenge is scale. A modern Node.js application may have hundreds of direct dependencies and thousands of transitive ones. A Python application using a web framework, ORM, task queue, and caching library easily pulls in 200 or more packages. Tracking the security status of all of them manually is not feasible. Automation is not optional.

---

## Real-World Breaches

**Equifax (2017):** Attackers exploited CVE-2017-5638, a known remote code execution vulnerability in Apache Struts 2. A patch had been available for two months before the breach. Equifax had not applied it. The breach exposed the personal and financial data of 147 million people. It resulted in a $575 million settlement with the FTC — the largest in the agency's history at that time.

**Log4Shell (CVE-2021-44228):** A critical remote code execution vulnerability in Log4j 2, a Java logging library used by millions of applications worldwide. It required no authentication, was trivially exploitable, and affected an enormous proportion of the internet's infrastructure. The vulnerability was a perfect illustration of the risk in transitive dependencies — many organisations did not know they were using Log4j because it was a dependency of a dependency of a dependency.

**event-stream (2018):** A malicious actor gained maintainer access to the popular Node.js package `event-stream` and added a dependency that contained obfuscated malicious code targeting a specific Bitcoin wallet application. The package had 1.5 million weekly downloads. This was a supply chain attack — the component itself was compromised, not a vulnerability in it.

---

## What This Section Covers

**Dependency Scanning** — Tools and workflows for identifying known vulnerabilities in your application's dependencies. Covers `npm audit`, `pip-audit`, `go mod verify`, `cargo audit`, Snyk, and Dependabot integration. Includes CI pipeline configurations that fail builds when high-severity vulnerabilities are detected.

**Update Policies** — Configuration for automated dependency update tools (Dependabot, Renovate) that open pull requests when newer versions are available, and guidance for evaluating and applying those updates safely.

---

## The Difference Between Dependency Scanning and SCA

Dependency scanning typically refers to checking your dependency manifest (package-lock.json, requirements.txt, go.sum) against a database of known CVEs. Software Composition Analysis (SCA) goes further — it analyses the actual code of your dependencies, identifies the specific functions and code paths your application uses, and determines whether the vulnerable code paths are actually reachable in your application. SCA reduces false positives significantly but requires more sophisticated tooling. The snippets here cover both levels.

---

## Which Snippet Should You Use?

| I need to... | Go to... |
|---|---|
| Scan my dependencies for known CVEs | dependency-scanning/ |
| Automate dependency updates via PRs | update-policies/ |
| Add vulnerability scanning to my CI pipeline | dependency-scanning/ |