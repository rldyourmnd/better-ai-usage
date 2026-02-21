-- ═══════════════════════════════════════════════════════════════════════════════
-- WEZTERM CONFIGURATION - Balanced: Speed + Stability + AI Tools
-- ═══════════════════════════════════════════════════════════════════════════════
-- System: NVIDIA RTX 2070, Vulkan, Wayland
-- Goal: MAXIMUM SPEED with GUARANTEED STABILITY for long-running AI sessions
-- Priority: Stability > Speed > Features

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ═══════════════════════════════════════════════════════════════════════════════
-- GPU RENDERING - OpenGL for MAXIMUM STABILITY
-- ═══════════════════════════════════════════════════════════════════════════════
-- WebGPU + Vulkan caused SIGSEGV with NVIDIA driver 580.x
-- OpenGL is more stable and still GPU-accelerated
config.front_end = 'OpenGL'

-- NOTE: If you want to try WebGPU again later (after driver update),
-- uncomment the following and comment out 'OpenGL' above:
-- config.front_end = 'WebGpu'
-- config.webgpu_power_preference = 'HighPerformance'
-- local gpus = wezterm.gui.enumerate_gpus()
-- for _, gpu in ipairs(gpus) do
--   if gpu.backend == 'Vulkan' and gpu.device_type == 'DiscreteGpu' then
--     config.webgpu_preferred_adapter = gpu
--     break
--   end
-- end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MULTIPLEXER - CRITICAL FOR STABILITY (session persistence)
-- ═══════════════════════════════════════════════════════════════════════════════
-- KEEP ENABLED: If WezTerm GUI crashes, your Claude Code session survives!
-- The 10ms local echo makes it feel instant while maintaining stability
config.unix_domains = {
  {
    name = 'unix',
    socket_path = '/tmp/wezterm-gui-sock',
    local_echo_threshold_ms = 10,  -- Predictive echo = feels instant
  },
}

config.default_gui_startup_args = { 'connect', 'unix' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- RENDERING PERFORMANCE - Zero overhead for AI tool output streaming
-- ═══════════════════════════════════════════════════════════════════════════════
config.max_fps = 120
config.animation_fps = 1
config.cursor_blink_rate = 0
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.text_blink_rate = 0
config.text_blink_rate_rapid = 0

-- Disable ligatures for faster text rendering (STABLE optimization)
-- AI tools stream massive amounts of code with symbols (=>, !=, ===)
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Retro tab bar = faster rendering + MORE STABLE than fancy tab bar
-- Fancy tab bar has more complex rendering pipeline
config.use_fancy_tab_bar = false

-- Scrollback: balanced for cache locality + sufficient history
config.scrollback_lines = 35000

-- ═══════════════════════════════════════════════════════════════════════════════
-- WAYLAND - Native Linux support
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_wayland = true

-- ═══════════════════════════════════════════════════════════════════════════════
-- TERMINAL CAPABILITIES - For modern AI tools
-- ═══════════════════════════════════════════════════════════════════════════════
config.term = 'wezterm'
config.enable_kitty_keyboard = true  -- Advanced keyboard protocol

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEFAULT SHELL - Fish as primary
-- ═══════════════════════════════════════════════════════════════════════════════
config.default_prog = { '/usr/bin/fish', '-l' }

-- ═══════════════════════════════════════════════════════════════════════════════
-- REDUCE OVERHEAD (stable optimizations)
-- ═══════════════════════════════════════════════════════════════════════════════
config.check_for_updates = false
config.audible_bell = 'Disabled'
config.visual_bell = { fade_in_duration_ms = 0, fade_out_duration_ms = 0 }
config.window_close_confirmation = 'NeverPrompt'
config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu', 'cmd.exe', 'pwsh.exe',
}

-- Instant Alt key response
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- ═══════════════════════════════════════════════════════════════════════════════
-- APPEARANCE - Speed-optimized (retro tab bar for stability)
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_scroll_bar = false
config.window_decorations = 'TITLE | RESIZE'  -- MORE STABLE than INTEGRATED_BUTTONS
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = true
config.window_padding = {
  left = 5,
  right = 5,
  top = 5,
  bottom = 5,
}

-- Font configuration
config.font = wezterm.font { family = 'JetBrains Mono', weight = 'Regular' }
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- HYPERLINK RULES - Immediately clickable links in AI tool output
-- ═══════════════════════════════════════════════════════════════════════════════
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Additional rules for AI tool output
table.insert(config.hyperlink_rules, {
  regex = '/[a-zA-Z0-9_./-]+/[a-zA-Z0-9_.-]+',
  format = 'file://$0',
})
table.insert(config.hyperlink_rules, {
  regex = '~/[a-zA-Z0-9_./-]+',
  format = 'file://$0',
})
table.insert(config.hyperlink_rules, {
  regex = '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
  format = 'https://#$0',
})

-- ═══════════════════════════════════════════════════════════════════════════════
-- QUICK SELECT PATTERNS - For AI tool output
-- ═══════════════════════════════════════════════════════════════════════════════
config.quick_select_patterns = {
  '/[a-zA-Z0-9_./-]+/[a-zA-Z0-9_.-]+',
  '~/[a-zA-Z0-9_./-]+',
  'https?://[^\\s]+',
  '\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}(:\\d+)?',
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

  -- Debug and utilities
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
  { key = 'P', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },

  -- Toggle ligatures (useful for code readability)
  { key = 'E', mods = 'CTRL|SHIFT', action = act.EmitEvent 'toggle-ligature' },
}

-- Toggle ligature event
wezterm.on('toggle-ligature', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    overrides.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
  else
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- MOUSE BINDINGS
-- ═══════════════════════════════════════════════════════════════════════════════
config.mouse_bindings = {
  -- Ctrl+Click to open links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CTRL',
    action = act.OpenLinkAtMouseCursor,
  },
  -- Disable Ctrl+Down to avoid issues in vim
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
