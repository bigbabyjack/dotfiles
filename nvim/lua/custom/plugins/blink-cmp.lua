return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets', 'disrupted/blink-cmp-conventional-commits' },

  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- All presets have the following mappings:
    -- C-space: Open menu or open docs if already open
    -- C-n/C-p or Up/Down: Select next/previous item
    -- C-e: Hide menu
    -- C-k: Toggle signature help (if signature.enabled = true)
    --
    -- See :h blink-cmp-config-keymap for defining your own keymap

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = { documentation = { auto_show = true } },
    signature = { enabled = true, window = { border = 'rounded', treesitter_highlighting = true } },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        conventional_commits = {
          name = 'Conventional Commits',
          module = 'blink-cmp-conventional-commits',
          enabled = function()
            return vim.bo.filetype == 'gitcommit'
          end,
          ---@module 'blink-cmp-conventional-commits'
          ---@type blink-cmp-conventional-commits.Options
          opts = {}, -- none so far
        },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
