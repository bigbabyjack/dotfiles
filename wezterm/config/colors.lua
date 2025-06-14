local wezterm = require("wezterm")

local M = {}

local function setup_colors(color_scheme)
  -- Color scheme and appearance settings
  M.color_scheme = color_scheme or "Tokyo Night Moon"
  M.window_background_opacity = 1.0
  M.macos_window_background_blur = 80
end

setup_colors()

-- tab
M.enable_tab_bar = true
M.hide_tab_bar_if_only_one_tab = false
M.show_new_tab_button_in_tab_bar = false
M.show_tab_index_in_tab_bar = true
M.status_update_interval = 1000
M.tab_bar_at_bottom = false
M.tab_max_width = 35
M.use_fancy_tab_bar = false

local ICON_MAP = {
  zsh = wezterm.nerdfonts.zsh,
  nvim = wezterm.nerdfonts.vim,

}

local function basename(path)
  return path:match("([^/\\]+)$") or path
end


local function tab_title(tab)
  local pane = tab.active_pane
  local info = pane:get_foreground_process_info()
  if info then
    return basename(info.executable)
  else
    return "shell"
  end
end

-- Tab formatting: pretty tabs with tailored color for active/hover/inactive
function M.setup_tab_formatting()
  wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
      local title = tab_title(tab)
      if tab.is_active then
        return {
          { Background = { Color = 'red' } },
          { Text = ' ' .. title .. ' ' },
        }
      end
      if tab.is_last_active then
        -- Green color and append '*' to previously active tab.
        return {
          { Background = { Color = 'green' } },
          { Text = ' ' .. title .. '*' },
        }
      end
      return title
    end
  )
end

-- Obtain current scheme colors for dynamic theming
local builtin_schemes = wezterm.color.get_builtin_schemes()
local scheme = builtin_schemes[M.color_scheme] or {}

-- Window frame colors
M.window_frame = {
  active_titlebar_bg = scheme.background or "#232634",
}


-- Dim inactive panes for focus
M.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5,
}


return M
