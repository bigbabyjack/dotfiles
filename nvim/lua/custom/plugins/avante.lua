return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  build = "make",
  version = false,
  opts = {
    ------------------------------------------------------------------
    -- 1.  Chat uses the stock “ollama” provider but with a big model
    ------------------------------------------------------------------
    provider = "ollama",
    ollama = {
      model    = "llama3.2:3b", -- chat model
      endpoint = "http://127.0.0.1:11434",
    },

    ------------------------------------------------------------------
    -- 2.  Autosuggest uses a *custom* provider that inherits ollama
    ------------------------------------------------------------------
    -- auto_suggestions_provider = "ollama_3b",
    -- vendors = {
    --   ollama_3b = {
    --     __inherited_from = "ollama",
    --     model            = "llama3.2:3b", -- light model for inline ghost-text
    --   },
    -- },

    behaviour = { auto_suggestions = true, auto_set_keymaps = true, use_cwd_as_project_root = true },
    suggestion = { debounce = 800, throttle = 800 },
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
