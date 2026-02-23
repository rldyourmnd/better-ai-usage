# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Removed user-specific hardcoded paths from Fish, WezTerm, and Starship config templates so installs work on any Linux user account.
- Switched Layer 1 `yq` install to user-local execution to reduce privileged-write failures on mixed environments.
- Main installer now reuses layer scripts end-to-end instead of maintaining duplicate install logic.
- Added production operations documentation set (`docs/operations/*`) and a full repository health-check script.
- Added live config parity and runtime anomaly validation (`context/system-state.md`, `context/script-validation.md`).
- Added architecture-aware manual install examples in Layer 3/4 docs (`layer-3-github.md`, `layer-4-code-intelligence.md`).
- Added authoritative tool inventory in operations docs (`docs/operations/terminal-tool-catalog.md`).
- Reordered `scripts/install.sh` to match documented installation order (Foundation first, then Layer 1-5).
- Expanded `scripts/health-check.sh` validation to include `tokei` and refreshed context run artifacts.
- Expanded `scripts/health-check.sh` parity/command checks by adding `grepai` and fixed `--summary`/`--strict` exit behavior in non-verbose mode.
- Expanded `scripts/health-check.sh` tool validation with `glow` to align with Layer 2 inventory.
- Updated `README` and `context/*` state snapshots with fresh validation baseline and diagnostics.

### Planned for 1.2.0
- Terminal UI layer (window/chrome-level UI improvements beyond prompt)
- Additional terminal UX polish for open-source default profile

## [1.1.0] - 2026-02-23

### Added
- Cyberpunk prompt UI for `ultra-max` profile (neon cyan/pink palette)
- Full absolute repository path in prompt layout
- Canonical markdownlint configuration for repository-wide docs CI

### Changed
- AI stack prompt labels updated to `CL`, `GEM`, `CX`
- Install scripts now sync configs reliably from any working directory
- Foundation/full installer now applies `ultra-max` profile by default

### Fixed
- WezTerm/Starship icon alignment and fallback rendering behavior
- Markdown CI failures on docs and policy files
- README install and Layer 5 behavior consistency

## [1.0.0] - 2026-02-21

### Added
- **Foundation Layer**: WezTerm terminal with GPU acceleration, Fish shell, Starship prompt
- **Layer 1 - File Operations**: bat, fd, ripgrep, sd, jq, yq, eza
- **Layer 2 - Productivity**: fzf, zoxide, Atuin, uv, bun, watchexec, glow, bottom, hyperfine
- **Layer 3 - GitHub & Git**: gh CLI, lazygit, delta with Catppuccin theme
- **Layer 4 - Code Intelligence**: grepai, ast-grep, probe, semgrep, ctags, tokei
- Complete installation scripts for each layer
- Comprehensive documentation for all tools
- Fish shell configuration with abbreviations and functions
- Starship prompt configuration with minimal, fast theme
- WezTerm configuration with WebGPU/Vulkan support

### Performance
- Shell startup: 915ms → 30ms (30x faster)
- Terminal startup: 300-500ms → 50-80ms (6x faster)
- Input latency: ~50ms → <5ms (10x faster)

### Documentation
- Layer-specific documentation in `docs/layers/`
- Foundation documentation in `docs/foundation/`
- Research data in `context/`
- Contributing guidelines

---

[Unreleased]: https://github.com/rldyourmnd/rld-better-terminal-ai-usage/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/rldyourmnd/rld-better-terminal-ai-usage/releases/tag/v1.1.0
[1.0.0]: https://github.com/rldyourmnd/rld-better-terminal-ai-usage/releases/tag/v1.0.0
