# Installation and Layers

## Architecture Order

The stack is installed in deterministic order:

1. Foundation: WezTerm + Fish + Starship
2. Layer 1: File operations tooling
3. Layer 2: Productivity tooling
4. Layer 3: GitHub and Git workflow tooling
5. Layer 4: Code intelligence and analysis tooling
6. Layer 5: AI orchestration CLIs

## Installer Entrypoints

- Full path: `scripts/install.sh`
- Per-layer path: `scripts/install-foundation.sh`, `scripts/install-layer-{1..5}.sh`

## Layer Ownership

| Layer | Script | Primary Outcome |
| --- | --- | --- |
| Foundation | `install-foundation.sh` | Terminal and shell baseline |
| Layer 1 | `install-layer-1.sh` | Fast file/search/transform tooling |
| Layer 2 | `install-layer-2.sh` | Navigation, runtime, benchmarking, UX tools |
| Layer 3 | `install-layer-3.sh` | GitHub and Git terminal workflow |
| Layer 4 | `install-layer-4.sh` | Semantic search and code analysis |
| Layer 5 | `install-layer-5.sh` | AI coding CLIs |

## Idempotency and Reruns

- Scripts are designed for re-runs.
- If one layer fails, fix the root cause and rerun only that layer.
- Always run `scripts/health-check.sh --summary` after each fix.

## References

- Layer docs: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/tree/main/docs/layers>
- Foundation docs: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/docs/foundation/foundation.md>
