# VSA Contract Notes (Research Stage)

## Layer Contract
- `foundation/`: OS/desktop integrations, PTY adapters, font loaders, clipboard, windowing system hooks.
- `core/`: terminal engine state machine, buffers, parser boundaries, key protocols.
- `services/`: orchestration: session lifecycle, mode switching, failover.
- `features/`: pluggable capabilities (render.cpu, render.gpu, settings.ui, ai-shell).
- `app/`: binaries and CLI assembly.

## Dependency Rule
- Dependencies flow inward: `app -> features -> services -> core`.
- `foundation` only appears as adapter implementations behind explicit traits.

## Stability Contract
- Any adapter failure must be contained at its boundary.
- Recovery policy belongs to services, not core.
