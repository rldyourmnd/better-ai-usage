# System State Snapshot

Captured from the current machine and intended as the canonical "current state" reference for this repository.

## Captured At

- Timestamp: 2026-02-23T07:49:35+07:00
- Host profile: Linux, NVIDIA RTX 2070, i7-8750H, 32GB RAM

## Rendering and Shell Profile

- WezTerm renderer: `OpenGL`
- Display backend: `X11` (`enable_wayland = false`)
- WezTerm default shell path: `/home/linuxbrew/.linuxbrew/bin/fish`
- WezTerm safe renderer switch: `WEZTERM_SAFE_RENDERER=1` (Software fallback)
- WezTerm scrollback: `20000` lines
- Prompt: `starship`

## Config Parity (System vs Repo)

- `~/.wezterm.lua` ❌ differs from `configs/wezterm/wezterm.lua`
- `~/.config/fish/config.fish` ❌ differs from `configs/fish/config.fish`
- `~/.config/starship.toml` ❌ differs from `configs/starship/starship.toml`

## Installed Tool Versions (System)

| Tool | Version (raw command output) |
|------|-------------------------------|
| `wezterm` | `wezterm 20240203-110809-5046fc22` |
| `fish` | `fish, version 4.5.0` |
| `starship` | `starship 1.24.2` |
| `bat` | `bat 0.25.0` |
| `fdfind` | `fdfind 10.3.0` |
| `rg` | `ripgrep 15.1.0` |
| `sd` | `sd 1.0.0` |
| `jq` | `jq-1.8.1` |
| `yq` | `yq (https://github.com/mikefarah/yq/) version v4.52.4` |
| `eza` | `v0.21.0 [+git]` |
| `fzf` | `0.68.0 (Homebrew)` |
| `glow` | `glow version unknown (built from source)` |
| `zoxide` | `zoxide 0.9.9` |
| `atuin` | `atuin 18.12.1 (42dd242541d1db21c676e213a98d50ee74bd553d)` |
| `uv` | `uv 0.10.4 (Homebrew 2026-02-17)` |
| `bun` | `1.3.9` |
| `watchexec` | `watchexec 2.4.0 (2026-02-22) +pid1` |
| `btm` | `bottom 0.12.3` |
| `hyperfine` | `hyperfine 1.20.0` |
| `gh` | `gh version 2.87.2 (2026-02-20)` |
| `lazygit` | `commit=1d0db51caf3d280a53f027ef049355fc9e0c57e8, build date=2026-02-07T08:34:27Z, build source=binaryRelease, version=0.59.0, os=linux, arch=amd64, git version=2.51.0` |
| `delta` | `delta 0.18.2` |
| `grepai` | `grepai version 0.33.0` |
| `sg` | `ast-grep 0.40.5` |
| `probe` | `probe-code 0.6.0` |
| `tokei` | `tokei 14.0.0 compiled with serialization support: json` |
| `semgrep` | `1.152.0` |
| `ctags` | `Universal Ctags 5.9.0, Copyright (C) 2015 Universal Ctags Team` |
| `node` | `v24.13.1` |
| `npm` | `11.8.0` |
| `claude` | `2.1.50 (Claude Code)` |
| `gemini` | `0.29.5` |
| `codex` | `codex-cli 0.104.0` |

## Context7 Validation Notes

The following official docs were consulted through Context7 for configuration validity:

- WezTerm (`/wezterm/wezterm`): `front_end` supports `OpenGL` / `WebGpu` / `Software`; `enable_wayland` is valid.
- Fish (`/fish-shell/fish-shell`): `fish_add_path`, `type -q`, and `abbr -a` patterns are valid.
- Starship (`/starship/starship`): top-level `format`/`right_format` and module `disabled` config style is valid.
- Semgrep (`/semgrep/semgrep-docs`): `scan` is default command family and `--version` is documented.

## Health-Check Snapshot

- `scripts/health-check.sh` status: PASS (3 warnings)
- Key warnings:
  - Config parity mismatches for three user template files

## Wiki Publication Snapshot

- GitHub Wiki publish status: SUCCESS
- Published from repository source directory: `wiki/`
- Publisher script: `scripts/publish-wiki.sh`
- Wiki URL: `https://github.com/rldyourmnd/rld-better-terminal-ai-usage/wiki`
