# Security Policy

## Reporting a vulnerability

Please report suspected vulnerabilities through this repository's
[private vulnerability reporting form](https://github.com/loganw/sure/security/advisories/new).
Do not open a public issue for an unpatched vulnerability.

Use synthetic data in reports and reproductions. Do not include financial
records, account identifiers, access tokens, credentials, database exports,
logs, backups, or other personal information.

If private reporting is unavailable, contact the repository owner without
including exploit details or sensitive data and ask for a private channel.

## Secrets and runtime data

Runtime configuration belongs in ignored `.env` files or a secret manager.
Never commit API tokens, `SECRET_KEY_BASE`, `config/master.key`, unencrypted
credentials, uploaded files, production logs, database exports, or backups.
Any secret committed to Git must be considered compromised and rotated; merely
deleting it in a later commit is not sufficient.

## Dependency and upstream maintenance

Dependabot and GitHub secret scanning should remain enabled. Review dependency
alerts promptly, and regularly synchronize this fork with `we-promise/sure` so
upstream security fixes are not missed.
