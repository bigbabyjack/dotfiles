local ensure_installed = {
  'bash',
  'c',
  'go',
  'html',
  'javascript',
  'lua',
  'luadoc',
  'markdown',
  'markdown_inline',
  'python',
  'rust',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = ensure_installed,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'

      local sel = function(group)
        return function()
          select.select_textobject(group, 'textobjects')
        end
      end

      for lhs, group in pairs {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
        ['ab'] = '@block.outer',
        ['ib'] = '@block.inner',
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
      } do
        vim.keymap.set({ 'x', 'o' }, lhs, sel(group), { desc = 'select ' .. group })
      end

      for lhs, group in pairs {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move.goto_next_start(group, 'textobjects')
        end, { desc = 'next start ' .. group })
      end

      for lhs, group in pairs {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move.goto_next_end(group, 'textobjects')
        end, { desc = 'next end ' .. group })
      end

      for lhs, group in pairs {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move.goto_previous_start(group, 'textobjects')
        end, { desc = 'prev start ' .. group })
      end

      for lhs, group in pairs {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      } do
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          move.goto_previous_end(group, 'textobjects')
        end, { desc = 'prev end ' .. group })
      end
    end,
  },
}
