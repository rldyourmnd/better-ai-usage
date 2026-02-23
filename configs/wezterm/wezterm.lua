-- ═══════════════════════════════════════════════════════════════════════════════
-- WEZTERM CONFIGURATION - Multi-Monitor Stability for NVIDIA
-- ═══════════════════════════════════════════════════════════════════════════════
-- System: NVIDIA RTX 2070, X11 (Wayland disabled for multi-monitor stability)
-- Goal: GUARANTEED STABILITY for long-running AI sessions on multi-monitor setup
-- Priority: Stability > Speed > Features
--
-- KNOWN ISSUE FIXED: Crashing when moving window to second monitor
-- ROOT CAUSE: NVIDIA + Wayland + Multi-monitor = GPU context loss
-- SOLUTION: Disable Wayland, use X11 for stable multi-monitor support

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ═══════════════════════════════════════════════════════════════════════════════
-- GPU RENDERING - OpenGL for MAXIMUM STABILITY
-- ═══════════════════════════════════════════════════════════════════════════════
-- WebGPU + Vulkan caused SIGSEGV with NVIDIA driver 580.x
-- OpenGL is more stable and still GPU-accelerated
-- Emergency fallback:
--   WEZTERM_SAFE_RENDERER=1 wezterm
-- This keeps default behavior fast/stable while allowing one-command safe mode.
local safe_renderer = os.getenv 'WEZTERM_SAFE_RENDERER' == '1'
if safe_renderer then
  config.front_end = 'Software'
else
  config.front_end = 'OpenGL'
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WAYLAND - DISABLED for NVIDIA Multi-Monitor Stability
-- ═══════════════════════════════════════════════════════════════════════════════
-- CRITICAL: Different refresh rates across monitors cause GPU context loss
-- under Wayland. XWayland is stable for NVIDIA multi-monitor setups.
config.enable_wayland = false

-- FALLBACK: If OpenGL still causes issues, use Software rendering
-- Uncomment below to use CPU-based rendering (slower but most stable):
-- config.front_end = 'Software'

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
-- RENDERING PERFORMANCE - Stable settings for multi-monitor
-- ═══════════════════════════════════════════════════════════════════════════════
-- Conservative 60fps for multi-monitor stability (matches most monitor refresh)
config.max_fps = 60
config.animation_fps = 1
config.cursor_blink_rate = 0
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.text_blink_rate = 0
config.text_blink_rate_rapid = 0

-- Disable ligatures for faster text rendering (STABLE optimization)
-- AI tools stream massive amounts of code with symbols (=>, !=, ===)
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Fancy tab bar: native close buttons, styled chrome via window_frame
config.use_fancy_tab_bar = true

-- Scrollback: lower memory pressure for long AI sessions while keeping deep history.
config.scrollback_lines = 20000

-- ═══════════════════════════════════════════════════════════════════════════════
-- TERMINAL CAPABILITIES - For modern AI tools
-- ═══════════════════════════════════════════════════════════════════════════════
config.term = 'wezterm'
config.enable_kitty_keyboard = true  -- Advanced keyboard protocol

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEFAULT SHELL - Fish as primary (auto-detect path)
-- ═══════════════════════════════════════════════════════════════════════════════
-- Use `command -v` first, then fallback to common install locations.
local function trim(s)
  return (s and s:match('^%s*(.-)%s*$')) or nil
end

local function command_output(cmd)
  local handle = io.popen(cmd)
  if not handle then
    return nil
  end

  local output = handle:read('*l')
  handle:close()
  return trim(output)
end

local function file_exists(path)
  local f = io.open(path, 'r')
  if not f then
    return false
  end
  f:close()
  return true
end

local fish_path = command_output('command -v fish 2>/dev/null')
if not fish_path or fish_path == '' then
  local homebrew_prefix = os.getenv('HOMEBREW_PREFIX')
  local home_dir = os.getenv('HOME') or ''
  local candidates = {
    '/usr/bin/fish',
    '/bin/fish',
    '/usr/local/bin/fish',
    '/usr/local/sbin/fish',
    '/home/linuxbrew/.linuxbrew/bin/fish',
    home_dir .. '/.linuxbrew/bin/fish',
    '/opt/homebrew/bin/fish',
  }

  if homebrew_prefix then
    table.insert(candidates, 1, homebrew_prefix .. '/bin/fish')
  end

  for _, candidate in ipairs(candidates) do
    if file_exists(candidate) then
      fish_path = candidate
      break
    end
  end

  if not fish_path then
    fish_path = '/usr/bin/fish'
  end
end

config.default_prog = { fish_path, '-l' }

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
-- APPEARANCE - Stability-optimized for multi-monitor
-- ═══════════════════════════════════════════════════════════════════════════════
config.enable_scroll_bar = false
config.window_decorations = 'TITLE | RESIZE'
config.window_background_opacity = 1.0  -- NO transparency = better multi-monitor stability
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = true
config.tab_max_width = 32
config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- Font configuration
config.font = wezterm.font_with_fallback {
  { family = 'JetBrains Mono', weight = 'Regular' },
  { family = 'Symbols Nerd Font Mono', weight = 'Regular' },
  { family = 'JetBrainsMono Nerd Font', weight = 'Regular' },
  { family = 'Noto Color Emoji' },
}
config.font_size = 12.0
config.line_height = 1.1

-- Cyberpunk neon color scheme (synced with Starship ultra_ai palette)
config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  background = '#0b1020',
  foreground = '#d7f7ff',
  cursor_bg = '#2cf5ff',
  cursor_fg = '#0b1020',
  cursor_border = '#2cf5ff',
  selection_fg = '#0b1020',
  selection_bg = '#ff4fd8',
  ansi = {
    '#090d1a', '#ff2d95', '#3dffb4', '#f6ff4a',
    '#00d9ff', '#ff4fd8', '#2cf5ff', '#d7f7ff',
  },
  brights = {
    '#7f88bf', '#ff75d8', '#00ffd5', '#f6ff4a',
    '#2cf5ff', '#ff9f1c', '#00d9ff', '#ffffff',
  },
  split = '#ff4fd8',  -- neon pink pane dividers
  tab_bar = {
    background = '#090d1a',
    active_tab = { bg_color = '#111833', fg_color = '#2cf5ff', intensity = 'Bold' },
    inactive_tab = { bg_color = '#090d1a', fg_color = '#7f88bf' },
    inactive_tab_hover = { bg_color = '#111833', fg_color = '#ff4fd8', italic = true },
    new_tab = { bg_color = '#090d1a', fg_color = '#646da1' },
    new_tab_hover = { bg_color = '#111833', fg_color = '#2cf5ff' },
  },
}

-- Fancy tab bar chrome styling
config.window_frame = {
  font = wezterm.font { family = 'JetBrains Mono', weight = 'Bold' },
  font_size = 12.0,
  active_titlebar_bg = '#090d1a',
  inactive_titlebar_bg = '#090d1a',
  button_fg = '#7f88bf',
  button_bg = '#111833',
  button_hover_fg = '#2cf5ff',
  button_hover_bg = '#222050',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- BACKGROUND GRADIENT - Subtle vertical depth
-- ═══════════════════════════════════════════════════════════════════════════════
config.window_background_gradient = {
  orientation = 'Vertical',
  colors = { '#0b1020', '#0a0d1e', '#0d0820' },
  interpolation = 'Linear',
  blend = 'Rgb',
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- PANE FOCUS - Active pane pops, inactive fades
-- ═══════════════════════════════════════════════════════════════════════════════
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
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
-- TAB BAR STYLING - PowerLine arrows with Nerd Fonts
-- ═══════════════════════════════════════════════════════════════════════════════
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then return title end
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  -- Unseen output indicator
  local has_unseen = false
  for _, p in ipairs(tab.panes) do
    if p.has_unseen_output then has_unseen = true; break end
  end

  local indicator = has_unseen and ' ●' or ''
  local title = tab_title(tab)
  title = wezterm.truncate_right(title, max_width - 4)

  return ' ' .. (tab.tab_index + 1) .. ': ' .. title .. indicator .. ' '
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- STATUS BAR - System info (right side of tab bar)
-- ═══════════════════════════════════════════════════════════════════════════════
wezterm.on('update-status', function(window, pane)
  -- LEFT: static neon signature
  window:set_left_status(wezterm.format {
    { Background = { Color = '#090d1a' } },
    { Foreground = { Color = '#ff2d95' } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = ' rldyourmnd ' },
  })

  -- RIGHT: PowerLine segments (cwd, hostname, time, battery)
  local cells = {}
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = type(cwd_uri) == 'userdata' and cwd_uri.file_path or ''
    -- Show only last 2 path components
    cwd = cwd:gsub('^.*/(.-/[^/]+)$', '%1')
    if cwd ~= '' then table.insert(cells, cwd) end
  end
  table.insert(cells, wezterm.hostname():gsub('%..*', ''))
  table.insert(cells, wezterm.strftime('%H:%M'))
  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  end

  -- Color gradient for segments (darker to lighter neon)
  local seg_colors = { '#1a1540', '#222050', '#2a1a5a', '#331a6a' }
  local text_fg = '#d7f7ff'
  local elements = {}
  for i, cell in ipairs(cells) do
    local seg_bg = seg_colors[i] or seg_colors[#seg_colors]
    table.insert(elements, { Foreground = { Color = seg_bg } })
    table.insert(elements, { Background = { Color = i == 1 and '#090d1a' or seg_colors[i - 1] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })
    table.insert(elements, { Background = { Color = seg_bg } })
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Text = ' ' .. cell .. ' ' })
  end
  window:set_right_status(wezterm.format(elements))
end)

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
  { key = 'D', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
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
