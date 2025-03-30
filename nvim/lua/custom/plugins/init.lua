return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },
  {
    'folke/zen-mode.nvim',
    config = function()
      require('zen-mode').setup {
        plugins = {
          gitsigns = { enabled = true },
          twilight = { enabled = false },
          wezterm = { enabled = true, font = '+4' },
        },
      }
    end,
    {
      'folke/twilight.nvim',
      opts = {
        wezterm = {
          enabled = true,
          -- can be either an absolute font size or the number of incremental steps
          font = '+4', -- (10% increase per step)
        },
      },
    },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        -- config
      }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
  },
}
