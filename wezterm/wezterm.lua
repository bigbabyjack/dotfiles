-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
window_decorations = "RESIZE"
-- For example, changing the color scheme:
config.color_scheme = "rose-pine-moon"

config.window_frame = {
	font = wezterm.font({ family = "JetBrains Mono", weight = "Bold" }),
	active_titlebar_bg = "#232634",
}

config.colors = {
	tab_bar = {
		background = "#626880",
		inactive_tab_edge = "#626880",
	},
}

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#303446"
	local background = "#414559"
	local foreground = "#51576d"

	if tab.is_active then
		background = "#8caaee"
	elseif hover then
		background = "#8caaee"
		foreground = "#c6d0f5"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
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

-- for zenmode in nvim
wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

-- Leader key and keybindings
config.keys = {
	-- Set Ctrl-a as the leader key
	{
		key = "a",
		mods = "CTRL",
		action = wezterm.action.ActivateKeyTable({
			name = "leader",
			one_shot = false,
			timeout_milliseconds = 1000,
		}),
	},
}

-- Define the leader key table
config.key_tables = {
	leader = {
		-- Split panes
		{ key = "v", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "h", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- Move between panes
		{ key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", action = wezterm.action.ActivatePaneDirection("Right") },

		-- Close the current pane
		{ key = "w", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

		-- Exit leader mode explicitly with 'q'
		{ key = "q", action = "PopKeyTable" },
	},
}

-- and finally, return the configuration to wezterm
return config
