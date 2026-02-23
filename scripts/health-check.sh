#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# HEALTH CHECK
# ═══════════════════════════════════════════════════════════════════════════════
# Runs a full pre-flight and runtime validation for the Better Terminal Usage repo.
# Run: ./scripts/health-check.sh
# Run summary only: ./scripts/health-check.sh --summary
# Run strict mode: ./scripts/health-check.sh --strict

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SUMMARY_MODE=false
STRICT_MODE=false
VERBOSE=true
FAILURES=0
WARNINGS=0
PASSED=0

for arg in "$@"; do
    case "$arg" in
        --summary)
            SUMMARY_MODE=true
            ;;
        --strict)
            STRICT_MODE=true
            ;;
        --help|-h)
            echo "Usage: $0 [--summary] [--strict]"
            echo "  --summary  show only summary counters"
            echo "  --strict   fail on config drift; useful for clean CI-like enforcement"
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Usage: $0 [--summary] [--strict]"
            exit 1
            ;;
    esac
done

if [[ "$SUMMARY_MODE" == true ]]; then
    VERBOSE=false
fi

log_ok() {
    ((PASSED += 1))
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${GREEN}[OK]${NC} $1"
    fi
    return 0
}

log_warn() {
    ((WARNINGS += 1))
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${YELLOW}[WARN]${NC} $1"
    fi
    return 0
}

log_fail() {
    ((FAILURES += 1))
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${RED}[FAIL]${NC} $1"
    fi
    return 0
}

if [[ "$VERBOSE" == true ]]; then
    log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
    log_banner_if_needed() { log_banner; }
else
    log_info() { :; }
    log_banner_if_needed() { :; }
fi

log_banner() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  BETTER TERMINAL USAGE - HEALTH CHECK"
    echo "  $(date -Iseconds)"
    echo "════════════════════════════════════════════════════════════"
}

command_exists() { command -v "$1" >/dev/null 2>&1; }

run_bash_syntax() {
    log_info "Checking bash script syntax..."
    local failed=false
    while IFS= read -r -d '' script; do
        if bash -n "$script"; then
            log_ok "bash -n $script"
        else
            failed=true
            log_fail "bash -n $script"
        fi
    done < <(find "$PROJECT_DIR/scripts" -name "*.sh" -print0 | sort -z)
    if [[ "$failed" == true ]]; then
        log_warn "Bash syntax check found issues in one or more scripts"
    fi
}

run_fish_syntax() {
    log_info "Checking Fish configuration syntax..."
    if command_exists fish; then
        if fish -n "$PROJECT_DIR/configs/fish/config.fish"; then
            log_ok "fish -n configs/fish/config.fish"
        else
            log_fail "fish -n configs/fish/config.fish"
        fi
    else
        log_warn "fish command is not available for validation"
    fi
}

check_file_presence() {
    local target="$1"
    local label="$2"
    if [[ -f "$target" ]]; then
        log_ok "$label exists: $target"
    else
        log_fail "$label missing: $target"
    fi
}

check_dir_presence() {
    local target="$1"
    local label="$2"
    if [[ -d "$target" ]]; then
        log_ok "$label exists: $target"
    else
        log_fail "$label missing: $target"
    fi
}

check_executable() {
    local target="$1"
    local label="$2"
    if [[ -x "$target" ]]; then
        log_ok "$label executable: $target"
    else
        log_fail "$label not executable: $target"
    fi
}

check_config_parity() {
    local local_file="$1"
    local repo_file="$2"
    local label="$3"

    if [[ ! -f "$local_file" ]]; then
        if [[ "$STRICT_MODE" == true ]]; then
            log_fail "$label missing locally: $local_file"
        else
            log_warn "$label missing locally: $local_file"
        fi
        return
    fi
    if [[ ! -f "$repo_file" ]]; then
        if [[ "$STRICT_MODE" == true ]]; then
            log_fail "$label missing in repo: $repo_file"
        else
            log_warn "$label missing in repo: $repo_file"
        fi
        return
    fi

    if cmp --silent "$local_file" "$repo_file"; then
        log_ok "$label parity: OK"
    else
        if [[ "$STRICT_MODE" == true ]]; then
            log_fail "$label parity: mismatch"
        else
            log_warn "$label parity: mismatch (use --strict for enforcement)"
        fi
    fi
}

check_version_or_status() {
    local name="$1"
    local cmd="$2"
    local note="$3"

    if ! command_exists "$name"; then
        log_fail "$name missing from PATH"
        return
    fi

    local output
    set +e
    output=$(eval "$cmd" 2>&1)
    local status=$?
    set -e

    if [[ $status -eq 0 && -n "$output" ]]; then
        log_ok "$name: ${output%%$'\n'*}"
    elif [[ $status -eq 0 ]]; then
        log_warn "$name: present (no version output) - $note"
    else
        log_warn "$name: present but command returned non-zero (status ${status}) - $note"
    fi
}

check_semgrep_runtime() {
    if ! command_exists semgrep; then
        log_warn "semgrep missing"
        return
    fi

    local output status
    set +e
    output=$(semgrep --version 2>&1)
    status=$?
    set -e

    if [[ $status -ne 0 ]]; then
        if grep -q "PermissionError" <<<"$output"; then
            log_warn "semgrep --version fails due local log permission issue: PermissionError at ~/.semgrep/semgrep.log"
            if [[ -f "$HOME/.semgrep/semgrep.log" ]]; then
                if [[ -w "$HOME/.semgrep/semgrep.log" ]]; then
                    log_info "semgrep log is writable, re-run check after fresh shell"
                else
                    log_warn "semgrep log is not writable by current user"
                fi
            else
                log_info "semgrep log file not created yet"
            fi
        else
            log_warn "semgrep --version returned status ${status}"
        fi
    else
        log_ok "semgrep: ${output%%$'\n'*}"
    fi
}

check_gemini_runtime() {
    if ! command_exists gemini; then
        log_warn "gemini command not found"
        return
    fi

    local output status
    set +e
    output=$(timeout 4s gemini --help 2>&1)
    status=$?
    set -e

    if [[ $status -eq 124 ]]; then
        log_warn "gemini command did not return within 4s (likely interactive init/credential flow)"
    elif [[ $status -eq 0 && -n "$output" ]]; then
        log_ok "gemini responded"
    else
        log_warn "gemini returned status ${status}"
    fi
}

check_local_path_health() {
    log_info "Checking ~/.local/bin path..."
    if [[ -d "$HOME/.local/bin" ]]; then
        log_ok "~/.local/bin exists"
    else
        log_warn "~/.local/bin does not exist"
    fi

    if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
        log_ok "~/.local/bin is in PATH"
    else
        log_warn "~/.local/bin is not in PATH"
    fi
}

print_summary() {
    echo ""
    echo "════════════════════════════════════════════════════════════"
    echo "  Health Check Summary"
    echo "  Passed:  $PASSED"
    echo "  Warnings:$WARNINGS"
    echo "  Failures:$FAILURES"
    echo "════════════════════════════════════════════════════════════"

    if [[ $FAILURES -eq 0 ]]; then
        echo "Health status: PASS (with ${WARNINGS} warnings)"
    else
        echo "Health status: FAIL (fix ${FAILURES} hard failures)"
    fi
}

log_banner_if_needed

run_bash_syntax
run_fish_syntax

log_info "Checking required files and permissions..."
for script in \
    "$PROJECT_DIR/scripts/install.sh" \
    "$PROJECT_DIR/scripts/install-foundation.sh" \
    "$PROJECT_DIR/scripts/install-layer-1.sh" \
    "$PROJECT_DIR/scripts/install-layer-2.sh" \
    "$PROJECT_DIR/scripts/install-layer-3.sh" \
    "$PROJECT_DIR/scripts/install-layer-4.sh" \
    "$PROJECT_DIR/scripts/install-layer-5.sh" \
    "$PROJECT_DIR/scripts/health-check.sh"; do
    check_file_presence "$script" "$script"
    check_executable "$script" "$script"
done

check_config_parity "$HOME/.wezterm.lua" "$PROJECT_DIR/configs/wezterm/wezterm.lua" "WezTerm"
check_config_parity "$HOME/.config/fish/config.fish" "$PROJECT_DIR/configs/fish/config.fish" "Fish"
check_config_parity "$HOME/.config/starship.toml" "$PROJECT_DIR/configs/starship/starship.toml" "Starship"

check_local_path_health

log_info "Checking installed toolchain..."
check_version_or_status "wezterm" "wezterm --version | head -1" "open command output"
check_version_or_status "fish" "fish --version | head -1" "expected 'fish, version X.Y.Z'"
check_version_or_status "starship" "starship --version | head -1" "expected 'starship X.Y.Z'"
check_version_or_status "bat" "bat --version | head -1" "expected installed semantic"
check_version_or_status "fdfind" "fdfind --version | head -1" "apt path may expose as fdfind"
check_version_or_status "rg" "rg --version | head -1" "expected 'ripgrep X'"
check_version_or_status "sd" "sd --version" "expected 'sd X.X.X'"
check_version_or_status "jq" "jq --version" "expected 'jq-X.X.X'"
check_version_or_status "yq" "yq --version | head -1" "expected 'yq version X'"
check_version_or_status "eza" "eza --version | head -1" "expects package output"
check_version_or_status "fzf" "fzf --version | head -1" "expected 'X.Y.Z'"
check_version_or_status "glow" "glow --version" "expected glow markdown renderer version"
check_version_or_status "zoxide" "zoxide --version | head -1" "expected 'zoxide X.X.X'"
check_version_or_status "atuin" "atuin --version | head -1" "expected installed CLI version"
check_version_or_status "uv" "uv --version | head -1" "expected 'uv X.X.X'"
check_version_or_status "bun" "bun --version" "expected 'bun X.X.X'"
check_version_or_status "watchexec" "watchexec --version | head -1" "expected installed runtime"
check_version_or_status "btm" "btm --version | head -1" "expected 'bottom X.X.X'"
check_version_or_status "hyperfine" "hyperfine --version | head -1" "expected 'hyperfine X.X.X'"
check_version_or_status "gh" "gh --version | head -1" "expected 'gh version X.X.X'"
check_version_or_status "lazygit" "lazygit --version 2>/dev/null | head -1" "expected build metadata"
check_version_or_status "delta" "delta --version | head -1" "expected 'delta X.X.X'"
check_version_or_status "grepai" "grepai version" "expected 'grepai version X.X.X'"
check_version_or_status "probe" "probe --version | head -1" "expected 'probe-code X'"
check_version_or_status "sg" "sg --version | head -1" "expected 'ast-grep X.X.X'"
check_version_or_status "tokei" "tokei --version | head -1" "expected 'tokei X.X.X'"
check_version_or_status "ctags" "ctags --version | head -1" "ctags binary version"
check_version_or_status "node" "node --version | head -1" "expected 'vX.X.X'"
check_version_or_status "npm" "npm --version | head -1" "expected NPM version"
check_version_or_status "claude" "claude --version | head -1" "expected Claude CLI version"
check_version_or_status "codex" "codex --version | head -1" "expected codex cli version"

check_semgrep_runtime
check_gemini_runtime

check_dir_presence "$HOME/.local/bin" ".local/bin directory"

print_summary

if [[ $FAILURES -gt 0 ]]; then
    exit 1
fi
