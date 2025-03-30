return {
  'ray-x/go.nvim',
  dependencies = { -- optional packages
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup {
      lsp_codelens = false,
      lsp_inlay_hints = {
        enable = false,
      },
    }
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      callback = function()
        -- Set up the fillstruct keymap for Go files
        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>fs', ':GoFillStruct<CR>', { noremap = true, silent = true })

        vim.api.nvim_buf_set_keymap(0, 'n', '<leader>fr', ':GoRun<CR>', { noremap = true, silent = true })

        -- Example: Enable Go code formatting on save
        vim.cmd 'autocmd BufWritePre *.go :silent! lua require("go.format").goimport()'
      end,
    })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
