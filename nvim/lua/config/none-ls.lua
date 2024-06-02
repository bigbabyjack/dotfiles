return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.sylelua,
				null_ls.builtins.code_actions.impl,
				null_ls.builtins.completion.luasnip,
			},
		})
	end,
}
