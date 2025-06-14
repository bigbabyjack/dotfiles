-- Color configuration for WezTerm
-- Handles color scheme, window appearance, and dynamic theming

local wezterm = require("wezterm")

local M = {}

-- Color scheme and appearance settings
M.color_scheme = "Tokyo Night Moon"
M.window_background_opacity = 0.9
M.macos_window_background_blur = 80

-- Obtain current scheme colors for dynamic theming
local builtin_schemes = wezterm.color.get_builtin_schemes()
local scheme = builtin_schemes[M.color_scheme] or {}

-- Window frame colors
M.window_frame = {
  font = wezterm.font("MesloLGS NF"),
  active_titlebar_bg = scheme.background or "#232634",
}

-- Global colors and tab bar colors
-- M.colors = {
--   selection_bg = scheme.selection_bg or "#8caaee",
--   selection_fg = scheme.selection_fg or "#232634",
--   tab_bar = {
--     background = scheme.background or "#232634",
--     inactive_tab_edge = scheme.background or "#626880",
--     new_tab = {
--       bg_color = scheme.background or "#626880",
--       fg_color = scheme.foreground or "#232634",
--     },
--     new_tab_hover = {
--       bg_color = scheme.background or "#3b3052",
--       fg_color = scheme.foreground or "#232634",
--     },
--   },
-- }

-- Dim inactive panes for focus
M.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}

-- Nerd font arrows for visual tab dividers
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Tab title helper: prefers user-set title, else pane title
local function get_tab_title(tab_info)
  return (tab_info.tab_title and #tab_info.tab_title > 0) and tab_info.tab_title or tab_info.active_pane.title
end

-- Tab formatting: pretty tabs with tailored color for active/hover/inactive
function M.setup_tab_formatting()
  wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    local sc = scheme
    local edge_bg = sc.background or "#303446"
    local tab_bg = sc.background or "#414559"
    local tab_fg = sc.foreground or "#51576d"

    if tab.is_active then
      tab_bg = sc.cursor_bg or "#8caaee"
      tab_fg = sc.cursor_fg or "#232634"
    elseif hover then
      tab_bg = sc.cursor_bg or "#8caaee"
      tab_fg = sc.cursor_fg or "#c6d0f5"
    end
    local edge_fg = tab_bg
    local title = wezterm.truncate_right(get_tab_title(tab), max_width - 2)
    return {
      { Background = { Color = edge_bg } },
      { Foreground = { Color = edge_fg } },
      { Text = SOLID_LEFT_ARROW },
      { Background = { Color = tab_bg } },
      { Foreground = { Color = tab_fg } },
      { Text = title },
      { Background = { Color = edge_bg } },
      { Foreground = { Color = edge_fg } },
      { Text = SOLID_RIGHT_ARROW },
    }
  end)
end

return M

