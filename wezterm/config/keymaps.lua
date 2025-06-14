-- All keymaps and leader configuration for WezTerm
local wezterm = require("wezterm")
local act = wezterm.action

local keymaps = {}

keymaps.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
keymaps.keys = {
  { key = "a", mods = "LEADER|CTRL",  action = act.SendKey({ key = "a", mods = "CTRL" }) },

  -- Pane management
  { key = "s", mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "v", mods = "LEADER",       action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER",       action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER",       action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER",       action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER",       action = act.ActivatePaneDirection("Right") },
  { key = "z", mods = "LEADER",       action = act.TogglePaneZoomState },
  { key = "q", mods = "LEADER",       action = act.CloseCurrentPane({ confirm = true }) },
  { key = "o", mods = "LEADER",       action = act.RotatePanes("Clockwise") },
  { key = "r", mods = "LEADER",       action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },

  -- Tab management
  { key = "t", mods = "LEADER",       action = act.SpawnTab("CurrentPaneDomain") },
  { key = "p", mods = "LEADER",       action = act.ActivateTabRelative(-1) },
  { key = "n", mods = "LEADER",       action = act.ActivateTabRelative(1) },
  { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },
  { key = "m", mods = "LEADER",       action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
  -- Workspace switch prompt
  { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  {
    key = "w",
    mods = "CTRL|ALT",
    action = act.PromptInputLine {
      description = "Enter workspace name",
      action = wezterm.action_callback(function(_, _, line)
        if line then wezterm.action.ActivateWorkspace({ name = line }) end
      end),
    }
  },

  -- Command palette
  { key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

  -- Zoom via Alt+f as well
  { key = "f",          mods = "ALT",    action = act.TogglePaneZoomState },
}

return keymaps
