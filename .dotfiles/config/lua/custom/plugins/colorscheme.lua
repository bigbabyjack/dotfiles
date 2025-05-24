return { {
  'sainnhe/gruvbox-material',
  lazy = true,
  priority = 1000,
  opts = {
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
    },
  }
},
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = {
      style = "day",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      }
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
    opts = {
      variant = "moon",
      disable_italics = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = false },
        variables = { italic = false },
      }
    },
  },
  {
    "catppuccin/nvim",
    as = "catppuccin",
    lazy = true,
    priority = 1000,
    opts = {
      flavour = "mocha", -- picks the warmest tones
      integrations = {
        treesitter = true,
        telescope = true,
        native_lsp = { enabled = true },
      },
    }
  }
}
