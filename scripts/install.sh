#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# BETTER TERMINAL USAGE - Complete Installation Script
# ═══════════════════════════════════════════════════════════════════════════════
# Installs all tools for the High-Performance Terminal Environment
# Run: ./scripts/install.sh

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() { command -v "$1" &> /dev/null; }

# Resolve project root so script works from any current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

# Check for required tools
for cmd in curl wget git; do
    if ! command_exists "$cmd"; then
        log_error "$cmd is required but not installed"
        exit 1
    fi
done

log_success "Preflight checks passed"

# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 1: FILE OPERATIONS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Layer 1: File Operations..."

# bat (91.8) - cat replacement
if ! command_exists bat; then
    log_info "Installing bat..."
    sudo apt install -y bat
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/batcat ~/.local/bin/bat 2>/dev/null || true
    log_success "bat installed"
else
    log_info "bat already installed"
fi

# fd (86.1) - find replacement
if ! command_exists fd && ! command_exists fdfind; then
    log_info "Installing fd-find..."
    sudo apt install -y fd-find
    log_success "fd-find installed"
else
    log_info "fd-find already installed"
fi

# fd symlink (Ubuntu installs as fdfind, not fd)
if command_exists fdfind && ! command_exists fd; then
    mkdir -p ~/.local/bin
    ln -sf /usr/bin/fdfind ~/.local/bin/fd
    log_success "fd symlink created (~/.local/bin/fd -> /usr/bin/fdfind)"
fi

# rg (81) - grep replacement
if ! command_exists rg; then
    log_info "Installing ripgrep..."
    sudo apt install -y ripgrep
    log_success "ripgrep installed"
else
    log_info "ripgrep already installed"
fi

# eza - ls replacement
if ! command_exists eza; then
    log_info "Installing eza..."
    sudo apt install -y eza
    log_success "eza installed"
else
    log_info "eza already installed"
fi

# jq (85.7) - JSON processor
if ! command_exists jq; then
    log_info "Installing jq..."
    sudo apt install -y jq
    log_success "jq installed"
else
    log_info "jq already installed"
fi

# sd (90.8) - sed replacement
if ! command_exists sd; then
    log_info "Installing sd..."
    cargo install sd
    log_success "sd installed"
else
    log_info "sd already installed"
fi

# yq (96.4) - YAML/JSON/XML processor
if ! command_exists yq; then
    log_info "Installing yq..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
    log_success "yq installed"
else
    log_info "yq already installed"
fi

log_success "Layer 1 complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 2: PRODUCTIVITY
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Layer 2: Productivity..."

# zoxide - smart cd
if ! command_exists zoxide; then
    log_info "Installing zoxide..."
    cargo install zoxide
    log_success "zoxide installed"
else
    log_info "zoxide already installed"
fi

# Atuin (68.5) - SQLite history + sync
if ! command_exists atuin; then
    log_info "Installing Atuin..."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    log_success "Atuin installed"
else
    log_info "Atuin already installed"
fi

# uv (91.4) - Python package manager
if ! command_exists uv; then
    log_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    log_success "uv installed"
else
    log_info "uv already installed"
fi

# bun (85) - JavaScript runtime
if ! command_exists bun; then
    log_info "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    log_success "bun installed"
else
    log_info "bun already installed"
fi

# watchexec - file watcher
if ! command_exists watchexec; then
    log_info "Installing watchexec..."
    cargo install watchexec
    log_success "watchexec installed"
else
    log_info "watchexec already installed"
fi

# glow (76.1) - markdown renderer
if ! command_exists glow; then
    log_info "Installing glow..."
    sudo apt install -y glow
    log_success "glow installed"
else
    log_info "glow already installed"
fi

# bottom - system monitor
if ! command_exists btm; then
    log_info "Installing bottom..."
    cargo install bottom
    log_success "bottom installed"
else
    log_info "bottom already installed"
fi

# tokei - code statistics
if ! command_exists tokei; then
    log_info "Installing tokei..."
    cargo install tokei
    log_success "tokei installed"
else
    log_info "tokei already installed"
fi

log_success "Layer 2 complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 3: GITHUB & GIT
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Layer 3: GitHub & Git..."

# gh CLI (83.2) - GitHub terminal
if ! command_exists gh; then
    log_info "Installing gh CLI..."
    sudo apt install -y gh
    log_success "gh CLI installed"
else
    log_info "gh CLI already installed"
fi

# lazygit (46) - Git TUI
if ! command_exists lazygit; then
    log_info "Installing lazygit..."
    sudo apt install -y lazygit
    log_success "lazygit installed"
else
    log_info "lazygit already installed"
fi

log_success "Layer 3 complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 4: CODE INTELLIGENCE
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Layer 4: Code Intelligence..."

# grepai (88.4) - semantic code search
if ! command_exists grepai; then
    log_info "Installing grepai..."
    pip install grepai
    log_success "grepai installed"
else
    log_info "grepai already installed"
fi

# ast-grep (78.7) - AST structural search
if ! command_exists sg; then
    log_info "Installing ast-grep..."
    cargo install ast-grep
    log_success "ast-grep installed"
else
    log_info "ast-grep already installed"
fi

# probe - code extraction
if ! command_exists probe; then
    log_info "Installing probe..."
    cargo install probe-code
    log_success "probe installed"
else
    log_info "probe already installed"
fi

# semgrep (70.4) - security analysis
if ! command_exists semgrep; then
    log_info "Installing semgrep..."
    pip install semgrep
    log_success "semgrep installed"
else
    log_info "semgrep already installed"
fi

# ctags - code indexing
if ! command_exists ctags; then
    log_info "Installing ctags..."
    sudo apt install -y universal-ctags
    log_success "ctags installed"
else
    log_info "ctags already installed"
fi

log_success "Layer 4 complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 5: AI ORCHESTRATION (User-provided CLIs)
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Layer 5: AI Orchestration..."

# Check for npm/node
if ! command_exists npm; then
    log_warn "npm not found. Installing nodejs..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Claude Code (80.6)
if ! command_exists claude; then
    log_info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code installed"
else
    log_info "Claude Code already installed"
fi

# Gemini CLI (78.2)
if ! command_exists gemini; then
    log_info "Installing Gemini CLI..."
    npm install -g @google/gemini-cli
    log_success "Gemini CLI installed"
else
    log_info "Gemini CLI already installed"
fi

# Codex CLI (56.9)
if ! command_exists codex; then
    log_info "Installing Codex CLI..."
    npm install -g @openai/codex
    log_success "Codex CLI installed"
else
    log_info "Codex CLI already installed"
fi

log_success "Layer 5 complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# FOUNDATION: TERMINAL + SHELL
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Foundation..."

# WezTerm
if ! command_exists wezterm; then
    log_info "Installing WezTerm..."
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-archive-keyring.gpg
    echo 'deb [signed-by=/usr/share/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
    sudo apt update
    sudo apt install -y wezterm
    log_success "WezTerm installed"
else
    log_info "WezTerm already installed"
fi

# Fish shell
if ! command_exists fish; then
    log_info "Installing Fish..."
    sudo apt install -y fish
    log_success "Fish installed"
else
    log_info "Fish already installed"
fi

# Starship prompt
if ! command_exists starship; then
    log_info "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh
    log_success "Starship installed"
else
    log_info "Starship already installed"
fi

# Nerd Fonts for Starship/WezTerm icons
if [ -x "$PROJECT_DIR/scripts/install-nerd-fonts.sh" ]; then
    log_info "Installing Nerd Fonts for prompt icons..."
    if "$PROJECT_DIR/scripts/install-nerd-fonts.sh"; then
        log_success "Nerd Fonts installed"
    else
        log_warn "Nerd Fonts installation failed (continuing)"
    fi
else
    log_warn "Nerd font installer script not found: $PROJECT_DIR/scripts/install-nerd-fonts.sh"
fi

log_success "Foundation complete!"

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Applying configurations..."

# Copy WezTerm config
mkdir -p ~/.config/wezterm
cp "$PROJECT_DIR/configs/wezterm/wezterm.lua" ~/.wezterm.lua
cp "$PROJECT_DIR/configs/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
log_success "WezTerm config applied"

# Copy Fish config
mkdir -p ~/.config/fish
cp "$PROJECT_DIR/configs/fish/config.fish" ~/.config/fish/config.fish
log_success "Fish config applied"

# Copy Starship config
mkdir -p ~/.config
mkdir -p ~/.config/starship/profiles
mkdir -p ~/.local/bin
if command_exists starship; then
    STARSHIP_CONFIG="$PROJECT_DIR/configs/starship/starship.toml" starship module character >/dev/null
fi
cp "$PROJECT_DIR/configs/starship/starship.toml" ~/.config/starship.toml
cp "$PROJECT_DIR"/configs/starship/profiles/*.toml ~/.config/starship/profiles/
cp "$PROJECT_DIR/scripts/starship/switch-profile.sh" ~/.local/bin/starship-profile
chmod +x ~/.local/bin/starship-profile
if command_exists starship-profile; then
    starship-profile ultra-max >/dev/null 2>&1 || log_warn "Failed to apply ultra-max profile automatically"
elif [ -x ~/.local/bin/starship-profile ]; then
    ~/.local/bin/starship-profile ultra-max >/dev/null 2>&1 || log_warn "Failed to apply ultra-max profile automatically"
fi
log_success "Starship config applied (default + profiles + switcher)"

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ALL 5 LAYERS + FOUNDATION COMPLETE!                        ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Layers installed:"
echo "  Foundation: WezTerm + Fish + Starship"
echo "  Layer 1:    bat, fd, rg, sd, jq, yq, eza"
echo "  Layer 2:    fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom"
echo "  Layer 3:    gh CLI, lazygit, delta"
echo "  Layer 4:    grepai, ast-grep, probe, semgrep, ctags, tokei"
echo "  Layer 5:    Claude Code, Gemini CLI, Codex CLI"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec fish"
echo "2. Initialize grepai: grepai init"
echo "3. Login to GitHub CLI: gh auth login"
echo "4. Login to Atuin (optional): atuin login"
echo "5. Authenticate AI CLIs:"
echo "   - claude (browser auth opens automatically)"
echo "   - gemini (select 'Login with Google')"
echo "   - codex (export OPENAI_API_KEY='your-key')"
echo ""
echo "Enjoy your Ultimate AI Terminal Environment!"
