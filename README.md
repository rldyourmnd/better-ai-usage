# Better Terminal Usage

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage">
    <img src="docs/assets/terminal-screenshot.png" alt="Terminal screenshot" width="100%">
  </a>
</p>

<p align="center">
  <strong>Production-ready Linux terminal stack: WezTerm + Fish + Starship with a 5-layer AI-native toolchain.</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-terminal--tools-catalog">Terminal & Tools Catalog</a> •
  <a href="#-verification-and-health-checks">Verification and Health Checks</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="#-operations">Operations</a> •
  <a href="#-troubleshooting">Troubleshooting</a> •
  <a href="#-contributing">Contributing</a> •
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/wiki">Wiki</a>
</p>

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/stargazers">
    <img src="https://img.shields.io/github/stars/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github" alt="GitHub stars">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/network/members">
    <img src="https://img.shields.io/github/forks/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github&color=blue" alt="GitHub forks">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues">
    <img src="https://img.shields.io/github/issues/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github" alt="GitHub issues">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&color=green" alt="License">
  </a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-Linux-orange?style=flat-square&logo=linux" alt="Platform">
  <img src="https://img.shields.io/badge/shell-Fish-9C27B0?style=flat-square&logo=fish-shell" alt="Shell">
  <img src="https://img.shields.io/badge/terminal-WezTerm-00D8FF?style=flat-square" alt="Terminal">
  <img src="https://img.shields.io/badge/prompt-Starship-DD0B78?style=flat-square" alt="Prompt">
</p>

---

## ✅ What this repository is

`rld-better-terminal-ai-usage` is a production-oriented terminal bootstrap for Debian/Ubuntu that provides:

- WezTerm + Fish + Starship base environment.
- Layered CLI tooling split into 5 isolated install layers.
- Reproducible verification and troubleshooting workflow.
- User-agnostic scripts (no hardcoded `/home/<user>` in install/config logic).

## 🚀 Quick Start

```bash
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd rld-better-terminal-ai-usage
./scripts/install.sh
```

After setup:

```bash
exec fish
```

## 🧩 Installation

### Requirements

- Ubuntu/Debian (apt-based)
- `curl` and `git` (required by installer scripts)
- `sudo` for system packages
- Internet access
- `amd64` or `arm64` Linux (multi-arch installer fallbacks are handled automatically)

### Full install (recommended)

```bash
./scripts/install.sh
```

`install.sh` runs these layers in this order:

- `scripts/install-foundation.sh`
- `scripts/install-layer-1.sh`
- `scripts/install-layer-2.sh`
- `scripts/install-layer-3.sh`
- `scripts/install-layer-4.sh`
- `scripts/install-layer-5.sh`

Use this deterministic sequence if you want checkpointed output per layer.

### Layer-by-layer install

```bash
./scripts/install-foundation.sh
./scripts/install-layer-1.sh
./scripts/install-layer-2.sh
./scripts/install-layer-3.sh
./scripts/install-layer-4.sh
./scripts/install-layer-5.sh
```

### Installed content by layer

| Layer | Script | Includes |
|---|---|---|
| Foundation | `install-foundation.sh` | WezTerm, Fish, Starship, Nerd Fonts, shared configs |
| Layer 1 | `install-layer-1.sh` | bat, fd (fdfind), rg, sd, jq, yq, eza |
| Layer 2 | `install-layer-2.sh` | fzf, zoxide, atuin, uv, bun, watchexec, glow, btm, hyperfine |
| Layer 3 | `install-layer-3.sh` | gh CLI, lazygit, delta |
| Layer 4 | `install-layer-4.sh` | grepai, ast-grep, probe, semgrep, ctags, tokei |
| Layer 5 | `install-layer-5.sh` | claude, gemini, codex |

## 🧰 Terminal & Tools Catalog

[`docs/operations/terminal-tool-catalog.md`](docs/operations/terminal-tool-catalog.md) is the authoritative inventory for all terminals and tools used by this repo, including expected binaries, install source, and health checks.

## 🛠 Verification and Health checks

Run the built-in health-check before and after changes:

```bash
./scripts/health-check.sh
```

Checks include:

- Bash syntax validation for all installer scripts.
- Tool presence and version probes.
- PATH/`~/.local/bin` checks.
- Config parity checks for WezTerm, Fish, and Starship.
- Known failure checks (`semgrep`, `gemini`) with suggested remediation.

State snapshots are tracked in:

- `context/system-state.md` (current machine snapshot)
- `context/script-validation.md` (validation report)

## 🏗️ Architecture

```text
Foundation: WezTerm + Fish + Starship
↓
Layer 1: File Operations (bat, fd, rg, sd, jq, yq, eza)
↓
Layer 2: Productivity (fzf, zoxide, atuin, uv, bun, watchexec, glow, btm, hyperfine)
↓
Layer 3: GitHub workflow (gh, lazygit, delta)
↓
Layer 4: Code Intelligence (grepai, ast-grep, probe, semgrep, ctags, tokei)
↓
Layer 5: AI orchestration (claude, gemini, codex)
```

## 📦 Operations

- `docs/operations/health-check.md` – production checklists and runbook
- `docs/operations/terminal-tool-catalog.md` – terminal and layer tool matrix
- `docs/operations/troubleshooting.md` – known issues and recovery steps
- `docs/operations/upgrade-and-rollback.md` – controlled upgrade strategy
- `wiki/` – GitHub Wiki source pages (Home, sidebar, runbooks)
- `scripts/publish-wiki.sh` – publish `wiki/` to GitHub Wiki via `gh`
- `docs/layers/*.md` – per-layer installation and command usage
- `context/` – research and reference snapshots

## 📁 Project structure

```text
rld-better-terminal-ai-usage/
├── scripts/
│   ├── install.sh
│   ├── install-foundation.sh
│   ├── install-layer-1.sh
│   ├── install-layer-2.sh
│   ├── install-layer-3.sh
│   ├── install-layer-4.sh
│   ├── install-layer-5.sh
│   ├── health-check.sh
│   └── publish-wiki.sh
├── configs/
│   ├── fish/config.fish
│   ├── wezterm/wezterm.lua
│   └── starship/
├── docs/
│   ├── foundation/
│   ├── layers/
│   └── operations/
├── wiki/
├── context/
└── CHANGELOG.md
```

## 🛠 Troubleshooting

- If a layer fails, resolve the blocker and re-run only the failed layer.
- If config parity fails, compare local files with `configs/*`.
- If third-party CLI commands fail, check:

```bash
./scripts/health-check.sh --summary
```

### Local CLI checks

```bash
command -v bat rg fzf gh lazygit delta claude codex
```

## 🤝 Contributing

- open an issue: <https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues>
- submit PRs with focused, verifiable changes.

## 📄 License

MIT License. See [LICENSE](LICENSE).

## 🙌 Acknowledgements

- WezTerm, Fish, and Starship teams and maintainers.
- All tool maintainers and community contributors.

<p align="center">
  <strong>An open-source, user-agnostic terminal setup for AI-native Linux development workflows.</strong>
</p>
