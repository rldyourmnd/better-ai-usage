-- ═══════════════════════════════════════════════════════════════════════════════
-- WEZTERM CONFIGURATION - Ultimate AI Terminal Environment
-- ═══════════════════════════════════════════════════════════════════════════════
-- Performance: WebGPU + Vulkan, ~50-80ms startup
-- Features: Built-in multiplexer, GPU acceleration, Lua scripting

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ═══════════════════════════════════════════════════════════════════════════════
-- GPU RENDERING - WebGPU + Vulkan
-- ═══════════════════════════════════════════════════════════════════════════════
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'

-- Auto-select Vulkan discrete GPU (NVIDIA, AMD)
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
    config.webgpu_preferred_adapter = gpu
    break
  end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PERFORMANCE - Minimal latency for AI agents
-- ═══════════════════════════════════════════════════════════════════════════════
config.max_fps = 120
config.animation_fps = 1              -- Disable animations
config.cursor_blink_rate = 0          -- No blinking overhead
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- ═══════════════════════════════════════════════════════════════════════════════
-- MULTIPLEXER - Built-in, no tmux needed
-- ═══════════════════════════════════════════════════════════════════════════════
config.unix_domains = {
  {
    name = 'unix',
    socket_path = '/tmp/wezterm-gui-sock',
    -- CRITICAL: Predictive echo for minimal perceived latency
    local_echo_threshold_ms = 10,
  },
}

-- Auto-connect to multiplexer on startup
config.default_gui_startup_args = { 'connect', 'unix' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- WAYLAND - Native Linux support
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_wayland = true

-- ═══════════════════════════════════════════════════════════════════════════════
-- APPEARANCE - Minimal, fast
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_scroll_bar = false
config.window_decorations = 'RESIZE'
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Font configuration
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12.0
config.line_height = 1.1

-- Color scheme (dark, high contrast for AI readability)
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  background = '#1e1e2e',
  foreground = '#cdd6f4',
  cursor_bg = '#f5e0dc',
  cursor_fg = '#1e1e2e',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBINDINGS - AI-optimized
-- ═══════════════════════════════════════════════════════════════════════════════
local act = wezterm.action

config.keys = {
  -- Pane management
  { key = '|', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '_', mods = 'CTRL|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },

  -- Navigation
  { key = 'h', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL|SHIFT', action = act.ActivatePaneDirection 'Right' },

  -- Resize
  { key = 'H', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'J', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = 'K', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'L', mods = 'CTRL|SHIFT|ALT', action = act.AdjustPaneSize { 'Right', 5 } },

  -- Tab management
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
  { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },

  -- Quick search
  { key = 'f', mods = 'CTRL|SHIFT', action = act.Search 'CurrentSelectionOrEmptyString' },

  -- Copy/paste
  { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'Clipboard' },
  { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

  -- Reload config
  { key = 'r', mods = 'CTRL|SHIFT', action = act.ReloadConfiguration },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- LAUNCH MENU - AI agent quick start
-- ═══════════════════════════════════════════════════════════════════════════════
config.launch_menu = {
  { label = 'Fish', args = { 'fish' } },
  { label = 'Zsh', args = { 'zsh' } },
  { label = 'Bash', args = { 'bash' } },
  { label = 'Python', args = { 'python3' } },
  { label = 'Node', args = { 'node' } },
}

return config
