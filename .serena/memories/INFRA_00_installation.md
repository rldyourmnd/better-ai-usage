<!-- Memory Metadata
Last updated: 2026-02-21
Last commit: dbba71c docs: add comprehensive context directory with research data
Scope: scripts/install.sh, scripts/install-layer-*.sh (TODO)
Area: INFRA
-->

# Installation Process

## Overview

Bash-based installation system with both single-command complete installation and per-layer selective installation. Scripts are idempotent (safe to run multiple times) and include preflight checks.

**Platform**: Linux (Ubuntu/Debian, apt-based)

## Installation Commands by Tool

### apt packages (Ubuntu/Debian)

```bash
# Foundation
sudo apt install -y fish

# Layer 1: File Operations
sudo apt install -y bat jq fd-find ripgrep eza

# Layer 2: Productivity
sudo apt install -y glow

# Layer 3: GitHub & Git
sudo apt install -y gh lazygit

# Layer 4: Code Intelligence
sudo apt install -y universal-ctags

# WezTerm (requires repo setup first)
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install -y wezterm
```

### cargo packages (Rust)

```bash
cargo install sd zoxide watchexec bottom tokei ast-grep probe-cli hyperfine delta
```

### pip packages (Python)

```bash
pip install grepai semgrep
```

### curl scripts

```bash
# Starship prompt
curl -sS https://starship.rs/install.sh | sh

# uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh

# bun (JavaScript runtime)
curl -fsSL https://bun.sh/install | bash

# Atuin (history sync)
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

### wget binaries

```bash
# yq (YAML/JSON/XML processor)
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq

# eza (alternative method)
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
sudo chmod +x eza
sudo chown root:root eza
sudo mv eza /usr/local/bin/eza
```

---

## Layer-by-Layer Installation

### Foundation: Terminal + Shell

| Tool | Install Method | Notes |
|------|----------------|-------|
| WezTerm | apt (fury.io repo) | Requires GPG key import |
| Fish | apt | - |
| Starship | curl script | Installs to /usr/local/bin |

**WezTerm Setup:**
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update
sudo apt install -y wezterm
```

### Layer 1: File Operations

| Tool | Score | Install Method | Notes |
|------|-------|----------------|-------|
| bat | 91.8 | apt | Ubuntu installs as `batcat` - needs symlink |
| fd | 86.1 | apt | Package: `fd-find` |
| rg | 81 | apt | Package: `ripgrep` |
| sd | 90.8 | cargo | - |
| jq | 85.7 | apt | - |
| yq | 96.4 | wget | Binary download |
| eza | - | apt/wget | `eza` package or binary |

**bat symlink fix:**
```bash
sudo apt install -y bat
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

### Layer 2: Productivity

| Tool | Score | Install Method | Notes |
|------|-------|----------------|-------|
| fzf | 85.4 | apt/git | Shell integration required |
| zoxide | 39.7 | cargo | - |
| Atuin | 68.5 | curl | Encrypted sync optional |
| uv | 91.4 | curl | Replaces pip |
| bun | 85 | curl | Replaces npm |
| watchexec | - | cargo | - |
| glow | 76.1 | apt | - |
| bottom | - | cargo | Command: `btm` |
| hyperfine | 81.3 | cargo | Benchmarking |

**fzf setup:**
```bash
sudo apt install -y fzf
# Add to config.fish:
fzf --fish | source
```

### Layer 3: GitHub & Git

| Tool | Score | Install Method | Notes |
|------|-------|----------------|-------|
| gh CLI | 83.2 | apt | Requires `gh auth login` |
| lazygit | 46 | apt | - |
| delta | - | cargo | Git pager config required |

**delta git config:**
```bash
# Add to ~/.gitconfig
[core]
    pager = delta
[delta]
    syntax-theme = Catppuccin
    side-by-side = true
    line-numbers = true
```

### Layer 4: Code Intelligence

| Tool | Score | Install Method | Notes |
|------|-------|----------------|-------|
| grepai | 88.4 | pip | Requires `grepai init` |
| ast-grep | 78.7 | cargo | Command: `sg` |
| probe | - | cargo | Package: `probe-cli` |
| semgrep | 70.4 | pip | - |
| ctags | - | apt | Package: `universal-ctags` |
| tokei | - | cargo | - |

**grepai initialization:**
```bash
pip install grepai
grepai init  # Build embeddings (required before use)
```

---

## Configuration Application

### Directory Creation

```bash
mkdir -p ~/.config/wezterm
mkdir -p ~/.config/fish
mkdir -p ~/.config
```

### File Copies

```bash
cp configs/wezterm/wezterm.lua ~/.wezterm.lua
cp configs/fish/config.fish ~/.config/fish/config.fish
cp configs/starship/starship.toml ~/.config/starship.toml
```

---

## Post-Installation Steps

1. **Restart terminal** or run: `exec fish`
2. **Initialize grepai**: `grepai init`
3. **Login to GitHub CLI**: `gh auth login`
4. **Login to Atuin** (optional): `atuin login`
5. **Verify installations**:
   ```bash
   wezterm --version
   fish --version
   starship --version
   bat --version
   fd --version
   rg --version
   fzf --version
   ```

---

## Script Structure (install.sh)

### Header Pattern
```bash
#!/usr/bin/env bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Logging Functions
```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'  # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
```

### Idempotent Installation Pattern
```bash
command_exists() { command -v "$1" &> /dev/null; }

if ! command_exists tool; then
    log_info "Installing tool..."
    # install command
    log_success "tool installed"
else
    log_info "tool already installed"
fi
```

---

## Missing Layer Scripts (TODO)

The README.md references these layer-specific scripts that do not exist:

- `scripts/install-layer-1-file-ops.sh`
- `scripts/install-layer-2-productivity.sh`
- `scripts/install-layer-3-github.sh`
- `scripts/install-layer-4-code-intelligence.sh`

---

## Known Issues

1. **bat symlink**: Ubuntu installs as `batcat`, requires manual symlink to `bat`
2. **fd package name**: apt package is `fd-find`, command is `fd`
3. **fzf shell integration**: Not automatic, requires adding to config.fish
4. **grepai init**: Required before semantic search works
5. **delta git config**: Manual ~/.gitconfig update required

---

## Verification Commands

```bash
# Check all installed tools
for tool in wezterm fish starship bat fd rg sd jq yq eza fzf zoxide atuin uv bun watchexec glow btm tokei hyperfine gh lazygit delta grepai sg probe semgrep ctags; do
    if command -v $tool &> /dev/null; then
        echo "✅ $tool: $(command -v $tool)"
    else
        echo "❌ $tool: NOT INSTALLED"
    fi
done
```

---

## Cross-References

See also: CORE_00_overview.md (project overview)
See also: CORE_01_layers.md (5-layer architecture with all tools)
See also: FRONTEND_00_terminal.md (terminal configuration)
