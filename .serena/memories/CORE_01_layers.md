<!-- Memory Metadata
Last updated: 2026-02-21
Last commit: dbba71c docs: add comprehensive context directory with research data
Scope: docs/layers/, context/tools/, scripts/install.sh
Area: CORE
-->

# 5-Layer Architecture - Complete Tool Reference

## Overview

A layered architecture where each layer builds on the foundation to create an AI-optimized terminal environment. Layers progress from low-level file operations through high-level AI orcheststration.

## Architecture

```
LAYER 5: AI ORCHESTRATION (user-provided)
    claude CLI | gemini CLI | codex CLI
    ↓
LAYER 4: CODE INTELLIGENCE
    grepai (88.4) | ast-grep (78.7) | probe | semgrep (70.4) | ctags | tokei
    ↓
LAYER 3: GITHUB & GIT
    gh CLI (83.2) | lazygit (46) | delta
    ↓
LAYER 2: PRODUCTIVITY
    fzf (85.4) | zoxide (39.7) | Atuin (68.5) | uv (91.4) | bun (85) | watchexec | glow (76.1) | bottom | hyperfine (81.3)
    ↓
LAYER 1: FILE OPERATIONS
    bat (91.8) | fd (86.1) | rg (81) | sd (90.8) | jq (85.7) | yq (96.4) | eza
    ↓
FOUNDATION: WezTerm + Fish + Starship
    WebGPU/Vulkan GPU acceleration, ~30ms shell startup, <5ms input latency
```

---

## FOUNDATION: Terminal + Shell

| Tool | Score | Install | Purpose |
|------|-------|---------|---------|
| **WezTerm** | 91.1 | apt (fury.io repo) | GPU-accelerated terminal, WebGPU/Vulkan, built-in multiplexer |
| **Fish** | 94.5 | apt | Shell with autosuggestions, ~30ms startup |
| **Starship** | 80.8 | curl script | Cross-shell prompt, <5ms render, 40+ modules disabled |

### WezTerm Features
- WebGPU + Vulkan GPU rendering
- Built-in multiplexer (no tmux needed)
- `local_echo_threshold_ms=10` for minimal perceived latency
- Auto-selects discrete GPU (NVIDIA, AMD)

### Fish Features
- Autosuggestions out of the box
- Web-based configuration
- 35+ abbreviations defined
- Custom functions: proj, mkcd, backup, ducks, ff, gg

### Starship Features
- Minimal format: directory + git + character
- Right side: cmd_duration + jobs
- All non-essential modules disabled for speed

---

## LAYER 1: File Operations

Replaces classic Unix tools with Rust/Go alternatives for 10-100x performance improvement.

| Tool | Score | Install | Replaces | Key Features |
|------|-------|---------|----------|--------------|
| **bat** | 91.8 | apt | cat | Syntax highlighting, Git integration, line numbers |
| **fd** | 86.1 | apt/cargo | find | Parallel traversal, smart defaults, hidden files |
| **rg** | 81 | apt | grep | Respects gitignore, 10x+ faster, regex support |
| **sd** | 90.8 | cargo | sed | Painless regex, intuitive syntax, in-place edit |
| **jq** | 85.7 | apt | - | JSON processor, powerful filtering |
| **yq** | 96.4 | wget | - | YAML/JSON/XML processor, jq-like syntax |
| **eza** | - | apt/wget | ls | Modern, colorful, git-aware, tree view |

### bat Usage
```bash
bat file.py              # Syntax highlighted
bat -A file              # Show non-printable chars
bat --diff file.py       # Git diff integration
bat file1 file2          # Multiple files with headers
```

### fd Usage
```bash
fd pattern               # Find by pattern (regex)
fd -e py search          # Only Python files
fd -H hidden             # Include hidden files
fd -t d name             # Only directories
fd -x command {}         # Execute command on results
```

### rg Usage
```bash
rg pattern               # Search pattern recursively
rg -i pattern            # Case insensitive
rg -t py 'def.*function' # Only Python files
rg -C 3 pattern          # 3 lines context
rg --files               # List all files
rg 'old' -r 'new'        # Replace in output (preview)
```

### sd Usage
```bash
sd 'old' 'new' file.txt  # Simple replace
sd -p 'from' 'to' file   # In-place edit
sd '(\w+)@' '$1!' file   # Capture groups
```

### eza Usage
```bash
eza                      # Modern ls
eza -la                  # Long format with hidden
eza --tree --level=2     # Tree view
eza --git                # Git status indicators
eza -s size              # Sort by size
```

---

## LAYER 2: Productivity

Tools for fast navigation, history management, and modern package management.

| Tool | Score | Install | Purpose |
|------|-------|---------|---------|
| **fzf** | 85.4 | apt/git | Fuzzy finder for files, history, commands |
| **zoxide** | 39.7 | cargo | Smart cd with frecency learning |
| **Atuin** | 68.5 | curl | SQLite history with encrypted sync |
| **uv** | 91.4 | curl | Python package manager (10-100x faster than pip) |
| **bun** | 85 | curl | JavaScript runtime (3-10x faster than npm) |
| **watchexec** | - | cargo | Auto-run commands on file changes |
| **glow** | 76.1 | apt | Markdown renderer for terminal |
| **bottom** | - | cargo | System monitor (htop replacement) |
| **hyperfine** | 81.3 | cargo | Command benchmarking tool |

### fzf Usage
```bash
fzf                      # Fuzzy find files
fzf --multi              # Multi-select (tab/shift-tab)
vim $(fzf)               # Open selected in vim
ps -ef | fzf             # Fuzzy filter any list
Ctrl-T                   # File search (shell integration)
Ctrl-R                   # History search
Alt-C                    # Directory navigation
```

### fzf Shell Integration
```fish
# Fish - add to config.fish
fzf --fish | source
```

### zoxide Usage
```bash
z project                # Jump to project (frecency)
z -                      # Previous directory
zi                       # Interactive selection
```

### Atuin Usage
```bash
atuin search query       # Search history
atuin sync               # Sync to cloud
Ctrl-R                   # History search (replaces default)
```

### uv Usage
```bash
uv venv                  # Create virtual environment
uv pip install requests  # Install package
uv pip install -r req.txt # From requirements
uv pip sync req.txt      # Sync to exact state
uv run command           # Run in project venv
```

### bun Usage
```bash
bun install              # Install dependencies
bun run script           # Run package.json script
bun add package          # Add dependency
bun test                 # Run tests
```

### watchexec Usage
```bash
watchexec command        # Run on any file change
watchexec -e py pytest   # Only .py files
watchexec -w src command # Watch specific dir
```

### hyperfine Usage
```bash
hyperfine 'command1' 'command2'  # Benchmark commands
hyperfine --warmup 3 'cmd'       # Warmup runs
hyperfine --runs 20 'cmd'        # Fixed runs
hyperfine --export-markdown out.md 'cmd'
```

---

## LAYER 3: GitHub & Git

Complete GitHub and Git automation in the terminal.

| Tool | Score | Install | Purpose |
|------|-------|---------|---------|
| **gh CLI** | 83.2 | apt | Complete GitHub control in terminal |
| **lazygit** | 46 | apt | Visual git UI for staging, commits, pushes |
| **delta** | - | cargo | Beautiful git diffs with syntax highlighting |

### gh CLI Usage
```bash
gh repo list             # List repos
gh pr list               # List pull requests
gh pr create             # Create PR
gh issue create          # Create issue
gh auth login            # Authenticate
gh workflow run          # Run GitHub Actions
```

### lazygit Usage
```bash
lazygit                  # Launch visual git UI
# Inside lazygit:
# - Stage/unstage with space
# - Commit with c
# - Push with P
# - Pull with p
# - Interactive rebase with r
```

### delta Configuration
```bash
# Add to ~/.gitconfig
[core]
    pager = delta
[delta]
    syntax-theme = Catppuccin
    side-by-side = true
    line-numbers = true
```

---

## LAYER 4: Code Intelligence

AI-ready code analysis and search tools.

| Tool | Score | Install | Purpose |
|------|-------|---------|---------|
| **grepai** | 88.4 | pip | Semantic code search with embeddings |
| **ast-grep** | 78.7 | cargo | AST-based structural search and rewrite |
| **probe** | - | cargo | AI-friendly code block extraction |
| **semgrep** | 70.4 | pip | Static analysis for security |
| **ctags** | - | apt | Code indexing for navigation |
| **tokei** | - | cargo | Code statistics by language |

### grepai Usage
```bash
grepai init              # Build embeddings (required first)
grepai search "auth flow"           # Natural language search
grepai search "error handling" --json --compact  # JSON for AI
grepai search "API" --limit 5       # Limit results
grepai search "auth" --toon         # Token-optimized
```

### ast-grep Usage
```bash
sg -p 'fn $NAME($$$) $$$BODY' -l rust    # Find functions
sg -p 'console.log($MSG)' -l js           # Find console.log
sg -p 'def $NAME($$$): $$$BODY' -l python # Find Python funcs
sg -p 'var $V = $VAL' -r 'const $V = $VAL' -l js  # Rewrite
sg -p 'old($$$)' -r 'new($$$)' --update-all       # In-place
```

### ast-grep Pattern Syntax
| Syntax | Meaning |
|--------|---------|
| `$NAME` | Single metavariable (identifier) |
| `$$$BODY` | Multiple statements/expressions |
| `$$$` | Zero or more of anything |

### probe Usage
```bash
probe search "auth" ./ --max-tokens 8000   # Token-limited search
probe query "fn $NAME($$$) $$$BODY" ./src --language rust
```

### semgrep Usage
```bash
semgrep --config auto .              # Auto rules
semgrep --config p/security-audit .  # Security scan
semgrep --config p/owasp-top-ten .   # OWASP Top 10
semgrep --json .                     # JSON output
```

### ctags Usage
```bash
ctags -R .                           # Generate tags
ctags -R --languages=Python,Rust .   # Specific languages
```

### tokei Usage
```bash
tokei                               # Count lines of code
tokei --type rust,python            # Specific languages
tokei --sort lines                  # Sort by lines
tokei --output json                 # JSON output
```

---

## LAYER 5: AI Orchestration

User-provided AI CLI tools for multi-model workflows.

| Tool | Score | Provider | Purpose |
|------|-------|----------|---------|
| **claude CLI** | 80.6 | Anthropic | Deep reasoning, MCP integration |
| **gemini CLI** | 78.2 | Google | Fast research, multimodal |
| **codex CLI** | 56.9 | OpenAI | Code generation, terminal agent |

**IMPORTANT**: These are USER-PROVIDED. The project does NOT install them.

### claude CLI
- MCP server integration
- Hooks system for automation
- Project-level CLAUDE.md configuration
- Usage: `claude "prompt"` or `claude code` for agentic mode

### gemini CLI
- Google Search grounding
- Multimodal input (images, PDFs)
- GitHub Action integration
- Usage: `gemini -p "prompt"` or interactive mode

### codex CLI
- Sandbox modes for safety
- Full-auto mode available
- Session management (resume, fork)
- Usage: `codex "prompt"` or `codex exec "prompt"`

---

## Multi-Model Workflow

```
1. EXPLORATION: Gemini CLI (fast, good for research)
   gemini -p "Research best practices for X"

2. PLANNING: Claude CLI (deep reasoning)
   claude "Create implementation plan for feature Y"

3. CRITIQUE: Codex CLI (independent review)
   codex exec "Review this plan for issues"

4. IMPLEMENTATION: Claude CLI
   claude "Implement according to plan"

5. REVIEW: All models independently
   → Cross-verification
```

---

## Installation Commands Summary

### apt packages
```bash
sudo apt install -y bat jq glow gh lazygit fish universal-ctags fd-find ripgrep eza
```

### cargo packages
```bash
cargo install sd zoxide watchexec bottom tokei ast-grep probe-cli hyperfine delta
```

### pip packages
```bash
pip install grepai semgrep
```

### curl scripts
```bash
curl -sS https://starship.rs/install.sh | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -fsSL https://bun.sh/install | bash
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
```

### wget binaries
```bash
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq
```

### WezTerm repo
```bash
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-archive-keyring.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-archive-keyring.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt update && sudo apt install -y wezterm
```

---

## Key Files

- `docs/layers/layer-1-file-ops.md` - File operations tools
- `docs/layers/layer-2-productivity.md` - Productivity tools
- `docs/layers/layer-3-github.md` - GitHub/Git tools
- `docs/layers/layer-4-code-intelligence.md` - Code intelligence tools
- `docs/layers/layer-5-ai-orchestration.md` - AI orchestration
- `context/tools/layer-*-*.md` - Tool-specific Context7 scores
- `context/context7-scores.md` - All benchmark scores

## Cross-References

See also: CORE_00_overview.md (project overview)
See also: FRONTEND_00_terminal.md (terminal configuration)
See also: INFRA_00_installation.md (installation process)
