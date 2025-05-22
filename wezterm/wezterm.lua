local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- Set your color scheme.
config.color_scheme = "Tokyo Night Storm"
config.window_background_opacity = 0.6
config.macos_window_background_blur = 30

config.switch_to_last_active_tab_when_closing_tab = true
config.font_size = 13.0

-- Retrieve built‑in schemes so we can dynamically pull colors.
local builtin_schemes = wezterm.color.get_builtin_schemes()
local scheme = builtin_schemes[config.color_scheme] or {}

config.window_frame = {
  font = wezterm.font("MesloLGS NF"),
  active_titlebar_bg = scheme.background or "#232634",
}
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.colors = {
  selection_bg = scheme.selection_bg or "#8caaee",
  selection_fg = scheme.selection_fg or "#232634",
  tab_bar = {
    background = scheme.background or "#232634",
    inactive_tab_edge = scheme.background or "#626880",
    new_tab = {
      bg_color = scheme.background or "#626880",
      fg_color = scheme.foreground or "#232634",
    },
    new_tab_hover = {
      bg_color = scheme.background or "#3b3052",
      fg_color = scheme.foreground or "#232634",
    },
  },
}

-- Define arrow symbols for tab titles.
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Helper function to determine the tab title.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

-- Format tab titles dynamically, ensuring active tab text is clearly visible.
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  -- Re-fetch the current scheme for dynamic coloring.
  local scheme = builtin_schemes[config.color_scheme] or {}

  local edge_background = scheme.background or "#303446"
  local background = scheme.background or "#414559"
  local foreground = scheme.foreground or "#51576d"

  if tab.is_active then
    background = scheme.cursor_bg or "#8caaee"
    -- Explicitly set a contrasting text color for the active tab.
    foreground = scheme.cursor_fg or "#232634"
  elseif hover then
    background = scheme.cursor_bg or "#8caaee"
    foreground = scheme.cursor_fg or "#c6d0f5"
  end

  local edge_foreground = background
  local title = tab_title(tab)
  title = wezterm.truncate_right(title, max_width - 2)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- Dim inactive panes.
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  { key = "a",          mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },
  { key = "s",          mods = "LEADER",      action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v",          mods = "LEADER",      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "h",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
  { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane({ confirm = true }) },
  { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
  { key = "o",          mods = "LEADER",      action = act.RotatePanes("Clockwise") },
  { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
  { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
  { key = "p",          mods = "LEADER",      action = act.ActivateTabRelative(-1) },
  { key = "n",          mods = "LEADER",      action = act.ActivateTabRelative(1) },
  {
    key = "f",
    mods = "CTRL",
    action = act.SplitPane({
      direction = "Right",
      command = { args = { "/Users/jack/bin/nvim_fzf.sh" } },
      size = { Percent = 40 },
    }),
  },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  { key = "m", mods = "LEADER",       action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
  { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  {
    key = "f",
    mods = "ALT",
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "w",
    mods = "CTRL|ALT",
    action = act.PromptInputLine({
      description = "Enter workspace name",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.action.ActivateWorkspace({
            name = line,
          })
        end
      end),
    }),
  },
}

return config
