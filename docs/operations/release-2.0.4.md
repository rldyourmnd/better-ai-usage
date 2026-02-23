# Release 2.0.4

Release date: 2026-02-24

## Highlights

- Stabilized WezTerm runtime model for Linux multi-monitor scenarios:
  - session-aware Wayland/X11 selection (`XDG_SESSION_TYPE` + `WAYLAND_DISPLAY`),
  - explicit overrides for deterministic triage:
    - `WEZTERM_FORCE_WAYLAND=1`
    - `WEZTERM_FORCE_X11=1`
    - `WEZTERM_RENDERER=opengl|software|webgpu`
    - `WEZTERM_SAFE_RENDERER=1`
    - `WEZTERM_MINIMAL_UI=1`
- Lowered callback pressure in WezTerm status rendering:
  - tuned `status_update_interval`,
  - cached battery polling in `update-status`.
- Added health-check runtime log diagnostics to detect freeze signatures early.

## Incident Context

This release addresses a production incident where terminal windows froze during
screen-to-screen move + resize operations. Runtime logs showed compositor-path
signals in `gnome-shell` (`size change accounting`, `frame counter`, actor
allocation warnings), while kernel logs did not indicate GPU crash/OOM.

## Validation Scope

- Verified runtime checks against real `journalctl --user -b` signatures.
- Verified updated Linux health-check script behavior.
- Verified repository/documentation sync for new runtime controls.

## Source Notes (Context7 + Primary Docs)

- WezTerm `enable_wayland` behavior and defaults
- WezTerm `front_end` options (`OpenGL`, `Software`, `WebGpu`)
- WezTerm `update-status` event behavior and pacing via `status_update_interval`
- WezTerm issue tracker references for resize/freeze and backend sensitivity

## Platform Notes

- Linux validation was performed directly.
- macOS and Windows were not run through the full runtime incident path in this release cycle.

If you encounter platform-specific issues, open an issue:

- [GitHub Issues](https://github.com/rldyourmnd/awesome-terminal-for-ai/issues)
