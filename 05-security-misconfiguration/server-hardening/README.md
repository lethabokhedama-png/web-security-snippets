# Server Hardening

**OWASP:** A05 — Security Misconfiguration
**Risk Level:** High
**Applies to:** Web servers (Nginx, Apache, Caddy), application servers, and the operating systems they run on

---

## What Is Server Hardening?

Server hardening is the process of reducing the attack surface of a server by disabling unnecessary features, removing default content, tightening permissions, and enforcing security configuration. A default server installation is configured for broad compatibility, not for security. Hardening is the process of moving from permissive defaults to a secure baseline.

---

## Core Hardening Principles

**Remove what you do not need.** Every installed module, enabled service, open port, and running process is potential attack surface. If it is not required for your application to function, remove or disable it. This applies to Nginx modules, Apache modules, PHP extensions, OS services, and user accounts.

**Change all defaults.** Default usernames, passwords, ports, and configuration settings are documented publicly and are the first thing attackers try. Change the SSH port (or disable password authentication entirely). Change default database credentials. Remove or password-protect default admin interfaces.

**Apply the principle of least privilege.** The application process should run as a dedicated user with no shell, no home directory, and only the permissions needed to read application files and write to log directories. It should not run as root. It should not have write access to its own application files.

**Disable server version disclosure.** Web servers default to advertising their name and version in response headers (`Server: nginx/1.18.0`). This tells attackers which version-specific vulnerabilities to attempt. Suppress or minimise version information.

**Restrict directory listing.** Nginx and Apache can be configured to automatically list directory contents when no index file exists. This reveals file structure and can expose configuration files, backup files, and other sensitive content. Disable it.

**Limit HTTP methods.** If your application only handles GET and POST, reject OPTIONS, PUT, DELETE, TRACE, and CONNECT at the server level. TRACE in particular can be used in cross-site tracing attacks.

---

## Linux OS Hardening Highlights

Beyond the web server itself, the operating system it runs on requires hardening:

- Disable root SSH login (`PermitRootLogin no` in sshd_config)
- Disable SSH password authentication (use key-based auth only)
- Configure a firewall to allow only required ports (typically 80, 443, and a non-standard SSH port)
- Enable automatic security updates for OS packages
- Install and configure fail2ban to block repeated failed authentication attempts
- Disable unused network services
- Configure file permissions to prevent the application user from modifying its own code

---

## Available Guides

| Subject | Format | File |
|---------|--------|------|
| Nginx hardening | Config + commentary | nginx-hardening-guide.conf |
| Apache hardening | Config + commentary | apache-hardening-guide.conf |
| Linux baseline | Shell script + checklist | linux-baseline.sh |
| Docker security | Dockerfile best practices | docker-security-guide.md |
| SSH hardening | sshd_config + commentary | ssh-hardening-guide.conf |
