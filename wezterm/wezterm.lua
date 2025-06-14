-- WezTerm configuration for clarity, maintainability, and dynamic appearance
-- See OpenCode.md for repo/project conventions

local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

wezterm.on("mux-startup", function(_)
  local projects = {
    { name = "DOTFILES",  cwd = "~/dotfiles" },
    { name = "WORKSPACE", cwd = "~/workspace" },
  }

  for _, p in ipairs(projects) do
    local project = mux.spawn_window({
      workspace = p.name,
      cwd = p.cwd,
      args = { "zsh", "-l" }
    })
  end
end)

local config = wezterm.config_builder()

-- Load color configuration
local colors = require("config.colors")

-- Apply color settings
config.color_scheme = colors.color_scheme
config.window_background_opacity = colors.window_background_opacity
config.macos_window_background_blur = colors.macos_window_background_blur
config.window_frame = colors.window_frame
config.inactive_pane_hsb = colors.inactive_pane_hsb

-- Apply tab bar settings
config.enable_tab_bar = colors.enable_tab_bar
config.hide_tab_bar_if_only_one_tab = colors.hide_tab_bar_if_only_one_tab
config.show_new_tab_button_in_tab_bar = colors.show_new_tab_button_in_tab_bar
config.show_tab_index_in_tab_bar = colors.show_tab_index_in_tab_bar
config.status_update_interval = colors.status_update_interval
config.tab_bar_at_bottom = colors.tab_bar_at_bottom
config.tab_max_width = colors.tab_max_width
config.use_fancy_tab_bar = colors.use_fancy_tab_bar

-- Setup tab formatting
colors.setup_tab_formatting()

-- Other settings
config.font_size = 13.0
config.switch_to_last_active_tab_when_closing_tab = true
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

-- Keymaps and leader are loaded from lua/config/keymaps.lua
local keymaps = require("config.keymaps")
config.leader = keymaps.leader
config.keys = keymaps.keys

return config
