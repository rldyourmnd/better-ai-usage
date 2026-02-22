#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# LAYER 5: AI ORCHESTRATION
# ═══════════════════════════════════════════════════════════════════════════════
# Installs: Claude Code, Gemini CLI, Codex CLI
# Platform: Linux (Ubuntu/Debian)
# Run: ./scripts/install-layer-5.sh
#
# Versions (February 2026):
# - Claude Code: npm @anthropic-ai/claude-code
# - Gemini CLI: npm @anthropic-ai/claude-code (gemini -p "prompt")
# - Codex CLI: npm @openai/codex

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
echo "  LAYER 5: AI ORCHESTRATION"
echo "  Claude Code, Gemini CLI, Codex CLI"
echo "════════════════════════════════════════════════════════════"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# PREFLIGHT CHECKS
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Running preflight checks..."

# Check for npm/node
if ! command_exists npm; then
    log_warn "npm not found. Installing nodejs..."
    if sudo -n true 2>/dev/null; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt install -y nodejs
    else
        log_error "npm requires sudo. Run manually:"
        echo "  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
        echo "  sudo apt install -y nodejs"
        exit 1
    fi
fi

log_success "Preflight checks passed"
log_info "Node.js version: $(node --version 2>/dev/null || echo 'unknown')"
log_info "npm version: $(npm --version 2>/dev/null || echo 'unknown')"

# ═══════════════════════════════════════════════════════════════════════════════
# CLAUDE CODE - Anthropic AI CLI
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Claude Code..."

if ! command_exists claude; then
    npm install -g @anthropic-ai/claude-code
    log_success "Claude Code installed"
else
    log_info "Claude Code already installed: $(claude --version 2>/dev/null | head -1 || echo 'installed')"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# GEMINI CLI - Google AI CLI
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Gemini CLI..."

if ! command_exists gemini; then
    npm install -g @google/gemini-cli
    log_success "Gemini CLI installed"
else
    log_info "Gemini CLI already installed: $(gemini --version 2>/dev/null | head -1 || echo 'installed')"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# CODEX CLI - OpenAI AI CLI
# ═══════════════════════════════════════════════════════════════════════════════
log_info "Installing Codex CLI..."

if ! command_exists codex; then
    npm install -g @openai/codex
    log_success "Codex CLI installed"
else
    log_info "Codex CLI already installed: $(codex --version 2>/dev/null | head -1 || echo 'installed')"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# VERIFICATION
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  VERIFICATION"
echo "════════════════════════════════════════════════════════════"
echo ""

# Verify Claude Code
if command_exists claude; then
    echo "✅ Claude Code: $(claude --version 2>/dev/null | head -1 || echo 'installed')"
else
    echo "❌ Claude Code: NOT INSTALLED"
fi

# Verify Gemini CLI
if command_exists gemini; then
    echo "✅ Gemini CLI: $(gemini --version 2>/dev/null | head -1 || echo 'installed')"
else
    echo "❌ Gemini CLI: NOT INSTALLED"
fi

# Verify Codex CLI
if command_exists codex; then
    echo "✅ Codex CLI: $(codex --version 2>/dev/null | head -1 || echo 'installed')"
else
    echo "❌ Codex CLI: NOT INSTALLED"
fi

# ═══════════════════════════════════════════════════════════════════════════════
# AUTHENTICATION INFO
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  AUTHENTICATION SETUP"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Claude Code:"
echo "  Run: claude"
echo "  Browser authentication will open automatically"
echo ""
echo "Gemini CLI:"
echo "  Option 1 - Google OAuth (Free tier included):"
echo "    Run: gemini"
echo "    Select 'Login with Google'"
echo ""
echo "  Option 2 - API Key:"
echo "    export GEMINI_API_KEY=\"your-key-from-aistudio.google.com/apikey\""
echo "    Run: gemini"
echo ""
echo "Codex CLI:"
echo "  export OPENAI_API_KEY=\"your-key-from-platform.openai.com\""
echo "  Run: codex"
echo ""

# ═══════════════════════════════════════════════════════════════════════════════
# COMPLETE
# ═══════════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  LAYER 5 COMPLETE!                                         ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "All 5 layers installed! Your Ultimate AI Terminal Environment is ready."
echo ""
echo "Quick start:"
echo "  claude     - Start Claude Code"
echo "  gemini     - Start Gemini CLI"
echo "  codex      - Start Codex CLI"
echo ""
