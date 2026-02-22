# Terminal Research

> Research conducted via  - February 2026

## Benchmark Scores

| Terminal | Score | Language | GPU | Multiplexer |
|----------|-------|----------|-----|-------------|
| **WezTerm** | **91.1** | Rust | WebGPU/Vulkan | Built-in |
| Wave | 86.2 | Electron | No | No |
| Kitty | 80.5 | Python+C | OpenGL | No |
| Zellij | 79.4 | Rust | No | Yes |
| Rio | 69.6 | Rust | WGPU | No |
| Tmux | 62.6 | C | No | Yes |
| Alacritty | 37.4 | Rust | OpenGL | No |

## Detailed Analysis

### WezTerm (Score: 91.1) - WINNER

**Why WezTerm is optimal for developers:**

1. **WebGPU + Vulkan backend** - Direct GPU access on NVIDIA RTX 2070
2. **Built-in multiplexer** - No separate tmux, zero IPC latency
3. **local_echo_threshold_ms=10** - Predictive echo for minimal perceived latency
4. **Lua scripting** - Automation for developer workflows
5. **Unix domains** - Persistent sessions for parallel sessions

**Configuration highlights:**

```lua
-- GPU selection
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- Minimal latency
config.unix_domains = {
  {
    name = 'unix',
    local_echo_threshold_ms = 10,  -- critical for responsiveness
  },
}

-- Performance
config.max_fps = 120
config.animation_fps = 1  -- Disable animations
config.cursor_blink_rate = 0  -- No blinking overhead
```

### Kitty (Score: 80.5) - Alternative

**Strengths:**
- GPU + SIMD + threaded rendering
- Good Wayland + NVIDIA support
- Mature codebase

**Optimal configuration:**

```python
# Minimal latency
input_delay 0
repaint_delay 2
sync_to_monitor no
wayland_enable_ime no
```

### Warp Terminal (Score: 72.1)

**Status: developer Platform (not just terminal)**

**Pros:**
- Agent Mode with natural language
- Multi-agent parallel execution
- Rust + GPU rendering

**Cons:**
- Proprietary (closed source)
- Cloud-dependent AI
- NVIDIA bugs on Linux
- Vendor lock-in

**Verdict:** Good for experimentation, not recommended as primary terminal

### Alacritty (Score: 37.4)

**Why not recommended:**
- Minimal features
- No built-in multiplexer
- Score significantly lower than WezTerm

### Rio (Score: 69.6)

**Interesting but risky:**
- WGPU backend (Vulkan/GL/DX12/Metal)
- Modern architecture
- Less mature, smaller community

## User Hardware Analysis

| Component | Value | Impact |
|-----------|-------|--------|
| GPU | RTX 2070 Mobile (8GB) | Excellent for GPU-accelerated terminals |
| Vulkan | 1.4.321 | Full support for WezTerm |
| OpenGL | 4.6 | Full support for Kitty |
| Display | Wayland + GNOME | Native Wayland support needed |
| CPU | i7-8750H (12 threads) | Sufficient for all terminals |
| RAM | 32GB | More than enough |

## Recommendation

**Primary:** WezTerm
- Highest  score (91.1)
- Built-in multiplexer
- WebGPU + Vulkan on RTX 2070
- Lua scripting for automation

**Alternative:** Kitty
- If WezTerm has issues
- Mature and stable
- Good NVIDIA + Wayland support
