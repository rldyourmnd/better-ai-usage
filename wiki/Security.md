# Security

## Responsible Disclosure

Follow the project security policy for reporting vulnerabilities:

- <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/SECURITY.md>

## Local Safety Practices

- Never commit secrets or tokens.
- Keep auth material in environment variables or secure stores.
- Run security-relevant tools (`semgrep`, `ast-grep`) as part of validation when changing scripts.

## Hardening Focus Areas

- installer script integrity and strict mode
- dependency source trust and checksum validation
- shell config safety and PATH hygiene
