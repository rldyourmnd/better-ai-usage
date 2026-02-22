<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage">
    <img src="docs/assets/banner.svg" alt="Better Terminal Usage Banner" width="100%">
  </a>
</p>

<h1 align="center">Better Terminal Usage</h1>

<p align="center">
  <strong>🚀 Transform your Linux terminal into a high-performance development environment</strong>
</p>

<p align="center">
  <a href="#-features">Features</a> •
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-architecture">Architecture</a> •
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/wiki">Wiki</a>
</p>

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/stargazers">
    <img src="https://img.shields.io/github/stars/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github&color=yellow" alt="Stars">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/network/members">
    <img src="https://img.shields.io/github/forks/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github&color=blue" alt="Forks">
  </a>
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues">
    <img src="https://img.shields.io/github/issues/rldyourmnd/rld-better-terminal-ai-usage?style=for-the-badge&logo=github" alt="Issues">
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

## 📊 Performance Benchmarks

| Metric | Before | After | Improvement |
|:------:|:------:|:-----:|:-----------:|
| Shell startup | 915ms | **30ms** | 🚀 **30x faster** |
| Terminal startup | 300-500ms | **50-80ms** | 🚀 **6x faster** |
| Input latency | ~50ms | **<5ms** | 🚀 **10x faster** |
| File search | grep | **ripgrep** | 🚀 **10x+ faster** |

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎯 **30x Faster Shell**
Replace bloated configs with optimized Fish + Starship setup achieving ~30ms startup.

</td>
<td width="50%">

### 🖥️ **GPU-Accelerated Terminal**
WezTerm with OpenGL rendering (X11 mode for NVIDIA multi-monitor stability).

</td>
</tr>
<tr>
<td width="50%">

### 🔍 **Semantic Code Search**
grepai finds code by meaning, not just text. Perfect for exploring unfamiliar codebases.

</td>
<td width="50%">

### 📦 **Modern Package Managers**
uv for Python (100x faster than pip), bun for JavaScript (10x faster than npm).

</td>
</tr>
<tr>
<td width="50%">

### 🌳 **Visual Git Workflow**
lazygit + delta for beautiful diffs and intuitive staging/commits.

</td>
<td width="50%">

### 🔐 **Security Analysis**
semgrep for static analysis, protecting your code from vulnerabilities.

</td>
</tr>
</table>

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│  LAYER 5: AI ORCHESTRATION (user-provided)                         │
│  claude CLI • gemini CLI • codex CLI                               │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  LAYER 4: CODE INTELLIGENCE                                        │
│  grepai (88.4) • ast-grep (78.7) • probe • semgrep • ctags        │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  LAYER 3: GITHUB & GIT                                             │
│  gh CLI (83.2) • lazygit (v0.59) • delta                           │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  LAYER 2: PRODUCTIVITY                                             │
│  fzf (0.68.0) • zoxide (0.9.9) • Atuin (18.12.1) • uv (0.10.4)    │
│  bun (1.3.9) • watchexec (2.3.3) • glow • bottom (0.12.3)         │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  LAYER 1: FILE OPERATIONS                                          │
│  bat (0.26.1) • fd/fdfind (10.3.0) • rg (15.1.0) • sd (1.0.0)     │
│  jq (1.8.1) • yq (4.52.4) • eza (0.21.0)                          │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  FOUNDATION                                                        │
│  WezTerm + Fish + Starship                                         │
│  OpenGL + X11 (Wayland off) • ~30ms startup • <5ms latency         │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

System snapshot for versions/rendering in this diagram: `2026-02-23T01:20:38+07:00`.
Full live snapshot: `context/system-state.md`.

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/rldyourmnd/rld-better-terminal-ai-usage.git
cd better-terminal-usage

# Run the installer
./scripts/install.sh

# Restart your shell
exec fish
```

That's it! Your terminal is now optimized. 🎉

## 📦 Installation

### Option 1: Full Installation

```bash
./scripts/install.sh
```

### Option 2: Layer by Layer

```bash
# Foundation: Terminal + Shell + Prompt
./scripts/install-foundation.sh

# Layer 1: File Operations (bat, fd, rg, sd, jq, yq, eza)
./scripts/install-layer-1.sh

# Layer 2: Productivity (fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom)
./scripts/install-layer-2.sh

# Layer 3: GitHub & Git (gh CLI, lazygit, delta)
./scripts/install-layer-3.sh

# Layer 4: Code Intelligence (grepai, ast-grep, probe, semgrep, ctags, tokei)
./scripts/install-layer-4.sh
```

### Prerequisites

- **OS**: Ubuntu/Debian (apt-based Linux)
- **Permissions**: sudo access for system packages
- **Internet**: Required for downloading tools

<details>
<summary>📋 Detailed Tool List</summary>

### Foundation
| Tool | Description |
|------|-------------|
| [WezTerm](https://wezfurlong.org/wezterm/) | GPU-accelerated terminal with multiplexer |
| [Fish](https://fishshell.com/) | Friendly interactive shell |
| [Starship](https://starship.rs/) | Cross-shell prompt |

### Layer 1: File Operations
| Tool | Replaces | Score | Description |
|------|----------|-------|-------------|
| [bat](https://github.com/sharkdp/bat) | cat | 91.8 | cat with syntax highlighting |
| [fd](https://github.com/sharkdp/fd) | find | 86.1 | fast file finder |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | grep | 81.0 | fast text search |
| [sd](https://github.com/chmln/sd) | sed | 90.8 | intuitive sed replacement |
| [jq](https://stedolan.github.io/jq/) | - | 85.7 | JSON processor |
| [yq](https://github.com/mikefarah/yq) | - | 96.4 | YAML/JSON/XML processor |
| [eza](https://github.com/eza-community/eza) | ls | - | modern ls replacement |

### Layer 2: Productivity
| Tool | Score | Description |
|------|-------|-------------|
| [fzf](https://github.com/junegunn/fzf) | 88.7 | Fuzzy finder |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | 95.5 | Smart cd command |
| [Atuin](https://atuin.sh/) | 68.5 | Synced shell history |
| [uv](https://docs.astral.sh/uv/) | 91.4 | Fast Python package manager |
| [bun](https://bun.sh/) | 85.0 | Fast JavaScript runtime |
| [watchexec](https://watchexec.github.io/) | - | File watcher |
| [glow](https://github.com/charmbracelet/glow) | 76.1 | Markdown renderer |
| [bottom](https://github.com/ClementTsang/bottom) | - | System monitor |

### Layer 3: GitHub & Git
| Tool | Score | Description |
|------|-------|-------------|
| [gh CLI](https://cli.github.com/) | 83.2 | GitHub in terminal |
| [lazygit](https://github.com/jesseduffield/lazygit) | - | Git TUI |
| [delta](https://github.com/dandavison/delta) | - | Beautiful diffs |

### Layer 4: Code Intelligence
| Tool | Score | Description |
|------|-------|-------------|
| [grepai](https://github.com/yoanbernabeu/grepai) | 88.4 | Semantic code search |
| [ast-grep](https://ast-grep.github.io/) | 78.7 | AST-based search/rewrite |
| [probe](https://github.com/buger/probe) | - | Code extraction |
| [semgrep](https://semgrep.dev/) | 70.4 | Security analysis |
| [ctags](https://ctags.io/) | - | Code indexing |
| [tokei](https://github.com/XAMPPRocky/tokei) | - | Code statistics |

### Layer 5: AI Orchestration (User-Provided)
| Tool | Provider | Description |
|------|----------|-------------|
| [claude CLI](https://docs.anthropic.com/en/docs/claude-code) | Anthropic | Deep reasoning AI assistant |
| [gemini CLI](https://github.com/google-gemini/gemini-cli) | Google | Fast research and analysis |
| [codex CLI](https://github.com/openai/codex) | OpenAI | Code generation |

> **Note**: Layer 5 tools are not installed by this project. Install them separately from their official sources.

</details>

## 📖 Usage Examples

### File Operations

```bash
# View file with syntax highlighting
bat src/main.rs

# Find files quickly
fd -e rs -x wc -l {}

# Search in files (respects .gitignore)
rg "fn main" --type rust

# Replace text with sd
sd 'old_name' 'new_name' src/**/*.rs
```

### Productivity

```bash
# Fuzzy find files and edit
vim $(fzf --preview 'bat --color=always {}')

# Smart directory navigation
z myproject    # Jump to frequently used directory

# Run command on file changes
watchexec -e rs cargo test
```

### Git & GitHub

```bash
# Visual git interface
lazygit

# Create PR from CLI
gh pr create --title "Feature" --body "Description"

# Beautiful diff
git diff | delta
```

### Code Intelligence

```bash
# Semantic code search
grepai search "authentication flow"

# AST-based structural search
sg -p 'fn $NAME($$$PARAMS) $$$BODY' -l rust

# Security scan
semgrep --config auto .
```

### AI Orchestration (Layer 5)

```bash
# Deep reasoning with Claude
claude "Explain this architecture and suggest improvements"

# Fast research with Gemini
gemini -p "What are the best practices for this pattern?"

# Code generation with Codex
codex exec "Write a function that validates email addresses"

# Combine with other tools
rg "TODO" | claude "Prioritize these TODOs and suggest implementation order"
```

## 📁 Project Structure

```
better-terminal-usage/
├── 📄 README.md              # You are here
├── 📜 LICENSE                # MIT License
├── 🤝 CONTRIBUTING.md        # Contribution guidelines
├── 📋 CHANGELOG.md           # Version history
├── 📁 configs/               # Configuration files
│   ├── fish/config.fish      # Fish shell config
│   ├── starship/starship.toml # Starship prompt config
│   └── wezterm/wezterm.lua   # WezTerm terminal config
├── 📁 docs/                  # Documentation
│   ├── layers/               # Layer-specific docs
│   └── foundation/           # Foundation docs
├── 📁 scripts/               # Installation scripts
│   ├── install.sh            # Main installer
│   ├── install-foundation.sh # Foundation installer
│   └── install-layer-*.sh    # Layer installers
└── 📁 context/               # Research & benchmarks
```

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

### Ways to Contribute

- 🐛 **Report bugs** via [Issues](https://github.com/rldyourmnd/rld-better-terminal-ai-usage/issues)
- 💡 **Suggest features** via [Discussions](https://github.com/rldyourmnd/rld-better-terminal-ai-usage/discussions)
- 📝 **Improve documentation**
- 🔧 **Submit pull requests**

## 🗺️ Roadmap

- [ ] macOS support
- [ ] Nix/NixOS configuration
- [ ] Ansible playbook
- [ ] Docker container with pre-configured environment
- [ ] Video tutorials

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [WezTerm](https://wezfurlong.org/wezterm/) - Amazing terminal emulator
- [Fish Shell](https://fishshell.com/) - User-friendly shell
- [Starship](https://starship.rs/) - Beautiful cross-shell prompt
- All the amazing CLI tools that make this possible

---

<p align="center">
  <strong>Made with ❤️ for developers who love fast terminals</strong>
</p>

<p align="center">
  <a href="https://github.com/rldyourmnd/rld-better-terminal-ai-usage/stargazers">
    <img src="https://img.shields.io/github/stars/rldyourmnd/rld-better-terminal-ai-usage?style=social" alt="Star us on GitHub">
  </a>
  <a href="https://github.com/rldyourmnd">
    <img src="https://img.shields.io/github/followers/rldyourmnd?style=social" alt="Follow on GitHub">
  </a>
</p>

<p align="center">
  <a href="#-top">⬆️ Back to Top</a>
</p>
