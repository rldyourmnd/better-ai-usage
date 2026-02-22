#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# FOUNDATION LAYER INSTALLATION
# ═══════════════════════════════════════════════════════════════════════════════
# Installs: WezTerm, Fish, Starship
# Platform: Linux (Ubuntu/Debian)
# Run: ./scripts/install-foundation.sh

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

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  FOUNDATION LAYER INSTALLATION"
echo "  WezTerm + Fish + Starship"
echo "════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

for cmd in curl wget sudo; do
    if ! command_exists "$cmd"; then
        log_error "$cmd is required but not installed"
        exit 1
    fi
done

log_success "Preflight checks passed"

# ═══════════════════════════════════════════════════════════════════════════════
# WEZTERM
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing WezTerm..."

if ! command_exists wezterm; then
    # Add GPG key
    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-archive-keyring.gpg

    # Add repository
    echo "deb [signed-by=/usr/share/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *" | sudo tee /etc/apt/sources.list.d/wezterm.list

    # Install
    sudo apt update
    sudo apt install -y wezterm

    log_success "WezTerm installed"
else
    log_info "WezTerm already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# FISH
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Fish shell..."

if ! command_exists fish; then
    sudo apt install -y fish
    log_success "Fish installed"
else
    log_info "Fish already installed"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# STARSHIP
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Starship prompt..."

if ! command_exists starship; then
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
    log_warn "Nerd font installer script not found at $PROJECT_DIR/scripts/install-nerd-fonts.sh"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Applying configurations..."

# Create directories
mkdir -p ~/.config/fish
mkdir -p ~/.config
mkdir -p ~/.config/starship/profiles
mkdir -p ~/.local/bin

# Copy WezTerm config
if [ -f "$PROJECT_DIR/configs/wezterm/wezterm.lua" ]; then
    cp "$PROJECT_DIR/configs/wezterm/wezterm.lua" ~/.wezterm.lua
    log_success "WezTerm config applied"
else
    log_warn "WezTerm config not found at $PROJECT_DIR/configs/wezterm/wezterm.lua"
fi

# Copy Fish config
if [ -f "$PROJECT_DIR/configs/fish/config.fish" ]; then
    cp "$PROJECT_DIR/configs/fish/config.fish" ~/.config/fish/config.fish
    log_success "Fish config applied"
else
    log_warn "Fish config not found at $PROJECT_DIR/configs/fish/config.fish"
fi

# Copy Starship config
if [ -f "$PROJECT_DIR/configs/starship/starship.toml" ]; then
    # Validate no duplicate sections before copying
    DUPLICATES=$(awk '/^\[/{if(seen[$0]++)print}' "$PROJECT_DIR/configs/starship/starship.toml")
    if [ -n "$DUPLICATES" ]; then
        log_warn "Starship config has duplicate sections: $DUPLICATES"
        log_warn "Please fix the config file before proceeding"
    else
        cp "$PROJECT_DIR/configs/starship/starship.toml" ~/.config/starship.toml
        cp "$PROJECT_DIR"/configs/starship/profiles/*.toml ~/.config/starship/profiles/
        cp "$PROJECT_DIR/scripts/starship/switch-profile.sh" ~/.local/bin/starship-profile
        chmod +x ~/.local/bin/starship-profile
        log_success "Starship config applied (default + profiles + switcher)"
    fi
else
    log_warn "Starship config not found at $PROJECT_DIR/configs/starship/starship.toml"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# VERIFICATION
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  VERIFICATION"
echo "════════════════════════════════════════════════════════════"
echo ""

echo "WezTerm:   $(wezterm --version 2>/dev/null | head -1 || echo 'NOT FOUND')"
echo "Fish:     $(fish --version 2>/dev/null || echo 'NOT FOUND')"
echo "Starship: $(starship --version 2>/dev/null | head -1 || echo 'NOT FOUND')"
echo ""
echo "Configs:"
[ -f ~/.wezterm.lua ] && echo "  ✅ ~/.wezterm.lua" || echo "  ❌ ~/.wezterm.lua"
[ -f ~/.config/fish/config.fish ] && echo "  ✅ ~/.config/fish/config.fish" || echo "  ❌ ~/.config/fish/config.fish"
[ -f ~/.config/starship.toml ] && echo "  ✅ ~/.config/starship.toml" || echo "  ❌ ~/.config/starship.toml"

# Validate starship config
if command_exists starship && [ -f ~/.config/starship.toml ]; then
    if starship --version &>/dev/null; then
        echo "  ✅ Starship config is valid"
    else
        echo "  ⚠️  Starship config has errors - check ~/.config/starship.toml"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  FOUNDATION LAYER COMPLETE!                                ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "1. Restart terminal or run: exec fish"
echo "2. Run Layer 1: ./scripts/install-layer-1.sh"
echo ""
