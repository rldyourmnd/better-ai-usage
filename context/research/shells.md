# Shell Research

> Research conducted via  - February 2026

## Benchmark Scores

### Full Shells

| Shell | Score | Language | POSIX | Startup |
|-------|-------|----------|-------|---------|
| **Fish** | **94.5** | C++ | No | ~30ms |
| Xonsh | 86.0 | Python | Yes | ~200ms |
| **Nushell** | **85.0** | Rust | No | ~50ms |
| PowerShell | 36.0 | C# | No | ~300ms |

### ZSH Frameworks

| Framework | Score | Startup Impact |
|-----------|-------|----------------|
| Oh-My-Zsh | 87.7 | +200-500ms |
| **Zinit** | **87.3** | **-50-80% (Turbo mode)** |
| Prezto | 73.7 | +100-200ms |

### Prompt Systems

| Prompt | Score | Startup | Cross-shell |
|--------|-------|---------|-------------|
| **Starship** | **80.8** | **<5ms** | Yes (all shells) |
| Powerlevel10k | - | <5ms + Instant | No (zsh only) |

## Detailed Analysis

### Fish (Score: 94.5) - RECOMMENDED

**Why Fish is optimal for developers:**

1. **~30ms startup** (vs 915ms current zsh - 30x improvement)
2. **Autosuggestions out of the box** - No plugins needed
3. **Web-based configuration** - `fish_config` opens browser
4. **Modern scripting language** - More powerful than bash
5. **"Just works" philosophy** - Minimal configuration

**Features:**
- Autosuggestions based on history
- Syntax highlighting
- Tab completions with descriptions
- Web-based config UI
- Sane defaults

**Trade-off:**
- NOT POSIX compatible
- Some scripts may need adaptation
- For developers: This is acceptable

### Nushell (Score: 85.0) - Alternative

**Strengths:**
- Structured data pipelines
- Type system
- Modern cross-platform design

**Use cases:**
- Data-intensive data-intensive workflows
- JSON/CSV processing
- Pipeline operations

**Example:**

```nushell
# Process JSON logs
open logs.json | where level == "ERROR" | select timestamp message

# CSV processing
open data.csv | group-by category | math sum

# Benchmark pipeline
timeit { open large.json | where status == "active" }
```

### Zsh + Zinit (Turbo Mode) - POSIX Alternative

**If POSIX compatibility is required:**

1. **Zinit Turbo mode** - 50-80% faster startup
2. **Powerlevel10k Instant Prompt** - Shows prompt before loading
3. **Lazy loading plugins** - Load after prompt appears

**Configuration:**

```zsh
# Turbo mode example
zinit lucid wait for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting

# Instant prompt (at top of .zshrc)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

### Current User State

| Metric | Current | Issue |
|--------|---------|-------|
| Shell | zsh | OK |
| Startup | **915ms** | CRITICAL - 30x slower than target |
| gitstatus | Error | Configuration broken |
| .zshrc size | 203 lines | Too large for fast startup |
| Plugins | No manager | Loading synchronously |
| Prompt | Unknown | Potentially slow |

## Recommendation

**Primary: Fish + Starship**

- Fastest shell (94.5 score)
- ~30ms startup
- Autosuggestions included
- Minimal configuration
- Cross-shell prompt (Starship)

**Alternative: Zsh + Zinit + P10k**

- If POSIX compatibility required
- Turbo mode for 50-80% faster startup
- Instant prompt for immediate display

## Startup Time Comparison

| Configuration | Startup Time |
|---------------|--------------|
| Current zsh (broken) | 915ms |
| Fish + Starship | ~30ms |
| Zsh + Zinit + P10k | ~50ms |
| Bare zsh | ~20ms |
| dash | ~5ms |

## Installation

```bash
# Fish
sudo apt install fish

# Starship
curl -sS https://starship.rs/install.sh | sh

# Configure Fish
mkdir -p ~/.config/fish
echo 'starship init fish | source' >> ~/.config/fish/config.fish

# Optional: Set as default shell
chsh -s $(which fish)
```
