<!-- Memory Metadata
Last updated: 2026-02-21
Last commit: dbba71c docs: add comprehensive context directory with research data
Scope: README.md, docs/, context/
Area: CORE
-->

# Better AI Terminal Environment - Project Overview

## Overview

A 5-layer terminal environment configuration system optimized for AI agent workflows. Transforms a standard Linux terminal into a GPU-accelerated, minimal-latency environment with ~30ms shell startup (30x faster than typical setups). Based on Context7 research data from February 2026.

**Platform**: Linux (Ubuntu/Debian, apt-based)
**Goal**: Maximum optimization for AI-assisted development

## Architecture

The system consists of a foundation layer plus 5 functional layers:

- **Foundation**: WezTerm + Fish + Starship (GPU-accelerated terminal, modern shell, minimal prompt)
- **Layer 1 - File Operations**: bat, fd, rg, sd, jq, yq, eza (10-100x faster than Unix tools)
- **Layer 2 - Productivity**: fzf, zoxide, Atuin, uv, bun, watchexec, glow, bottom, hyperfine
- **Layer 3 - GitHub & Git**: gh CLI, lazygit, delta
- **Layer 4 - Code Intelligence**: grepai, ast-grep, probe, semgrep, ctags, tokei
- **Layer 5 - AI Orchestration**: User-provided claude/gemini/codex CLIs

## Performance Targets

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Shell startup | 915ms | ~30ms | 30x faster |
| Terminal startup | 300-500ms | 50-80ms | 6x faster |
| Input latency | ~50ms | <5ms | 10x faster |
| File search | grep | rg | 10x+ faster |
| Prompt render | - | <5ms | Instant |

## Key Files

- `README.md` - Project documentation and architecture overview
- `CLAUDE.md` - AI agent instructions and conventions
- `docs/layers/` - Detailed documentation for each layer
- `docs/foundation/` - Foundation component documentation (TODO)
- `context/research/` - Context7 research data (terminals, shells, AI tools)
- `context/tools/` - Tool-specific context and Context7 scores
- `context/benchmarks.md` - Performance benchmarks
- `context/context7-scores.md` - Tool evaluation scores
- `scripts/install.sh` - Main installation script

## Tool Selection Criteria

All tools selected based on Context7 benchmark scores (0-100 scale):
- Score > 85: Preferred choice (excellent)
- Score 70-85: Good choice
- Score < 70: Use if specific features needed

## All Tools Summary (27 total)

### Foundation (3)
| Tool | Score | Purpose |
|------|-------|---------|
| WezTerm | 91.1 | GPU-accelerated terminal |
| Fish | 94.5 | Shell with autosuggestions |
| Starship | 80.8 | Minimal cross-shell prompt |

### Layer 1: File Operations (7)
| Tool | Score | Replaces |
|------|-------|----------|
| bat | 91.8 | cat |
| fd | 86.1 | find |
| rg | 81 | grep |
| sd | 90.8 | sed |
| jq | 85.7 | JSON |
| yq | 96.4 | YAML/JSON/XML |
| eza | - | ls |

### Layer 2: Productivity (9)
| Tool | Score | Purpose |
|------|-------|---------|
| fzf | 85.4 | Fuzzy finder |
| zoxide | 39.7 | Smart cd |
| Atuin | 68.5 | History sync |
| uv | 91.4 | Python package manager |
| bun | 85 | JavaScript runtime |
| watchexec | - | File watcher |
| glow | 76.1 | Markdown renderer |
| bottom | - | System monitor |
| hyperfine | 81.3 | Benchmarking |

### Layer 3: GitHub & Git (3)
| Tool | Score | Purpose |
|------|-------|---------|
| gh CLI | 83.2 | GitHub in terminal |
| lazygit | 46 | Git TUI |
| delta | - | Git diff viewer |

### Layer 4: Code Intelligence (6)
| Tool | Score | Purpose |
|------|-------|---------|
| grepai | 88.4 | Semantic code search |
| ast-grep | 78.7 | AST structural search |
| probe | - | AI code extraction |
| semgrep | 70.4 | Security analysis |
| ctags | - | Code indexing |
| tokei | - | Code statistics |

### Layer 5: AI Orchestration (3 - user-provided)
| Tool | Score | Provider |
|------|-------|----------|
| claude CLI | 80.6 | Anthropic |
| gemini CLI | 78.2 | Google |
| codex CLI | 56.9 | OpenAI |

## Patterns and Conventions

- Tool selections based on Context7 benchmark scores (0-100 scale)
- All installation commands use `set -euo pipefail` for safety
- Scripts install tools only if not already present (idempotent)
- Configuration files are copied to standard locations:
  - `~/.wezterm.lua` (WezTerm)
  - `~/.config/fish/config.fish` (Fish)
  - `~/.config/starship.toml` (Starship)
- All scripts use colored output for status messages (INFO/SUCCESS/WARN/ERROR)

## Dependencies

### External Tools (user-provided)
- WezTerm (terminal emulator)
- Fish shell
- Starship prompt
- claude CLI (Anthropic)
- gemini CLI (Google)
- codex CLI (OpenAI)

### Package Managers Used
- apt (Ubuntu/Debian packages)
- cargo (Rust packages)
- pip (Python packages)
- curl/wget (download utilities)

## Current State

- Initial release complete (commit 960e369)
- Documentation added (commit dbba71c)
- All layers defined and documented
- Installation script exists (partial - missing some tools)
- Context7 research data included
- CLAUDE.md created for AI agent instructions

## Known Issues

1. **Missing layer scripts**: `install-layer-*.sh` referenced in README but not created
2. **Empty docs/foundation**: wezterm.md, fish.md, starship.md not created
3. **Partial install.sh**: Some tools documented but not in script (fd, rg, eza, fzf, delta, hyperfine)

## Cross-References

See also: CORE_01_layers.md (detailed 5-layer architecture with all tools)
See also: FRONTEND_00_terminal.md (terminal/shell configuration)
See also: INFRA_00_installation.md (installation process)
