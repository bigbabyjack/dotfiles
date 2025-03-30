local colorschemes = {}

return {
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
    vim.g.gruvboxmaerial_ui_contrast = 'low'
    vim.g.gruvbox_material_enable_italic = 1
    vim.g.gruvbox_material_better_performance = 1
  end,
}
