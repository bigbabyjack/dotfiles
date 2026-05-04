return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'python', 'go', 'javascript', 'typescript', 'rust' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
      select = {
        enable = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
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
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
    config = function(_, opts)
      -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup(opts)

      -- nvim-treesitter master is archived; on Neovim 0.12 `match[capture_id]`
      -- is always `TSNode[]` (the legacy `all=false` opt-out was removed),
      -- so the plugin's directives crash with `attempt to call method 'range'`.
      local query = require 'vim.treesitter.query'
      local function first(match, id)
        local n = match[id]
        if type(n) == 'table' then
          return n[1]
        end
        return n
      end
      local injection_aliases = { ex = 'elixir', pl = 'perl', sh = 'bash', uxn = 'uxntal', ts = 'typescript' }
      local html_mime = {
        importmap = 'json',
        module = 'javascript',
        ['application/ecmascript'] = 'javascript',
        ['text/ecmascript'] = 'javascript',
      }
      query.add_directive('set-lang-from-info-string!', function(match, _, bufnr, pred, metadata)
        local node = first(match, pred[2])
        if not node then
          return
        end
        local alias = vim.treesitter.get_node_text(node, bufnr):lower()
        metadata['injection.language'] = vim.filetype.match { filename = 'a.' .. alias } or injection_aliases[alias] or alias
      end, { force = true })
      query.add_directive('set-lang-from-mimetype!', function(match, _, bufnr, pred, metadata)
        local node = first(match, pred[2])
        if not node then
          return
        end
        local val = vim.treesitter.get_node_text(node, bufnr)
        if html_mime[val] then
          metadata['injection.language'] = html_mime[val]
        else
          local parts = vim.split(val, '/', {})
          metadata['injection.language'] = parts[#parts]
        end
      end, { force = true })
      query.add_directive('downcase!', function(match, _, bufnr, pred, metadata)
        local id = pred[2]
        local node = first(match, id)
        if not node then
          return
        end
        local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ''
        metadata[id] = metadata[id] or {}
        metadata[id].text = string.lower(text)
      end, { force = true })
      query.add_predicate('kind-eq?', function(match, _, _, pred)
        local node = first(match, pred[2])
        if not node then
          return true
        end
        local types = vim.list_slice(pred, 3)
        return vim.tbl_contains(types, node:type())
      end, { force = true })
    end,
  },
}
