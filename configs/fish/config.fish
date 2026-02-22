# ═══════════════════════════════════════════════════════════════════════════════
# FISH CONFIGURATION - Ultimate AI Terminal Environment
# ═══════════════════════════════════════════════════════════════════════════════
# Priority: Stability > AI CLI compatibility > speed

# ═══════════════════════════════════════════════════════════════════════════════
# PATH SETUP - Deterministic and shell-local (global scope, no universal drift)
# ═══════════════════════════════════════════════════════════════════════════════
set -l __path_candidates \
    ~/.local/bin \
    ~/.claude/local/bin \
    ~/.atuin/bin \
    ~/.cargo/bin \
    ~/.bun/bin \
    ~/.local/share/pnpm \
    /usr/local/go/bin \
    /home/linuxbrew/.linuxbrew/bin \
    /home/linuxbrew/.linuxbrew/sbin \
    ~/.pulumi/bin \
    ~/Android/Sdk/emulator \
    ~/Android/Sdk/platform-tools \
    ~/.local/share/pipx

for path in $__path_candidates
    if test -d $path
        fish_add_path -g $path
    end
end
set -e __path_candidates

# Python venvs (conditional - only add if exists)
if test -d ~/.local/venvs/ai-ml/bin
    fish_add_path -g ~/.local/venvs/ai-ml/bin
end
if test -d ~/.local/venvs/vllm/bin
    fish_add_path -g ~/.local/venvs/vllm/bin
end

# Node (nvm): prefer explicit default alias, normalize "24.13.1" -> "v24.13.1".
if test -d ~/.nvm/versions/node
    set -l nvm_default ""
    if test -f ~/.nvm/alias/default
        set nvm_default (string trim -- (cat ~/.nvm/alias/default))
    end

    if test -n "$nvm_default"; and not string match -rq '^v' -- $nvm_default
        set nvm_default "v$nvm_default"
    end

    if test -n "$nvm_default"; and test -d ~/.nvm/versions/node/$nvm_default/bin
        fish_add_path -g ~/.nvm/versions/node/$nvm_default/bin
    else
        set -l node_version (ls -1 ~/.nvm/versions/node 2>/dev/null | sort -V | tail -1)
        if test -n "$node_version"; and test -d ~/.nvm/versions/node/$node_version/bin
            fish_add_path -g ~/.nvm/versions/node/$node_version/bin
        end
    end
end

# Remove duplicated PATH entries inherited from parent environment (e.g. /snap/bin).
set -l __path_dedup
for path in $PATH
    if not contains -- $path $__path_dedup
        set -a __path_dedup $path
    end
end
set -gx PATH $__path_dedup
set -e __path_dedup

# ═══════════════════════════════════════════════════════════════════════════════
# TOOL INITIALIZATION - Conditional sourcing for stability
# ═══════════════════════════════════════════════════════════════════════════════
# Starship prompt (fastest prompt, Rust-based)
if type -q starship
    starship init fish | source
    # Transient prompt - cleaner scrollback (optional, uncomment if desired)
    # function starship_transient_prompt_func
    #     starship module character
    # end
    # enable_transience
end

# Zoxide (smart cd) - 2.9ms
if type -q zoxide
    zoxide init fish | source
end

# Atuin (history sync) - 5.2ms
if type -q atuin
    atuin init fish --disable-up-arrow | source
end

# FZF (fuzzy finder) - 2.5ms
if type -q fzf
    fzf --fish | source
end

# ═══════════════════════════════════════════════════════════════════════════════
# ENVIRONMENT VARIABLES
# ═══════════════════════════════════════════════════════════════════════════════
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER bat

# FZF configuration
set -gx FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=1 {}'"

# ═══════════════════════════════════════════════════════════════════════════════
# ABBREVIATIONS - Navigation
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a z 'zoxide'
abbr -a zz 'z -'
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a .... 'cd ../../..'

# ═══════════════════════════════════════════════════════════════════════════════
# ABBREVIATIONS - File operations
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a ls 'eza'
abbr -a ll 'eza -la'
abbr -a lt 'eza --tree --level=2'
abbr -a cat 'bat'

# ═══════════════════════════════════════════════════════════════════════════════
# System monitoring
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a bottom 'btm'

# ═════════════════════════════════════════════════════════════════════════════
# Git
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git log --oneline -10'
abbr -a gd 'git diff'
abbr -a lg 'lazygit'

# ═══════════════════════════════════════════════════════════════════════════════
# GitHub CLI
# ═══════════════════════════════════════════════════════════════════════════════
abbr -a gh 'gh'
abbr -a ghp 'gh pr'
abbr -a ghi 'gh issue'
abbr -a ghr 'gh repo'

# ═══════════════════════════════════════════════════════════════════════════════
# Python
# ═════════════════════════════════════════════════════════════════════════════
abbr -a py 'python3'
abbr -a pip 'uv pip'
abbr -a venv 'uv venv'

# ═══════════════════════════════════════════════════════════════════════════════
# Development
# ═════════════════════════════════════════════════════════════════════════════════
abbr -a nv 'nvim'
abbr -a code 'code .'

# ═══════════════════════════════════════════════════════════════════════════════
# AI Tools (Layer 5 - User-provided CLIs)
# ═════════════════════════════════════════════════════════════════════════════
# Claude - skip permission prompts for faster workflow
abbr -a cl 'claude --dangerously-skip-permissions'
# Gemini - auto-approve mode for non-interactive use
abbr -a gem 'gemini --yolo'
# Codex - full auto mode for autonomous execution
abbr -a cx 'codex --full-auto'

# ═════════════════════════════════════════════════════════════════════════════
# FUNCTIONS
# ═════════════════════════════════════════════════════════════════════════════
function proj
    cd ~/projects/$argv[1]
end

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function backup
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

function ducks
    du -sh * | sort -h
end

function ff
    fd -H $argv
end

function gg
    rg -i $argv
end

# ═════════════════════════════════════════════════════════════════════════════════
# STARTUP
# ═══════════════════════════════════════════════════════════════════════════════
set fish_greeting
