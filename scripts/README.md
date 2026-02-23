# Scripts Layout

This directory is organized by operating system.

## Canonical Implementations

- Linux: `scripts/linux/`
- macOS: `scripts/macos/`
- Windows: `scripts/windows/`

## Dispatchers

- `scripts/install.sh` dispatches by OS.
- `scripts/health-check.sh` dispatches by OS.
- `scripts/install-macos.sh` and `scripts/health-check-macos.sh` are macOS wrappers.
- `scripts/install-windows.ps1` and `scripts/health-check-windows.ps1` are Windows wrappers.

## Shared Helpers

- `scripts/shared/starship/switch-profile.sh`
- `scripts/publish-wiki.sh`
