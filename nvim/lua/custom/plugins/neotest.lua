return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('neotest-python')({
          dap = { justMyCode = false },
          runner = 'pytest',
          -- Use uv-managed Python - auto-detects .venv or falls back to system python3
          python = function()
            -- Try to get python from uv's virtual environment
            local handle = io.popen('uv run which python3 2>/dev/null')
            if handle then
              local result = handle:read('*a')
              handle:close()
              if result and result ~= '' then
                return vim.trim(result)
              end
            end
            -- Fallback to python3 if uv isn't available or no venv
            return 'python3'
          end,
        }),
      },
      icons = {
        running = '',
        passed = '',
        failed = '',
        skipped = '',
        unknown = '',
      },
    })

    -- Keymaps for testing
    vim.keymap.set('n', '<leader>tt', function()
      require('neotest').run.run()
    end, { desc = '[T]est nearest' })

    vim.keymap.set('n', '<leader>tf', function()
      require('neotest').run.run(vim.fn.expand('%'))
    end, { desc = '[T]est [F]ile' })

    vim.keymap.set('n', '<leader>td', function()
      require('neotest').run.run({ strategy = 'dap' })
    end, { desc = '[T]est [D]ebug' })

    vim.keymap.set('n', '<leader>ts', function()
      require('neotest').summary.toggle()
    end, { desc = '[T]est [S]ummary' })

    vim.keymap.set('n', '<leader>to', function()
      require('neotest').output.open({ enter = true })
    end, { desc = '[T]est [O]utput' })

    vim.keymap.set('n', '<leader>tO', function()
      require('neotest').output_panel.toggle()
    end, { desc = '[T]est [O]utput panel' })

    vim.keymap.set('n', '[t', function()
      require('neotest').jump.prev({ status = 'failed' })
    end, { desc = 'Jump to previous failed test' })

    vim.keymap.set('n', ']t', function()
      require('neotest').jump.next({ status = 'failed' })
    end, { desc = 'Jump to next failed test' })
  end,
}
