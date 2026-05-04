return {
  'ibhagwan/fzf-lua',
  event = 'VimEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    'default-title',
    winopts = {
      height = 0.85,
      width = 0.85,
      preview = { default = 'bat' },
    },
    keymap = {
      builtin = {
        ['<C-/>'] = 'toggle-help',
        ['<C-d>'] = 'preview-page-down',
        ['<C-u>'] = 'preview-page-up',
      },
    },
  },
  config = function(_, opts)
    local fzf = require 'fzf-lua'
    fzf.setup(opts)
    fzf.register_ui_select()

    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { desc = desc })
    end

    map('<leader>sh', fzf.helptags, '[S]earch [H]elp')
    map('<leader>sk', fzf.keymaps, '[S]earch [K]eymaps')
    map('<leader>sf', fzf.files, '[S]earch [F]iles')
    map('<leader>ss', fzf.builtin, '[S]earch [S]elect picker')
    map('<leader>sw', fzf.grep_cword, '[S]earch current [W]ord')
    map('<leader>sg', fzf.live_grep, '[S]earch by [G]rep')
    map('<leader>sd', fzf.diagnostics_workspace, '[S]earch [D]iagnostics')
    map('<leader>sr', fzf.resume, '[S]earch [R]esume')
    map('<leader>s.', fzf.oldfiles, '[S]earch Recent Files')
    map('<leader><leader>', fzf.buffers, '[ ] Find existing buffers')
    map('<leader>/', fzf.lgrep_curbuf, '[/] Fuzzily search in current buffer')

    map('<leader>s/', function()
      fzf.live_grep { search_paths = vim.tbl_map(vim.api.nvim_buf_get_name, vim.api.nvim_list_bufs()) }
    end, '[S]earch [/] in Open Files')

    map('<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, '[S]earch [N]eovim files')
  end,
}
