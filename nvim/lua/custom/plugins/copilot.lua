return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {},
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = false,
        keymap = {
          accept = '<Tab>',
          accept_word = '<Shift+Tab>',
          accept_line = '<Alt+Tab>',
        },
      },
      copilot_model = 'gpt-4o-copilot',
      workspace_folders = {},
    }
  end,
}
