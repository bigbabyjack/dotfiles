return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },                   -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      window = {
        layout = 'float',
        border = 'rounded'
      }
    },
    vim.keymap.set(
      'n',
      '<leader>cc',
      function()
        require("CopilotChat").toggle()
      end,
      { noremap = true, silent = true, desc = "Toggle Copilot Chat" }
    )
  },
}
