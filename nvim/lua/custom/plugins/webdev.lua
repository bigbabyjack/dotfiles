return {
  -- Prettier formatting via conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false, -- Don't fall back to LSP; Prettier or nothing
      },
    },
  },

  -- Auto-close and auto-rename HTML/JSX tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {},
  },
}
