-- zen-mode.nvim: Distraction-free coding/writing
-- Hides UI chrome (line numbers, statusline, etc.) for laser focus
-- Integrates with twilight.nvim for paragraph dimming
return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode', -- Lazy load on :ZenMode command
  opts = {
    window = {
      backdrop = 0.95, -- Shade the backdrop of the Zen window
      width = 90, -- Optimal reading width for prose (60-90 chars is standard)
      height = 1, -- Use full height
      options = {
        signcolumn = 'no', -- Disable sign column (git signs, diagnostics)
        number = false, -- Disable line numbers
        relativenumber = false, -- Disable relative line numbers
        cursorline = false, -- Disable cursor line highlighting
        cursorcolumn = false, -- Disable cursor column highlighting
        foldcolumn = '0', -- Disable fold column
        list = false, -- Disable whitespace characters
      },
    },
    plugins = {
      -- Disable plugins that might distract
      options = {
        enabled = true,
        ruler = false, -- Disable ruler in command line
        showcmd = false, -- Disable showing commands in status line
        laststatus = 0, -- Hide status line completely
      },
      twilight = { enabled = true }, -- Enable twilight by default (can be toggled)
      gitsigns = { enabled = false }, -- Disable git signs in zen mode
      tmux = { enabled = false }, -- Don't change tmux status bar
    },
  },
}
