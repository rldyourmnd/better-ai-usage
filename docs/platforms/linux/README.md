# Linux (Debian/Ubuntu)

This is the production implementation for Linux hosts.

## Scope

- Distributions: Debian/Ubuntu (APT-based)
- Shell: Fish
- Terminal: WezTerm
- Prompt: Starship
- Layers: Foundation + Layer 1..5

## Entrypoints

- Full install: `./scripts/install.sh`
- Health check: `./scripts/health-check.sh --summary`

## Layer Scripts

- `scripts/install-foundation.sh`
- `scripts/install-layer-1.sh`
- `scripts/install-layer-2.sh`
- `scripts/install-layer-3.sh`
- `scripts/install-layer-4.sh`
- `scripts/install-layer-5.sh`

## Canonical Linux Docs

- Foundation: `docs/foundation/foundation.md`
- Layers: `docs/layers/`
- Operations: `docs/operations/`
- Tool catalog (Linux): `docs/operations/terminal-tool-catalog.md`

## Notes

`./scripts/install.sh` now auto-detects OS. On Linux it runs the existing Linux pipeline.
