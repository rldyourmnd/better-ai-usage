#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 2: PRODUCTIVITY INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════════
# Installs: fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom, hyperfine
# Platform: Linux (Ubuntu/Debian)
# Run: ./install-layer-2.sh

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if command exists
command_exists() { command -v "$1" &>/dev/null; }

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  LAYER 2: PRODUCTIVITY"
echo "  fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom, hyperfine"
echo "════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

# Check for cargo (needed for some tools)
if ! command_exists cargo; then
    log_warn "cargo not found. Installing rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [ -f "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi
fi

if ! command_exists cargo; then
    log_error "cargo still not available. Please install manually and re-run."
    exit 1
fi

log_success "Preflight checks passed"

# ═══════════════════════════════════════════════════════════════════════════════
# FZF - Fuzzy finder
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing fzf..."

if ! command_exists fzf; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --key-bindings --completion --no-update-rc --no-bash --no-zsh
    log_success "fzf installed"
else
    log_info "fzf already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# ZOXIDE - Smart cd with frecency
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing zoxide..."

if ! command_exists zoxide; then
    cargo install zoxide
    log_success "zoxide installed"
else
    log_info "zoxide already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# ATUIN - SQLite history with sync
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing atuin..."

if ! command_exists atuin; then
    curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
    log_success "atuin installed"
else
    log_info "atuin already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# UV - Fast Python package manager
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing uv..."

if ! command_exists uv; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add to PATH for current session
    if [ -f "$HOME/.cargo/env" ]; then
        . "$HOME/.cargo/env"
    fi
    log_success "uv installed"
else
    log_info "uv already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# BUN - Fast JavaScript runtime
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing bun..."

if ! command_exists bun; then
    curl -fsSL https://bun.sh/install | bash
    # Add to PATH for current session
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    log_success "bun installed"
else
    log_info "bun already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# WATCHEXEC - File watcher
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing watchexec..."

if ! command_exists watchexec; then
    cargo install watchexec
    log_success "watchexec installed"
else
    log_info "watchexec already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# GLOW - Markdown renderer
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing glow..."

if ! command_exists glow; then
    # Download latest binary
    GLOW_VERSION=$(curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
    curl -sL "https://github.com/charmbracelet/glow/releases/download/${GLOW_VERSION}/glow_${GLOW_VERSION#v}_linux_amd64.tar.gz" | tar xz -C /tmp
    sudo mv /tmp/glow /usr/local/bin/glow
    sudo chmod +x /usr/local/bin/glow
    log_success "glow installed"
else
    log_info "glow already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# BOTTOM - System monitor
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing bottom..."

if ! command_exists btm; then
    cargo install bottom
    log_success "bottom installed"
else
    log_info "bottom already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# HYPERFINE - Benchmarking tool
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing hyperfine..."

if ! command_exists hyperfine; then
    cargo install hyperfine
    log_success "hyperfine installed"
else
    log_info "hyperfine already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# UPDATE FISH CONFIG - Uncomment Layer 2 tools
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Updating Fish config..."

FISH_CONFIG="$HOME/.config/fish/config.fish"

if [ -f "$FISH_CONFIG" ]; then
    # Uncomment zoxide
    if grep -q "^# zoxide init fish | source" "$FISH_CONFIG" 2>/dev/null; then
        sed -i 's/^# zoxide init fish | source/zoxide init fish | source/' "$FISH_CONFIG"
        log_success "zoxide enabled in Fish config"
    fi

    # Uncomment atuin
    if grep -q "^# atuin init fish" "$FISH_CONFIG" 2>/dev/null; then
        sed -i 's/^# atuin init fish --disable-up-arrow | source/atuin init fish --disable-up-arrow | source/' "$FISH_CONFIG"
        log_success "atuin enabled in Fish config"
    fi

    # Uncomment fzf
    if grep -q "^# fzf --fish" "$FISH_CONFIG" 2>/dev/null; then
        sed -i 's/^# fzf --fish | source/fzf --fish | source/' "$FISH_CONFIG"
        log_success "fzf enabled in Fish config"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# VERIFICATION
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  VERIFICATION"
echo "════════════════════════════════════════════════════════════"
echo ""

TOOLS="fzf zoxide atuin uv bun watchexec glow btm hyperfine"
INSTALLED=0
MISSING=0

for tool in $TOOLS; do
    if command_exists "$tool"; then
        version=$($tool --version 2>/dev/null | head -1 || echo "installed")
        echo "✅ $tool: $version"
        ((INSTALLED++))
    else
        echo "❌ $tool: NOT INSTALLED"
        ((MISSING++))
    fi
done

echo ""
echo "Installed: $INSTALLED/9"

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
if [ $MISSING -eq 0 ]; then
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  LAYER 2 COMPLETE!                                         ${NC}"
    echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Restart terminal or run: exec fish"
    echo "2. Run Layer 3: ./scripts/install-layer-3.sh"
else
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  LAYER 2 PARTIALLY COMPLETE                                ${NC}"
    echo -e "${YELLOW}════════════════════════════════════════════════════════════${NC}"
    echo ""
    echo "Missing tools: $MISSING"
    echo "Try running the script again or install manually."
fi
