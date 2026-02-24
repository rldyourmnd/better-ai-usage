# v1.0.0 Decision Log

Date: 2026-02-24

## Scope Lock for v1.0.0
- Platform: Ubuntu/Debian + macOS.
- Core-first delivery (single terminal first, expand after stable base).
- Mandatory dual mode rendering: CPU and GPU.
- Priorities fixed: Stability > AI Tool Best Practices > Speed.
- UI theme baseline: cuberpunk style.

## Tech Stack Direction
- Rust workspace with VSA layering.
- PTY: portable-pty (cross-platform foundation).
- Window/input: winit.
- Render: wgpu backend (feature-gated GPU path), deterministic software fallback.
- Font/text: text rasterization in first-party engine with explicit GPU/CPU split.
