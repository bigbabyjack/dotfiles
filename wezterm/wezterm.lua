-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Determine the operating system
local os_name = wezterm.target_triple

if os_name:find("windows") then
	-- Windows-specific configuration
	config.default_prog = { "wsl.exe" }
	config.launch_menu = {
		{
			label = "PowerShell",
			args = { "powershell.exe", "-NoLogo" },
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe" },
		},
	}
elseif os_name:find("darwin") then
	-- macOS-specific configuration
	config.default_prog = { "/bin/zsh" }
end

-- This is where you actually apply your config choices
config.window_decorations = "RESIZE"

-- For example, changing the color scheme:

config.font = wezterm.font("MesloLGS NF")

local builtin_schemes = wezterm.color.get_builtin_schemes()
local selected_scheme = "Gruvbox Material (Gogh)"
config.color_scheme = selected_scheme
if builtin_schemes[selected_scheme] then
	config.colors = builtin_schemes[selected_scheme]
else
	wezterm.log_warn("Color scheme not found: " .. selected_scheme)
end

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
	local edge_background = config.colors.tab_bar_background
	local background = config.colors.tab_bar_background
	local foreground = config.colors.tab_bar_foreground

	if tab.is_active then
		background = config.colors.tab_active
	elseif hover then
		background = config.colors.tab_hover
		foreground = config.colors.tab_hover_foreground
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
	{
		key = "f",
		mods = "ALT",
		action = wezterm.action.TogglePaneZoomState,
	},
}

-- Define the leader key table
config.key_tables = {
	leader = {
		{ key = "c", action = wezterm.action.ActivateCopyMode },
		-- Split panes
		{ key = "v", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "s", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

		-- Move between panes
		{ key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
		{ key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
		{ key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
		{ key = "l", action = wezterm.action.ActivatePaneDirection("Right") },

		-- Close the current pane
		{ key = "w", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

		-- Exit leader mode explicitly with 'q'
		{ key = "q", action = "PopKeyTable" },
		{
			key = ",",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
	},
}

-- and finally, return the configuration to wezterm
return config
