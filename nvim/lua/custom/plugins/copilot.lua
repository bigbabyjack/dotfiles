return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('copilot').setup {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = '<C-l>',
          accept_word = '<C-\\>',
        },
      },
      copilot_model = 'gpt-4o-copilot',
      workspace_folders = {},
    }

    local suggestion = require 'copilot.suggestion'

    vim.keymap.set("n", "<leader>cpt", suggestion.toggle_auto_trigger(), { desc = "[T]oggle copilot auto trigger" })
    vim.keymap.set("n", "<leader>cpaw", function()
      vim.cmd('Copilot workspace add ' .. vim.fn.getcwd())
    end)
  end,
}
