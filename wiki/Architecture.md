# Architecture

## Design Goals

- Deterministic provisioning
- Script-level separation of concerns
- Fast rollback and targeted remediation
- Predictable terminal UX across machines

## Layer Model

```text
Foundation: terminal + shell + prompt
 -> Layer 1: file operations
 -> Layer 2: productivity
 -> Layer 3: github workflow
 -> Layer 4: code intelligence
 -> Layer 5: AI orchestration
```

## Key Boundaries

- `scripts/` controls installation flow and guardrails.
- `configs/` is the canonical template set for terminal/shell/prompt.
- `docs/` contains deep reference and runbooks.
- `context/` stores state snapshots and research artifacts.

## Runtime Validation Boundary

`./scripts/health-check.sh` validates syntax, parity, tool availability, and drift indicators.

## Operational Contract

- Update scripts and docs together.
- Keep context snapshots current when runtime state changes.
- Keep wiki concise and task-first, with links to canonical deep docs.
