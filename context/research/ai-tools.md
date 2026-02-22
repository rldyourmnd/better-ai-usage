# AI/LLM Tools Research

> Research conducted via  - February 2026

##  Benchmark Scores

| Tool | Score | Description |
|------|-------|-------------|
| **llm** | **89.3** | Simon Willison's universal LLM CLI |
| **grepai** | **88.4** | Semantic code search with embeddings |
| DocsGPT | 84.4 | Knowledge source Q&A |
| **bun** | **85.0** | JavaScript runtime (all-in-one) |
| aider CE | 69.8 | AI pair programming |
| mods | 67.9 | LLM integration in pipelines |
| GPT Researcher | 73.2 | Research report generation |
| shell-gpt | 60.7 | GPT terminal assistant |
| GPTMe | 52.4 | Terminal AI assistant |

## Detailed Analysis

### llm CLI (Score: 89.3)

**Author:** Simon Willison

**Features:**
- Universal interface for multiple LLM providers
- Embeddings support
- Conversation logging
- Plugin system

**Usage:**

```bash
# Basic prompt
llm "What is the capital of France?"

# With specific model
llm "Explain this code" -m gpt-4o

# Embeddings
llm embed -c "This is content" -m 3-small

# Install embedding models
llm install llm-sentence-transformers

# View logs
llm logs -n 10

# Search logs
llm logs -q "search term"
```

### grepai (Score: 88.4) - KEY DISCOVERY

**What it does:** Semantic code search using vector embeddings

**Why it matters for AI agents:**
- Search code by MEANING, not text
- Natural language queries
- JSON output for AI consumption
- Token-optimized formats

**Usage:**

```bash
# Initialize (build embeddings)
grepai init

# Semantic search
grepai search "user authentication flow"
grepai search "error handling middleware"
grepai search "database connection pool"

# JSON output for AI agents
grepai search "auth" --json

# Compact (saves ~80% tokens)
grepai search "auth" --json --compact

# Token-optimized
grepai search "auth" --toon

# With limits
grepai search "API" --limit 5
```

### aider (Score: 69.8)

**What it does:** AI pair programming in terminal

**Features:**
- Git-aware code editing
- Multi-model support
- Works with local files
- Context-aware

**Usage:**

```bash
# Start aider
aider

# With specific files
aider file1.py file2.py

# With model
aider --model gpt-4
```

### fabric (Daniel Miessler)

**What it does:** AI augmentation patterns library

**Features:**
- Prompt patterns for common tasks
- Chainable patterns
- Extensible

**Usage:**

```bash
# List patterns
fabric --list

# Apply pattern
cat file.txt | fabric -p summarize

# Chain patterns
cat log.txt | fabric -p extract_errors | fabric -p summarize
```

### Shell-GPT (Score: 60.7)

**What it does:** GPT-powered terminal assistant

**Usage:**

```bash
# Ask question
sgpt "What is the capital of France?"

# Generate command
sgpt "find all large files"

# Shell integration
sgpt --shell "compress all logs"
```

## Comparison Table

| Feature | llm | grepai | aider | shell-gpt |
|---------|-----|--------|-------|-----------|
| Multi-model | Yes | N/A | Yes | Yes |
| Code search | No | Yes | Limited | No |
| Code editing | No | No | Yes | No |
| Embeddings | Yes | Yes | No | No |
| Shell integration | No | No | No | Yes |
| Offline | Partial | Yes | Partial | No |

## Recommendation for AI Agents

1. **grepai** - Essential for code understanding
2. **llm CLI** - Universal LLM interface
3. **aider** - For code modification tasks
4. **fabric** - For prompt patterns

## Not Recommended (Redundant)

- shell-gpt (redundant with claude/gemini/codex CLI)
- mods (similar functionality in llm CLI)
- GPTMe (less mature than alternatives)
