return {
  'saghen/blink.cmp',
  dependencies = { 'rafamadriz/friendly-snippets', 'disrupted/blink-cmp-conventional-commits' },

  version = '1.*',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = { documentation = { auto_show = true } },
    signature = { enabled = true, window = { border = 'rounded', treesitter_highlighting = true } },

    sources = {
      default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
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
        lazydev = {
          name = 'LazyDev',
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
