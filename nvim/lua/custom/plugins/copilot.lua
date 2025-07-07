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
      filetypes = {
        rust = false
      }
    }


    vim.keymap.set('n', '<leader>cpt', function()
      print("Toggling copilot")
      require("copilot.suggestion").toggle_auto_trigger()
    end, { noremap = true, silent = true, desc = "Toggle Copilot auto trigger" })
  end,
}
