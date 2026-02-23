# Troubleshooting

## Fast Recovery Flow

1. Identify the failing layer or command.
2. Fix prerequisites (network, sudo, PATH, permissions).
3. Re-run the specific installer layer.
4. Validate with `./scripts/health-check.sh --summary`.

## Common Failures

### Layer script fails with `command not found`

- Install the missing package/tool.
- Re-run only the failed layer script.

### Config parity mismatch

- Compare local files with repository templates:
  - `configs/wezterm/wezterm.lua`
  - `configs/fish/config.fish`
  - `configs/starship/starship.toml`

### PATH issues for local binaries

- Ensure `~/.local/bin` exists and is exported in shell startup files.

### Release API/network failures

- Confirm outbound HTTPS and certificates.
- Retry layer install after connectivity fix.

## Escalation

When unresolved:

- capture `./scripts/health-check.sh` output
- capture failing command stderr
- include distro and shell profile details
- open issue with reproducible steps

## Canonical Deep Guide

- <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/docs/operations/troubleshooting.md>
