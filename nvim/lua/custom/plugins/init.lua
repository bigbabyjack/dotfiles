-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--
return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		{
			"folke/twilight.nvim",
			opts = {
				wezterm = {
					enabled = true,
					-- can be either an absolute font size or the number of incremental steps
					font = "+4", -- (10% increase per step)
				},
			},
		},
		{
			"stevearc/oil.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				require("oil").setup({
					columns = { "icon" },
					keymaps = {
						["<C-h>"] = false,
						["<M-h>"] = "actions.select_split",
					},
					view_options = {
						show_hidden = true,
					},
				})

				-- Open parent directory in current window
				vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

				-- Open parent directory in floating window
				vim.keymap.set("n", "<space>-", require("oil").toggle_float)
			end,
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { theme = "catppuccin-frappe" },
	},
}
