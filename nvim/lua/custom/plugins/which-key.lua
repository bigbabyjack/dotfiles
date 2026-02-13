return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VeryLazy',
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      { '', group = '[C]ode' },
      { '', desc = '<leader>r_', hidden = true },
      { '', group = '[S]earch' },
      { '', desc = '<leader>s_', hidden = true },
      { '', group = '[W]orkspace' },
      { '', group = '[R]ename' },
      { '', group = '[D]ocument' },
      { '', desc = '<leader>d_', hidden = true },
      { '', desc = '<leader>c_', hidden = true },
      { '', desc = '<leader>w_', hidden = true },
      -- Writing/Focus mode groups
      { '<leader>z', group = '[Z]en/Focus modes' },
      { '<leader>m', group = '[M]arkdown' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]riting utils' },
    }
  end,
}
