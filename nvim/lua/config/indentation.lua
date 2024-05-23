local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "typescript", "javascript", "lua" },
		callback = function()
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
			vim.opt_local.expandtab = true
			vim.b.sleuth_automatic = false
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "go" },
		callback = function()
			vim.opt_local.shiftwidth = 4
			vim.opt_local.tabstop = 4
			vim.opt_local.expandtab = false
			vim.b.sleuth_automatic = false
		end,
	})
end

return M
