# In-Terminal Settings UX (Command Palette)

## Requirement
- No external config-only UX.
- Settings must be editable from terminal command surface.

## UX Baseline
- `Ctrl+Shift+P` opens command palette.
- Minimal modal command mode for commands like:
  - `theme set cuberpunk`
  - `mode cpu` / `mode gpu` / `mode auto`
  - `render fps target 120`
  - `shell fish` `shell zsh` `shell auto-init on|off`

## Persistence
- All changes write to a typed config model in app profile with schema versioning.
- Changes are live-applied and reversible via history snapshots.
