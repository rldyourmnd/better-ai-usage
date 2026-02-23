# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- _No notable changes yet._

## [2.0.3] - 2026-02-23

### Added
- Added Linux runtime recovery utility:
  - `scripts/linux/fix-nvidia-nvml.sh`
  - recovers common `nvidia-smi` / NVML failures by starting `nvidia-persistenced`,
    with optional boot registration via `systemctl add-wants`.

### Changed
- Refined operations documentation to match real-world incidents and recovery flow:
  - `docs/operations/troubleshooting.md`
  - `docs/operations/health-check.md`
  - `docs/platforms/linux/README.md`
  - `scripts/README.md`
  - `scripts/linux/README.md`

### Fixed
- Documented and operationalized fix path for WezTerm `update-status` runtime error storms.
- Stabilized local system runtime by ensuring `nvidia-persistenced` is active and pulled by `multi-user.target`.

### Verified
- System-first validation completed before release cut:
  - `nvidia-smi` and NVML operational,
  - terminal logs clean after WezTerm callback fix,
  - no terminal-related OOM events in the last 24h audit.
- Fully tested on Ubuntu 25.10.
- Fully tested on Ubuntu 24.04 LTS.
- macOS and Windows were not tested in this release cycle.
- If you encounter platform-specific issues, please open a GitHub issue and I will prioritize fixes.

## [2.0.2] - 2026-02-23

### Fixed
- Fixed WezTerm status update lag/freeze bug in `configs/wezterm/wezterm.lua` by preventing `string.gsub` multiple return values from being passed directly to `table.insert`.

### Verified
- Runtime log spam from `update-status` Lua runtime errors was eliminated after applying the config fix and reloading WezTerm.
- Fully tested on Ubuntu 25.10.
- Fully tested on Ubuntu 24.04 LTS.
- macOS and Windows were not tested in this release cycle.
- If you encounter platform-specific issues, please open a GitHub issue and I will prioritize fixes.

## [2.0.1] - 2026-02-23

### Added
- Added OS-first script documentation indexes:
  - `scripts/README.md`
  - `scripts/linux/README.md`
  - `scripts/macos/README.md`
  - `scripts/windows/README.md`
- Added repository documentation index: `docs/README.md`.

### Changed
- Renamed repository references from `rld-better-terminal-ai-usage` to `awesome-terminal-for-ai` across README, docs, wiki, security policy, and changelog links.
- Updated project naming in public docs/wiki to **Awesome Terminal for AI**.
- Reorganized Linux implementation into canonical OS-specific paths:
  - `scripts/linux/install-foundation.sh`
  - `scripts/linux/install-layer-{1..5}.sh`
  - `scripts/linux/install-nerd-fonts.sh`
- Simplified top-level `scripts/` UX by removing legacy Linux layer wrappers.
- Moved shared starship helper to `scripts/shared/starship/switch-profile.sh`.
- Reorganized Linux deep reference docs into OS-scoped location:
  - `docs/platforms/linux/reference/foundation.md`
  - `docs/platforms/linux/reference/layers/*`
  - `docs/platforms/linux/reference/terminal-tool-catalog.md`
- Refreshed README/wiki/docs navigation with cleaner OS-first UX and updated script/doc paths.
- Hardened CI workflow for release reliability and security:
  - added workflow-level concurrency cancellation,
  - pinned marketplace actions to immutable commit SHAs,
  - added per-job timeout limits,
  - expanded link-check coverage to docs/wiki core markdown files.
- Clarified canonical UX entrypoints across docs:
  - `scripts/install.sh` and `scripts/health-check.sh` are primary entrypoints,
  - `README.md` now links explicit docs index and wiki publish prerequisites,
  - `docs/README.md` defines canonical documentation starting points,
  - `wiki/Getting-Started.md` explicitly points to `README.md` quick-start as source of truth.
- Updated contributor contact path from Discussions to Issues (active support channel).

### Verified
- Fully tested on Ubuntu 25.10.
- Fully tested on Ubuntu 24.04 LTS.
- macOS and Windows were not tested in this release cycle.
- If you encounter platform-specific issues, please open a GitHub issue and I will prioritize fixes.

### Removed
- Removed repository directories:
  - `context/`
  - `research/`

## [2.0.0] - 2026-02-23

### Added
- Added production-ready Windows implementation with layered PowerShell installers and health-check:
  - `scripts/windows/install.ps1`
  - `scripts/windows/install-foundation.ps1`
  - `scripts/windows/install-layer-{1..5}.ps1`
  - `scripts/windows/health-check.ps1`
  - Shared helper module: `scripts/windows/common.ps1`
- Added Windows wrapper entrypoints:
  - `scripts/install-windows.ps1`
  - `scripts/health-check-windows.ps1`
- Added CI PowerShell parse validation job on `windows-latest`.
- Added Linux flow smoke validation job on `ubuntu-latest` (`./scripts/install.sh --dry-run`).

### Changed
- Root `scripts/install.sh` now detects Windows-like shell environments (`MINGW/MSYS/CYGWIN`) and delegates to PowerShell Windows installer.
- Root `scripts/health-check.sh` now delegates to Windows PowerShell health-check with flag translation (`--summary`/`--strict`).
- `configs/wezterm/wezterm.lua` is now OS-aware:
  - Windows defaults to `pwsh.exe`/`powershell.exe`
  - Unix-specific Wayland and unix-domain settings are guarded away from Windows.
- `README.md`, platform docs, wiki platform pages, and operations health-check docs now mark Windows as production-ready.
- Linux installers were hardened for safer and more reproducible provisioning:
  - moved installer-script execution from direct pipes to downloaded temporary script files,
  - normalized non-interactive APT usage in Linux scripts,
  - migrated cargo installs to `cargo install --locked` where applicable,
  - added checksum validation attempts for downloaded release archives (`lazygit`, `glow`, `grepai`) and optional `YQ_SHA256` pinning.
- Root Linux installer now supports:
  - `./scripts/install.sh --dry-run`
  - `./scripts/install.sh --help`
- Windows installer/health-check wrappers now support:
  - `.\scripts\install-windows.ps1 -Help`
  - `.\scripts\health-check-windows.ps1 -Help`
- Linux `scripts/health-check.sh` now:
  - checks `bat/batcat` and `fd/fdfind` compatibly,
  - validates real `ast-grep` runtime instead of trusting any `sg` binary.
- Updated repository documentation and wiki pages to align with current Linux/macOS/Windows production flows and validation contracts.

### Fixed
- Resolved Windows PowerShell help flag conflict by removing explicit `help` alias collisions in:
  - `scripts/windows/install.ps1`
  - `scripts/windows/health-check.ps1`

## [1.3.0] - 2026-02-23

### Added
- Added production-ready macOS implementation with layered installers and health-check:
  - `scripts/macos/install.sh`
  - `scripts/macos/install-foundation.sh`
  - `scripts/macos/install-layer-{1..5}.sh`
  - `scripts/macos/health-check.sh`
  - Shared helper module: `scripts/macos/common.sh`
- Added macOS wrapper entrypoints:
  - `scripts/install-macos.sh`
  - `scripts/health-check-macos.sh`
- Added OS-organized platform documentation:
  - `docs/platforms/linux/README.md`
  - `docs/platforms/macos/README.md`
  - `docs/platforms/windows/README.md` (placeholder)
- Added wiki page for platform navigation: `wiki/Platform-Guide.md`

### Changed
- Root `scripts/install.sh` now auto-detects OS and delegates to macOS pipeline on Darwin.
- Root `scripts/health-check.sh` now dispatches to macOS health-check on Darwin.
- `README.md` reorganized by operating systems (Linux/macOS/Windows placeholder) with platform-specific install paths.
- `docs/operations/terminal-tool-catalog.md` clarified as Linux-specific catalog with platform references.
- `docs/operations/health-check.md` updated to document Linux/macOS health-check entrypoints.

## [1.2.2] - 2026-02-23

### Added
- Added a professional GitHub Wiki source tree under `wiki/` with Home, sidebar/footer, architecture, operations runbook, troubleshooting, security, and contribution pages.
- Added `scripts/publish-wiki.sh` for repeatable Wiki publication via `gh` with idempotent sync behavior.

### Changed
- Updated `README.md` to include Wiki discoverability and document the `wiki/` + publish workflow.
- Enhanced WezTerm UX by moving the tab bar to the bottom and adding a neon-pink left status signature (`rldyourmnd`).
- Refreshed runtime/context validation snapshots to reflect current project health-check state.

### Fixed
- Fixed Wiki publication sync to preserve cloned wiki git metadata (`.git`) during `rsync`, preventing false "already up to date" states.

## [1.2.1] - 2026-02-23

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

[Unreleased]: https://github.com/rldyourmnd/awesome-terminal-for-ai/compare/v2.0.3...HEAD
[2.0.3]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v2.0.3
[2.0.2]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v2.0.2
[2.0.1]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v2.0.1
[2.0.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v2.0.0
[1.3.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.3.0
[1.2.2]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.2.2
[1.2.1]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.2.1
[1.1.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.1.0
[1.0.0]: https://github.com/rldyourmnd/awesome-terminal-for-ai/releases/tag/v1.0.0
