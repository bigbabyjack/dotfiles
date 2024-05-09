local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "typescript", "javascript" },
		callback = function()
			vim.opt_local.shiftwidth = 2
			vim.opt_local.tabstop = 2
			vim.opt_local.expandtab = true
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		pattern = { "typescript", "javascript" },
		callback = function()
			vim.b.sleuth_automatic = false
		end,
	})
end

return M
