return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  version = false,
  opts = {
    provider = "copilot",
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4.1-nano",
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      temperature = 0,
      max_completion_tokens = 8192,
    },
    behaviour = { auto_suggestions = true, auto_set_keymaps = true, use_cwd_as_project_root = true, enable_cursor_planning_mode = true },
    mappings = {
      suggestion = { accept = "<M-l>", next = "<M-]>", prev = "<M-[>", dismiss = "<C-]>" },
      submit     = { normal = "<CR>", insert = "<C-s>" },
    },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  -- sidebar / toggle helpers
  keys = {
    {
      "<leader>aa",
      function() require("avante.api").ask() end,
      mode = { "n", "v" },
      desc = "Avante: Ask"
    },
    {
      "<leader>at",
      function() require("avante").toggle() end,
      desc = "Avante: Toggle sidebar"
    },
    {
      "<leader>as",
      function()
        local cfg = require("avante.config")
        cfg.behaviour.auto_suggestions = not cfg.behaviour.auto_suggestions
        print("Avante autosuggestions: " .. (cfg.behaviour.auto_suggestions and "ON" or "OFF"))
      end,
      desc = "Avante: Toggle autosuggestions"
    },
  },
}
