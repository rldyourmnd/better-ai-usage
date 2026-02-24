# Vision Priorities (Core Quality Contract)

## 2026-02-24 Priority Order

1. `СТАБИЛЬНОСТЬ`
- No session drops in both CPU and GPU modes.
- Deterministic core state machine with explicit error boundaries.
- GPU crash must auto-fallback to CPU without terminating the shell session.

2. `BEST PRACTICES FOR AI TOOLS`
- Command-line ergonomics tuned for: CodeX, OpenCode, Claude Code, Gemini CLI.
- Fast shell round-trip, low-latency copy/paste, predictable command completion behavior.
- Minimal startup friction for terminal automation workflows.

3. `СКОРОСТЬ`
- Baseline responsiveness over raw feature count.
- Two render modes:
  - `--render-mode cpu`
  - `--render-mode gpu`
  - `--render-mode auto` (GPU if healthy, fallback CPU on failure)
- Explicit RAM/perf budget discipline and frame pacing strategy.

## Non-Goals (v1)
- No full multiplexer on v1 (single-terminal baseline first).
- No external config-file-only UX; settings are first-class in-terminal controls.

## Feature Baseline
- OS: Linux (Ubuntu/deb) and macOS.
- Shell compatibility: fish/Starship by default with opt-in auto-init.
- UI target: modern visual language, cube-like/cuberpunk theme baseline.
