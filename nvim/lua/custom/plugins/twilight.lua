-- twilight.nvim: Dims inactive portions of the code/text
-- Great for focusing on current paragraph during editing/revising
-- Works standalone or with zen-mode
return {
  'folke/twilight.nvim',
  cmd = 'Twilight', -- Lazy load on :Twilight command
  opts = {
    dimming = {
      alpha = 0.25, -- Amount of dimming (0 = no dim, 1 = completely hidden)
      color = { 'Normal', '#ffffff' }, -- Use Normal highlight group or fallback to white
      term_bg = '#000000', -- Background color for terminal
      inactive = false, -- Keep windows active (not dimmed completely)
    },
    context = 15, -- Number of lines to keep lit around cursor (current paragraph)
    treesitter = true, -- Use treesitter for better context awareness
    expand = { -- Expand context for specific syntax nodes
      'function',
      'method',
      'table',
      'if_statement',
      'paragraph', -- Markdown paragraphs
    },
  },
}
