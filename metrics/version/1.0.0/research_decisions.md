# v1.0.0 Research Decisions

- Platform priority: Linux (Ubuntu/deb) and macOS.
- Delivery strategy: core first, then expansion.
- UI: in-terminal command palette for settings (modern UI, non-legacy look).
- Rendering: both CPU and GPU modes from first working milestone.
- Initial shell support: `fish + Starship` default auto-init path, with adapter boundary for future custom stack.
- Shell fallback policy v1.0: permissive `zsh` fallback; Bash not a default target on Linux/macOS.
- Terminal compatibility target: baseline ANSI/PTY behavior prioritized for AI CLI stability (colors, cursor ops, clear/redraw, scrollback, paste).
- Stability policy: automatic renderer fallback and bounded recovery cycles on failures.
- Theme: `cuberpunk` baseline style profile for v1.0.0.
