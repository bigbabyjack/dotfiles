return { {
  'sainnhe/gruvbox-material',
  priority = 1000,
  opts = {
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
    },
  },
  config = function()
    vim.cmd.colorscheme 'gruvbox-material'
    vim.g.gruvbox_material_background = 'medium'
    vim.g.gruvbox_material_ui_contrast = 'low'
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1

    -- OLED true black background overrides
    vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "MsgArea", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#000000" })

    -- Optional: you may want to handle line numbers, status bar, etc.
    vim.api.nvim_set_hl(0, "LineNr", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000" })
  end,
},
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      }
    }
  },
}
