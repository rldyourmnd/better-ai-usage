#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# BETTER TERMINAL USAGE - Complete Installation Script
# ╀═════════════════════════════════════════════════════════════════════════════
# Orchestrates all installation layers and foundation setup.
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

# Resolve project root so script works from any current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

command_exists() { command -v "$1" &>/dev/null; }

run_step() {
    local script_path="$1"
    local name

    name="$(basename "$script_path")"
    if [ ! -x "$script_path" ]; then
        log_error "Script missing or not executable: $script_path"
        return 1
    fi

    log_info "Running ${name}..."
    "$script_path"
    log_success "${name} complete"
}

log_info "Running preflight checks..."

for cmd in curl git; do
    if ! command_exists "$cmd"; then
        log_error "$cmd is required but not installed"
        exit 1
    fi

done

log_success "Preflight checks passed"
log_info "Starting full installation pipeline"

run_step "$PROJECT_DIR/scripts/install-foundation.sh"
run_step "$PROJECT_DIR/scripts/install-layer-1.sh"
run_step "$PROJECT_DIR/scripts/install-layer-2.sh"
run_step "$PROJECT_DIR/scripts/install-layer-3.sh"
run_step "$PROJECT_DIR/scripts/install-layer-4.sh"
run_step "$PROJECT_DIR/scripts/install-layer-5.sh"

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ALL 5 LAYERS + FOUNDATION COMPLETE!                        ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Layers installed:"
echo "  Foundation: WezTerm + Fish + Starship"
echo "  Layer 1:    bat, fd, rg, sd, jq, yq, eza"
echo "  Layer 2:    fzf, zoxide, atuin, uv, bun, watchexec, glow, bottom, hyperfine"
echo "  Layer 3:    gh CLI, lazygit, delta"
echo "  Layer 4:    grepai, ast-grep, probe, semgrep, ctags, tokei"
echo "  Layer 5:    Claude Code, Gemini CLI, Codex CLI"
echo ""
echo "Next steps:"
echo "1. Log out and back in (or reboot) to activate Fish as default shell"
echo "2. Initialize grepai: grepai init"
echo "3. Login to GitHub CLI: gh auth login"
echo "4. Login to Atuin (optional): atuin login"
echo "5. Authenticate AI CLIs:"
echo "   - claude (browser auth opens automatically)"
echo "   - gemini (select 'Login with Google')"
echo "   - codex (export OPENAI_API_KEY='your-key')"
echo ""
echo "Enjoy your Ultimate AI Terminal Environment!"
