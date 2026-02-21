<!-- Memory Metadata
Last updated: 2026-02-21
Last commit: dbba71c docs: add comprehensive context directory with research data
Scope: configs/wezterm/, configs/fish/, configs/starship/
Area: FRONTEND
-->

# Terminal and Shell Configuration

## Overview

Foundation layer configuration for GPU-accelerated terminal (WezTerm), modern shell (Fish), and minimal prompt (Starship). Combined, these achieve ~30ms shell startup and <5ms input latency.

## Architecture

Three independent components that integrate via shell initialization:

- **WezTerm**: Terminal emulator with WebGPU/Vulkan rendering (Score: 91.1)
- **Fish**: Shell with autosuggestions and ~30ms startup (Score: 94.5)
- **Starship**: Cross-shell prompt with <5ms rendering (Score: 80.8)

Integration flow: WezTerm launches Fish shell -> Fish initializes Starship -> Starship renders prompt

## Key Files

| File | Purpose | Target Location |
|------|---------|-----------------|
| `configs/wezterm/wezterm.lua` | WezTerm terminal configuration | `~/.wezterm.lua` |
| `configs/fish/config.fish` | Fish shell configuration | `~/.config/fish/config.fish` |
| `configs/starship/starship.toml` | Starship prompt configuration | `~/.config/starship.toml` |

---

## WezTerm Configuration

### GPU Rendering

```lua
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- Auto-select Vulkan discrete GPU (NVIDIA, AMD)
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
    config.webgpu_preferred_adapter = gpu
    break
  end
end
```

### Performance Settings

| Setting | Value | Purpose |
|---------|-------|---------|
| max_fps | 120 | Higher refresh rate |
| animation_fps | 1 | Disable animations |
| cursor_blink_rate | 0 | No blinking overhead |
| local_echo_threshold_ms | 10 | Predictive echo for minimal latency |

### Multiplexer Configuration

```lua
config.unix_domains = {
  {
    name = 'unix',
    socket_path = '/tmp/wezterm-gui-sock',
    local_echo_threshold_ms = 10,  -- CRITICAL for low latency
  },
}

-- Auto-connect on startup
config.default_gui_startup_args = { 'connect', 'unix' }
```

### Keybindings

| Shortcut | Action |
|----------|--------|
| Ctrl+Shift+\| | Split horizontal |
| Ctrl+Shift+_ | Split vertical |
| Ctrl+Shift+w | Close pane |
| Ctrl+Shift+h/j/k/l | Navigate panes (vim-style) |
| Ctrl+Shift+H/J/K/L | Resize panes |
| Ctrl+Shift+t | New tab |
| Ctrl+Tab / Ctrl+Shift+Tab | Next/Previous tab |
| Ctrl+Shift+f | Search |
| Ctrl+Shift+c/v | Copy/Paste |
| Ctrl+Shift+r | Reload config |

### Appearance

- **Font**: JetBrains Mono, 12.0pt, line_height 1.1
- **Color scheme**: Catppuccin Mocha
- **Decorations**: RESIZE mode only, no scroll bar
- **Padding**: 5px around window
- **Wayland**: Native support enabled

---

## Fish Configuration

### Initialization Order

```fish
# 1. Starship prompt (fastest, init first)
starship init fish | source

# 2. Zoxide (smart cd with frecency)
zoxide init fish | source

# 3. Atuin (SQLite history, up-arrow disabled)
atuin init fish --disable-up-arrow | source

# 4. fzf (fuzzy finder integration)
fzf --fish | source
```

### Environment Variables

```fish
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER bat

# FZF configuration
set -gx FZF_CTRL_T_OPTS "--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}'"
set -gx FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap"
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=1 {}'"
```

### Abbreviations

**Navigation:**
| Abbr | Command |
|------|---------|
| z | zoxide |
| zz | z - (previous directory) |
| .. | cd .. |
| ... | cd ../.. |
| .... | cd ../../.. |

**File Operations:**
| Abbr | Command |
|------|---------|
| ls | eza |
| ll | eza -la |
| lt | eza --tree --level=2 |
| cat | bat |

**Git:**
| Abbr | Command |
|------|---------|
| g | git |
| gs | git status |
| ga | git add |
| gc | git commit |
| gp | git push |
| gl | git log --oneline -10 |
| gd | git diff |
| lg | lazygit |

**GitHub CLI:**
| Abbr | Command |
|------|---------|
| gh | gh |
| ghp | gh pr |
| ghi | gh issue |
| ghr | gh repo |

**Python:**
| Abbr | Command |
|------|---------|
| py | python3 |
| pip | uv pip |
| venv | uv venv |

### Custom Functions

```fish
# Quick project jump
function proj
    cd ~/projects/$argv[1]
end

# Create directory and enter it
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# Quick backup
function backup
    cp $argv[1] $argv[1].bak.(date +%Y%m%d_%H%M%S)
end

# Disk usage sorted
function ducks
    du -sh * | sort -h
end

# Find file by name
function ff
    fd -H $argv
end

# Search in files (ripgrep)
function gg
    rg -i $argv
end
```

### Settings

- `fish_greeting`: Disabled (no startup message)
- `fish_autosuggestion_enabled`: 1 (default, enabled)

---

## Starship Configuration

### Format

```toml
# Left side: directory + git + character
format = "$directory$git_branch$git_status$character"

# Right side: duration + jobs
right_format = "$cmd_duration$jobs"
```

### Performance Settings

```toml
scan_timeout = 10      # 10ms scan timeout
command_timeout = 100  # 100ms command timeout
```

### Directory Module

```toml
[directory]
truncate_to_repo = true
truncation_length = 3
style = "bold blue"
read_only = " 🔒"
```

### Git Modules

```toml
[git_branch]
symbol = ""
style = "bold purple"
truncation_length = 20

[git_status]
style = "bold yellow"
# Indicators: = ⇡ ⇣ ⇕ ? $ ! + » ✘
```

### Character (Prompt)

```toml
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vimcmd_symbol = "[❮](bold green)"
```

### Disabled Modules (40+)

All non-essential modules explicitly disabled for performance:
- package, nodejs, python, rust, golang, docker_context
- kubernetes, aws, gcloud, azure, bun, c, java, helm
- ruby, scala, swift, terraform, username, hostname
- And 20+ more...

---

## Integration with Tools

### fzf Integration
```fish
fzf --fish | source
# Enables: Ctrl-T (files), Ctrl-R (history), Alt-C (cd)
```

### Zoxide Integration
```fish
zoxide init fish | source
# Enables: z, zi commands with frecency
```

### Atuin Integration
```fish
atuin init fish --disable-up-arrow | source
# Enables: Ctrl-R for enhanced history search
# Disables: up-arrow (Atuin handles it)
```

### eza as ls replacement
```fish
abbr -a ls eza
abbr -a ll 'eza -la'
abbr -a lt 'eza --tree --level=2'
```

### bat as cat replacement
```fish
abbr -a cat bat
set -gx PAGER bat
```

---

## Installation Locations

| Component | Source | Target |
|-----------|--------|--------|
| WezTerm config | `configs/wezterm/wezterm.lua` | `~/.wezterm.lua` |
| Fish config | `configs/fish/config.fish` | `~/.config/fish/config.fish` |
| Starship config | `configs/starship/starship.toml` | `~/.config/starship.toml` |

---

## Post-Installation Steps

1. Restart terminal or run: `exec fish`
2. Verify prompt renders correctly
3. Test fzf: Press Ctrl-T, Ctrl-R
4. Test zoxide: `z <partial-dir-name>`
5. Test Atuin: Press Ctrl-R for history

---

## Dependencies

### Required
- WezTerm terminal emulator
- Fish shell
- Starship prompt

### Shell Integrations
- fzf (fuzzy finder)
- zoxide (smart cd)
- Atuin (history)
- eza (ls replacement)
- bat (cat replacement)
- nvim (default editor)

---

## Important Details

- WezTerm auto-selects discrete GPU if available (NVIDIA, AMD)
- Fish shell startup is ~30ms because it avoids heavy initialization
- Starship disables all modules that require filesystem scanning for speed
- Atuin disables up-arrow key to use its own history search (Ctrl+R)
- Zoxide learns frecency - frequently used directories get faster access
- fzf integration provides three keybindings: Ctrl-T, Ctrl-R, Alt-C
- `local_echo_threshold_ms=10` in WezTerm enables predictive echo for perceived minimal latency

---

## Cross-References

See also: CORE_00_overview.md (project overview)
See also: CORE_01_layers.md (5-layer architecture)
See also: INFRA_00_installation.md (installation process)
