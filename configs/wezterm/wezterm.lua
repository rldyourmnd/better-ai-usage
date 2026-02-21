-- ═══════════════════════════════════════════════════════════════════════════════
-- WEZTERM CONFIGURATION - High-Performance Terminal Environment
-- ═══════════════════════════════════════════════════════════════════════════════
-- Performance: WebGPU + Vulkan
-- Features: Built-in multiplexer, GPU acceleration, Lua scripting

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ═══════════════════════════════════════════════════════════════════════════════
-- GPU RENDERING - WebGPU + Vulkan (optimized for NVIDIA RTX)
-- ═══════════════════════════════════════════════════════════════════════════════
config.front_end = 'WebGpu'

-- Auto-select Vulkan discrete GPU (NVIDIA, AMD)
local gpus = wezterm.gui.enumerate_gpus()
for _, gpu in ipairs(gpus) do
  if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
    config.webgpu_preferred_adapter = gpu
    break
  end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PERFORMANCE - Minimal latency for AI tools
-- ═══════════════════════════════════════════════════════════════════════════════
config.max_fps = 120
config.animation_fps = 1
config.cursor_blink_rate = 0

-- Large scrollback for AI tool output (Claude Code, etc.)
config.scrollback_lines = 50000

-- Terminal capabilities for modern tools
config.term = 'wezterm'

-- ═══════════════════════════════════════════════════════════════════════════════
-- MULTIPLEXER - Built-in, no tmux needed
-- ═══════════════════════════════════════════════════════════════════════════════
config.unix_domains = {
  {
    name = 'unix',
    socket_path = '/tmp/wezterm-gui-sock',
    local_echo_threshold_ms = 10,
  },
}

config.default_gui_startup_args = { 'connect', 'unix' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- WAYLAND - Native Linux support
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_wayland = true

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEFAULT SHELL - Fish as primary
-- ═══════════════════════════════════════════════════════════════════════════════
config.default_prog = { '/usr/bin/fish', '-l' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- APPEARANCE - Modern with integrated buttons
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_scroll_bar = false
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true
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

-- Color scheme
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  background = '#1e1e2e',
  foreground = '#cdd6f4',
  cursor_bg = '#f5e0dc',
  cursor_fg = '#1e1e2e',
  selection_fg = '#1e1e2e',
  selection_bg = '#f5e0dc',
  tab_bar = {
    background = '#181825',
    active_tab = { bg_color = '#1e1e2e', fg_color = '#cdd6f4' },
    inactive_tab = { bg_color = '#181825', fg_color = '#6c7086' },
    new_tab = { bg_color = '#181825', fg_color = '#6c7086' },
  },
}

-- Quick select patterns for AI tool output (git hash is already default)
config.quick_select_patterns = {
  -- File paths (linux/unix style)
  '[/~][a-zA-Z0-9./_-]+',
  -- URLs (more permissive)
  'https?://[^\\s]+',
  -- IP addresses
  '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}',
  -- UUIDs (common in AI tool output)
  '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- KEYBINDINGS
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

  -- Font size
  { key = '=', mods = 'CTRL|SHIFT', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL|SHIFT', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL|SHIFT', action = act.ResetFontSize },

  -- Debug and utilities (essential for troubleshooting)
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
  { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
}

-- Mouse bindings (optimized for AI workflow)
config.mouse_bindings = {
  -- Ctrl+Click to open links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable Ctrl+Down to avoid issues in vim/tmux
  {
    event = { Down = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.Nop,
  },
  -- Double click to select word
  {
    event = { Up = { streak = 2, button = 'Left' } },
    action = act.CopyTo 'ClipboardAndPrimarySelection',
  },
  -- Triple click to select line
  {
    event = { Up = { streak = 3, button = 'Left' } },
    action = act.CopyTo 'ClipboardAndPrimarySelection',
  },
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- LAUNCH MENU
-- ═══════════════════════════════════════════════════════════════════════════════
config.launch_menu = {
  { label = 'Fish', args = { 'fish' } },
  { label = 'Zsh', args = { 'zsh' } },
  { label = 'Bash', args = { 'bash' } },
  { label = 'Python', args = { 'python3' } },
  { label = 'Node', args = { 'node' } },
}

return config
