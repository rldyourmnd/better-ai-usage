# macOS

Production-ready macOS implementation using Homebrew and the same layered model.

## Scope

- OS: macOS (Darwin)
- Package manager: Homebrew (formulae + casks)
- Shell: Fish
- Terminal: WezTerm
- Prompt: Starship
- Layers: Foundation + Layer 1..5

## Entrypoints

- Full install (auto-detect): `./scripts/install.sh`
- Full install (explicit): `./scripts/install-macos.sh`
- Health check (explicit): `./scripts/health-check-macos.sh --summary`

## macOS Layer Scripts

- `scripts/macos/install.sh`
- `scripts/macos/install-foundation.sh`
- `scripts/macos/install-layer-1.sh`
- `scripts/macos/install-layer-2.sh`
- `scripts/macos/install-layer-3.sh`
- `scripts/macos/install-layer-4.sh`
- `scripts/macos/install-layer-5.sh`
- `scripts/macos/health-check.sh`

## Homebrew-Backed Tooling Model

### Foundation

- cask: `wezterm`
- formulae: `fish`, `starship`

### Layer 1 (File Operations)

- formulae: `bat`, `fd`, `ripgrep`, `sd`, `jq`, `yq`, `eza`

### Layer 2 (Productivity)

- formulae: `fzf`, `zoxide`, `atuin`, `uv`, `bun`, `watchexec`, `glow`, `bottom`, `hyperfine`

### Layer 3 (GitHub & Git)

- formulae: `gh`, `lazygit`, `git-delta`

### Layer 4 (Code Intelligence)

- formulae: `universal-ctags`, `tokei`, `ast-grep`, `semgrep`
- cargo: `probe-code`
- grepai: Homebrew formula if available; otherwise GitHub release fallback for macOS architecture

### Layer 5 (AI Orchestration)

- formula: `node`
- npm globals:
  - `@anthropic-ai/claude-code`
  - `@google/gemini-cli`
  - `@openai/codex`

## Operational Notes

- Fish default shell setup requires adding fish path to `/etc/shells` and running `chsh -s <fish_path>`.
- WezTerm GUI is installed via Homebrew cask; script applies shared repo config to `~/.wezterm.lua`.
- Config parity is validated by `scripts/macos/health-check.sh`.
