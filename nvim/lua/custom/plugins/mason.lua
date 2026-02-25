return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        -- Web development tooling
        'typescript-language-server',
        'eslint-lsp',
        'html-lsp',
        'css-lsp',
        'tailwindcss-language-server',
        'prettier',
      },
    },
  },
}
