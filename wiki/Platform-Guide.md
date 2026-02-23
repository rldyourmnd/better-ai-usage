# Platform Guide

This repository is structured by operating systems.

## Linux (Debian/Ubuntu)

- Status: production
- Docs: `docs/platforms/linux/README.md`
- Install: `./scripts/install.sh`
- Health check: `./scripts/health-check.sh --summary`

## macOS

- Status: production
- Docs: `docs/platforms/macos/README.md`
- Install: `./scripts/install.sh` or `./scripts/install-macos.sh`
- Health check: `./scripts/health-check-macos.sh --summary`

## Windows

- Status: production
- Docs: `docs/platforms/windows/README.md`
- Install (PowerShell): `.\scripts\install-windows.ps1`
- Install (Git Bash/MSYS/Cygwin): `./scripts/install.sh` (auto-dispatch)
- Health check (PowerShell): `.\scripts\health-check-windows.ps1 -Summary`
