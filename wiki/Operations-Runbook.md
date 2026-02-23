# Operations Runbook

## Daily Verification

```bash
./scripts/health-check.sh --summary
```

Use strict mode before major releases:

```bash
./scripts/health-check.sh --strict
```

## Change Workflow

1. Implement change in scripts/configs/docs.
2. Run health checks.
3. Capture state updates in `context/system-state.md` and `context/script-validation.md`.
4. Update wiki pages if operator behavior changed.

## Upgrade Workflow

Use `docs/operations/upgrade-and-rollback.md` as source of truth.

Core rules:

- Upgrade in small waves.
- Validate after each wave.
- Keep rollback path ready before changing core layers.

## Incident Workflow

1. Reproduce with minimal commands.
2. Capture failing output and environment facts.
3. Apply targeted fix.
4. Re-run health check.
5. Record remediation in docs/wiki if it affects future operators.

## Reference Docs

- Health checks: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/docs/operations/health-check.md>
- Troubleshooting: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/docs/operations/troubleshooting.md>
- Upgrade and rollback: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/docs/operations/upgrade-and-rollback.md>
