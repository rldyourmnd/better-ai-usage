# Layer 5: AI Orchestration - Complete Guide

> Multi-model AI CLI tools for terminal workflows

## Overview

This layer provides AI CLI tools that work together for comprehensive development workflows. All tools are verified with Context7 (February 2026).

## Tools

| Tool | Context7 Score | Provider | Purpose |
|------|----------------|----------|---------|
| **Claude Code** | 80.6 | Anthropic | Deep reasoning, code generation |
| **Gemini CLI** | 78.2 | Google | Fast exploration, research |
| **Codex CLI** | 56.9 | OpenAI | Independent review, critique |

## Installation

### Quick Install

```bash
./scripts/install-layer-5.sh
```

### Manual Installation

```bash
# Node.js is required for all three tools
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Claude Code (80.6) - Official curl script
curl -fsSL https://claude.ai/install.sh | bash

# Gemini CLI (78.2) - npm
npm install -g @google/gemini-cli

# Codex CLI (56.9) - npm
npm install -g @openai/codex
```

## Authentication Setup

### Claude Code

```bash
claude
# Browser authentication opens automatically
# Follow the OAuth flow
```

### Gemini CLI

```bash
# Option 1: Google OAuth (Free tier included)
gemini
# Select "Login with Google"

# Option 2: API Key
export GEMINI_API_KEY="your-key-from-aistudio.google.com/apikey"
gemini

# Option 3: Vertex AI (Enterprise)
export GOOGLE_API_KEY="your-google-cloud-api-key"
export GOOGLE_GENAI_USE_VERTEXAI=true
export GOOGLE_CLOUD_PROJECT="your-project-id"
export GOOGLE_CLOUD_LOCATION="us-central1"
gemini
```

### Codex CLI

```bash
export OPENAI_API_KEY="your-key-from-platform.openai.com"
codex
```

## Usage Examples

### Claude Code

```bash
# Interactive mode
claude

# With prompt
claude "Explain this codebase"

# With file context
claude "Review this file" src/main.rs

# Git workflow
claude "Create a commit for these changes"
```

### Gemini CLI

```bash
# Interactive mode
gemini

# With prompt
gemini -p "Research best practices for async Rust"

# Approval mode (plan changes before execution)
gemini -p "Add error handling" --approval-mode plan

# Output format
gemini -p "Explain this" -o text
```

### Codex CLI

```bash
# Interactive mode
codex

# With prompt
codex "Explain this codebase to me"

# Sandbox mode (read-only)
codex exec --sandbox read-only "Review this code"
```

## Multi-Model Workflow

The triple-provider approach used by custom agents:

```
┌─────────────────────────────────────────────────────────────────┐
│  MULTI-MODEL AI WORKFLOW                                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. EXPLORATION: Gemini CLI (fast, good for research)          │
│     gemini -p "Research best practices for X"                  │
│                                                                 │
│  2. PLANNING: Claude Code (deep reasoning)                      │
│     claude "Create implementation plan for feature Y"           │
│                                                                 │
│  3. CRITIQUE: Codex CLI (independent review)                   │
│     codex exec --sandbox read-only "Review this plan"          │
│                                                                 │
│  4. IMPLEMENTATION: Claude Code                                 │
│     claude "Implement according to plan"                        │
│                                                                 │
│  5. REVIEW: All models independently                            │
│     → Cross-verification                                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Integration with Lower Layers

### Code Intelligence (Layer 4)

```bash
# grepai for semantic search
grepai search "error handling" --json --compact | claude "Analyze this code"

# ast-grep for structural analysis
sg -p 'fn $NAME($$$PARAMS) $$$BODY' -l rust | gemini "Document these functions"

# probe for context extraction
probe search "auth" ./ --max-tokens 8000 | codex "Review security"
```

### GitHub & Git (Layer 3)

```bash
# Create PR with AI assistance
claude "Create a PR for this branch"

# Review PR
gh pr diff 123 | gemini "Review this PR for issues"

# Generate commit message
git diff --cached | codex "Generate a commit message"
```

### Productivity (Layer 2)

```bash
# Search history with AI context
atuin search "docker" | claude "What was I trying to do?"

# Find files and analyze
fd -e rs -x claude "Explain {}"
```

## Performance Benefits

| Metric | Impact |
|--------|--------|
| Shell startup | 30x faster → AI can spawn shells quickly |
| Input latency | 10x faster → Real-time AI interaction |
| Search speed | 10x faster → Faster code understanding |
| History sync | Enabled → Learn from all machines |

## Configuration Files

### Environment Variables (~/.bashrc or ~/.config/fish/config.fish)

```bash
# Claude Code (auto-configured on first run)

# Gemini CLI
export GEMINI_API_KEY="your-key"  # Optional if using OAuth

# Codex CLI
export OPENAI_API_KEY="your-key"
```

## Best Practices

1. **Use Claude Code for complex tasks**: Deep reasoning, code generation, git workflows
2. **Use Gemini CLI for research**: Fast exploration, pattern discovery
3. **Use Codex CLI for review**: Independent critique, sandbox analysis
4. **Combine all three**: Cross-verification catches more issues
5. **Leverage lower layers**: grepai, ast-grep, probe for context extraction

## Troubleshooting

### "command not found"

```bash
# Ensure npm global bin is in PATH
export PATH="$(npm config get prefix)/bin:$PATH"

# Add to shell config
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.bashrc
```

### Authentication failures

```bash
# Claude Code
claude auth login

# Gemini CLI
gemini auth login

# Codex CLI - check API key
echo $OPENAI_API_KEY
```

### Slow startup

```bash
# Clear npm cache
npm cache clean --force

# Update to latest versions
npm update -g @anthropic-ai/claude-code @google/gemini-cli @openai/codex
```
