# Getting Started

## Prerequisites

- Ubuntu/Debian system with `sudo` access
- `git` and `curl` installed
- Internet access for package and release downloads

## Recommended Install Path

```bash
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
./scripts/install.sh
exec fish
```

## Layered Install Path

Use this when you need checkpoints between layers.

```bash
./scripts/install-foundation.sh
./scripts/install-layer-1.sh
./scripts/install-layer-2.sh
./scripts/install-layer-3.sh
./scripts/install-layer-4.sh
./scripts/install-layer-5.sh
```

## Initial Verification

```bash
./scripts/health-check.sh --summary
```

Expected result: PASS status with no failures.

## Next Steps

- Review [Installation and Layers](Installation-and-Layers) for component details.
- Use [Operations Runbook](Operations-Runbook) for daily validation and change control.
- Use [Troubleshooting](Troubleshooting) when checks fail.
