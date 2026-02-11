return {
  "folke/tokyonight.nvim",
  priority = 1000,
  opts = {
    style = "moon",
    transparent = false,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      functions = { italic = true },
      variables = {},
    },
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd.colorscheme("tokyonight")
  end,
}
