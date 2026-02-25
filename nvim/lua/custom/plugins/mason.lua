return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        -- Web dev servers (added now)
        'typescript-language-server',
        'eslint-lsp',
        'vscode-langservers-extracted', -- provides html, cssls, jsonls
        'tailwindcss-language-server',
        'prettier',
      },
    },
  },
}
