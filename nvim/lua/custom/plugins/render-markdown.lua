return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    file_types = { "markdown", "Avante" },
    code = {
      sign = false,
      width = 'block',
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    },
    emphasis = {
      highlight = 'RenderMarkdownItalic',
    },
  },
  ft = { "markdown", "Avante" },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
}
