# Production Health Checks

Run this whenever the environment is provisioned, upgraded, or after changing
install scripts.

Linux uses `scripts/health-check.sh`.
macOS uses `scripts/macos/health-check.sh` (or wrapper `scripts/health-check-macos.sh`).
Windows uses `scripts/windows/health-check.ps1` (or wrapper `scripts/health-check-windows.ps1`).

## Quick Command

```bash
./scripts/health-check.sh
```

Strict CI-style validation:

```bash
./scripts/health-check.sh --strict
```

PowerShell (Windows):

```powershell
.\scripts\health-check-windows.ps1 -Summary
.\scripts\health-check-windows.ps1 -Strict
```

## What the Health Check Validates

- Bash script syntax (`bash -n scripts/*.sh`)
- PowerShell script parse validation (`*.ps1` under `scripts/`)
- Fish config syntax (`fish -n configs/fish/config.fish`)
- Mandatory config files and parity checks:
  - `~/.wezterm.lua` vs `configs/wezterm/wezterm.lua`
  - `~/.config/starship.toml` vs `configs/starship/starship.toml`
- Linux/macOS-only:
  - `~/.config/fish/config.fish` vs `configs/fish/config.fish`
- Required tools installation
- PATH integrity (`$HOME/.local/bin`)
- Known local runtime issues:
  - `semgrep` permission errors (current known issue)
  - `gemini` non-responsive invocation on this machine
- Tool inventory contract drift (terminal+tool catalog updates)
- Installer script health (`git diff`-stable script files and executable bit)

## Recommended Usage

- Run on a clean shell after changes:

```bash
./scripts/health-check.sh --summary
```

- If failures are reported, fix each item and rerun.
- Keep outputs in commit or incident notes for reproducibility.

## Summary Mode Output

`--summary` prints only the counts and a final health status line but still
performs all validation checks internally.

## Escalation

If the check reports multiple failures, prioritize:

1. Permission and environment issues (`PATH`, script syntax, command availability)
2. Config mismatch and tool availability
3. Optional/localized runtime issues (`semgrep`, `gemini`) listed in `troubleshooting.md`
