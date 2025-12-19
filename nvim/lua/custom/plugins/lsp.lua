return {
  -- lazydev for Lua LSP completion in Neovim config
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  -- schemastore for JSON/YAML schemas
  { 'b0o/schemastore.nvim' },

  -- LSP status notifications removed due to conflict with transparent theme
  -- If you want LSP progress, you can check your statusline instead
}
