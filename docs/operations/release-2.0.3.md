# Release 2.0.3

Release date: 2026-02-23

## Highlights

- Added Linux recovery utility for NVML runtime failures:
  - `scripts/linux/fix-nvidia-nvml.sh`
- Updated troubleshooting and health-check documentation based on real production incidents:
  - WezTerm `update-status` runtime error storm remediation
  - NVML / `nvidia-smi` recovery via `nvidia-persistenced`
  - Semgrep permission behavior in restricted execution environments

## Validation Scope

System-first validation was completed before repository release work:

- `nvidia-smi` operational (NVML restored)
- `nvidia-persistenced` active and registered with `multi-user.target`
- terminal logs clean after WezTerm callback fix
- no terminal-related OOM events in the latest 24h audit

This release was fully validated on:

- Ubuntu 25.10
- Ubuntu 24.04 LTS

## Platform Notes

- macOS was not tested in this release cycle.
- Windows was not tested in this release cycle.

If you encounter platform-specific issues, please open an issue:

- [GitHub Issues](https://github.com/rldyourmnd/awesome-terminal-for-ai/issues)

I will prioritize fixes based on incoming reports.
