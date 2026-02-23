#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════════
# HEALTH CHECK
# ═══════════════════════════════════════════════════════════════════════════════
# Runs a full pre-flight and runtime validation for the Awesome Terminal for AI repo.
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
OS_NAME="$(uname -s)"
command_exists() { command -v "$1" >/dev/null 2>&1; }

to_windows_path_if_needed() {
    local input_path="$1"
    if command_exists cygpath; then
        cygpath -w "$input_path"
    else
        echo "$input_path"
    fi
}

if [[ "$OS_NAME" == "Darwin" ]]; then
    if [[ -x "$PROJECT_DIR/scripts/macos/health-check.sh" ]]; then
        exec "$PROJECT_DIR/scripts/macos/health-check.sh" "$@"
    fi
    echo "macOS health-check script not found: $PROJECT_DIR/scripts/macos/health-check.sh"
    exit 1
fi

case "$OS_NAME" in
    MINGW*|MSYS*|CYGWIN*)
        if [[ -f "$PROJECT_DIR/scripts/health-check-windows.ps1" ]]; then
            WINDOWS_SCRIPT_PATH="$(to_windows_path_if_needed "$PROJECT_DIR/scripts/health-check-windows.ps1")"
            PS_ARGS=()
            for arg in "$@"; do
                case "$arg" in
                    --summary)
                        PS_ARGS+=("-Summary")
                        ;;
                    --strict)
                        PS_ARGS+=("-Strict")
                        ;;
                    --help|-h)
                        PS_ARGS+=("-Help")
                        ;;
                    *)
                        PS_ARGS+=("$arg")
                        ;;
                esac
            done
            if command_exists pwsh; then
                exec pwsh -NoProfile -ExecutionPolicy Bypass -File "$WINDOWS_SCRIPT_PATH" "${PS_ARGS[@]}"
            fi
            if command_exists powershell.exe; then
                exec powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WINDOWS_SCRIPT_PATH" "${PS_ARGS[@]}"
            fi
            echo "Neither pwsh nor powershell.exe found for Windows health-check."
            exit 1
        fi
        echo "Windows health-check script not found: $PROJECT_DIR/scripts/health-check-windows.ps1"
        exit 1
        ;;
esac

if [[ "$OS_NAME" != "Linux" ]]; then
    echo "Unsupported OS for this health-check: $OS_NAME"
    exit 1
fi

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
    echo "  AWESOME TERMINAL FOR AI - HEALTH CHECK"
    echo "  $(date -Iseconds)"
    echo "════════════════════════════════════════════════════════════"
}

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
    local note="$2"
    shift 2

    if ! command_exists "$name"; then
        log_fail "$name missing from PATH"
        return
    fi

    local output
    local status=0
    set +e
    output=$("$@" 2>&1)
    status=$?
    set -e

    if [[ $status -eq 0 && -n "$output" ]]; then
        log_ok "$name: ${output%%$'\n'*}"
    elif [[ $status -eq 0 ]]; then
        log_warn "$name: present (no version output) - $note"
    else
        log_warn "$name: present but command returned non-zero (status ${status}) - $note"
    fi
}

check_first_available_version() {
    local primary="$1"
    local fallback="$2"
    local note="$3"
    shift 3

    if command_exists "$primary"; then
        check_version_or_status "$primary" "$note" "$primary" "$@"
        return
    fi

    if command_exists "$fallback"; then
        check_version_or_status "$fallback" "$note" "$fallback" "$@"
        return
    fi

    log_fail "$primary/$fallback missing from PATH"
}

check_ast_grep_runtime() {
    local output status

    if command_exists sg; then
        set +e
        output=$(sg --version 2>&1)
        status=$?
        set -e
        if [[ $status -eq 0 && "$output" =~ ast-grep|ast_grep ]]; then
            log_ok "ast-grep: ${output%%$'\n'*}"
            return
        fi
    fi

    if [[ -x "$HOME/.cargo/bin/sg" ]]; then
        set +e
        output=$("$HOME/.cargo/bin/sg" --version 2>&1)
        status=$?
        set -e
        if [[ $status -eq 0 && "$output" =~ ast-grep|ast_grep ]]; then
            log_ok "ast-grep (~/.cargo/bin/sg): ${output%%$'\n'*}"
            return
        fi
    fi

    log_fail "ast-grep missing or 'sg' points to non ast-grep binary"
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

check_terminal_runtime_logs() {
    if ! command_exists journalctl; then
        log_warn "journalctl command not found; skipping runtime log diagnostics"
        return
    fi

    if ! command_exists rg; then
        log_warn "rg command not found; skipping runtime log diagnostics"
        return
    fi

    local since_window="20 minutes ago"
    local user_logs status

    set +e
    user_logs=$(journalctl --user -b --since "$since_window" --no-pager 2>/dev/null)
    status=$?
    set -e

    if [[ $status -ne 0 ]]; then
        log_warn "Unable to read user journal for runtime diagnostics"
        return
    fi

    if [[ -z "$user_logs" ]]; then
        log_warn "User journal returned no entries for runtime diagnostics window"
        return
    fi

    local gnome_patterns='Error in size change accounting|Frame has assigned frame counter but no frame drawn time|MetaShapedTexture|needs an allocation'
    local wezterm_patterns='while processing update-status event: runtime error|wezterm_mux_server_impl::local > writing pdu data buffer: Broken pipe'
    local gnome_hits wezterm_hits

    gnome_hits=$(rg -n "$gnome_patterns" <<<"$user_logs" | tail -n 12 || true)
    wezterm_hits=$(rg -n "$wezterm_patterns" <<<"$user_logs" | tail -n 12 || true)

    if [[ -n "$gnome_hits" ]]; then
        log_warn "GNOME compositor freeze signatures detected in recent user journal"
        if [[ "$VERBOSE" == true ]]; then
            echo "$gnome_hits" | sed 's/^/      /'
            echo "      Suggestion: WEZTERM_MINIMAL_UI=1 WEZTERM_FORCE_WAYLAND=1 wezterm start --always-new-process"
        fi
    else
        log_ok "No GNOME compositor freeze signatures in recent user journal"
    fi

    if [[ -n "$wezterm_hits" ]]; then
        log_warn "WezTerm runtime warning signatures detected in recent user journal"
        if [[ "$VERBOSE" == true ]]; then
            echo "$wezterm_hits" | sed 's/^/      /'
            echo "      Suggestion: WEZTERM_SAFE_RENDERER=1 wezterm start --always-new-process"
        fi
    else
        log_ok "No WezTerm runtime warning signatures in recent user journal"
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
    "$PROJECT_DIR/scripts/publish-wiki.sh" \
    "$PROJECT_DIR/scripts/linux/install-foundation.sh" \
    "$PROJECT_DIR/scripts/linux/install-layer-1.sh" \
    "$PROJECT_DIR/scripts/linux/install-layer-2.sh" \
    "$PROJECT_DIR/scripts/linux/install-layer-3.sh" \
    "$PROJECT_DIR/scripts/linux/install-layer-4.sh" \
    "$PROJECT_DIR/scripts/linux/install-layer-5.sh" \
    "$PROJECT_DIR/scripts/linux/install-nerd-fonts.sh" \
    "$PROJECT_DIR/scripts/health-check.sh"; do
    check_file_presence "$script" "$script"
    check_executable "$script" "$script"
done

check_config_parity "$HOME/.wezterm.lua" "$PROJECT_DIR/configs/wezterm/wezterm.lua" "WezTerm"
check_config_parity "$HOME/.config/fish/config.fish" "$PROJECT_DIR/configs/fish/config.fish" "Fish"
check_config_parity "$HOME/.config/starship.toml" "$PROJECT_DIR/configs/starship/starship.toml" "Starship"

check_local_path_health

log_info "Checking installed toolchain..."
check_version_or_status "wezterm" "open command output" wezterm --version
check_version_or_status "fish" "expected 'fish, version X.Y.Z'" fish --version
check_version_or_status "starship" "expected 'starship X.Y.Z'" starship --version
check_first_available_version "bat" "batcat" "expected installed semantic" --version
check_first_available_version "fd" "fdfind" "fd may be provided by apt as fdfind" --version
check_version_or_status "rg" "expected 'ripgrep X'" rg --version
check_version_or_status "sd" "expected 'sd X.X.X'" sd --version
check_version_or_status "jq" "expected 'jq-X.X.X'" jq --version
check_version_or_status "yq" "expected 'yq version X'" yq --version
check_version_or_status "eza" "expects package output" eza --version
check_version_or_status "fzf" "expected 'X.Y.Z'" fzf --version
check_version_or_status "glow" "expected glow markdown renderer version" glow --version
check_version_or_status "zoxide" "expected 'zoxide X.X.X'" zoxide --version
check_version_or_status "atuin" "expected installed CLI version" atuin --version
check_version_or_status "uv" "expected 'uv X.X.X'" uv --version
check_version_or_status "bun" "expected 'bun X.X.X'" bun --version
check_version_or_status "watchexec" "expected installed runtime" watchexec --version
check_version_or_status "btm" "expected 'bottom X.X.X'" btm --version
check_version_or_status "hyperfine" "expected 'hyperfine X.X.X'" hyperfine --version
check_version_or_status "gh" "expected 'gh version X.X.X'" gh --version
check_version_or_status "lazygit" "expected build metadata" lazygit --version
check_version_or_status "delta" "expected 'delta X.X.X'" delta --version
check_version_or_status "grepai" "expected 'grepai version X.X.X'" grepai version
check_version_or_status "probe" "expected 'probe-code X'" probe --version
check_ast_grep_runtime
check_version_or_status "tokei" "expected 'tokei X.X.X'" tokei --version
check_version_or_status "ctags" "ctags binary version" ctags --version
check_version_or_status "node" "expected 'vX.X.X'" node --version
check_version_or_status "npm" "expected NPM version" npm --version
check_version_or_status "claude" "expected Claude CLI version" claude --version
check_version_or_status "codex" "expected codex cli version" codex --version

check_semgrep_runtime
check_gemini_runtime
check_terminal_runtime_logs

check_dir_presence "$HOME/.local/bin" ".local/bin directory"

print_summary

if [[ $FAILURES -gt 0 ]]; then
    exit 1
fi
