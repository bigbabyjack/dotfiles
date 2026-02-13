-- vim-pencil: Rethinking Vim as a tool for writers
-- Provides intelligent soft/hard wrapping for prose
-- Battle-tested plugin from the writing community
return {
  'preservim/vim-pencil',
  ft = { 'markdown', 'text', 'asciidoc' }, -- Lazy load for writing filetypes
  config = function()
    -- Configuration is mostly done via ftplugin files
    -- This just ensures the plugin is loaded correctly

    -- Optional: Set default wrap mode globally (can override per-filetype)
    -- 'soft' = wrap visually without inserting line breaks
    -- 'hard' = insert actual line breaks at textwidth
    vim.g['pencil#wrapModeDefault'] = 'soft'

    -- Use visual line navigation by default with pencil
    vim.g['pencil#cursorwrap'] = 1

    -- Auto-format settings for hard wrap mode
    vim.g['pencil#autoformat'] = 1 -- Auto-format when using hard wrap
    vim.g['pencil#textwidth'] = 80 -- Default textwidth for hard wrap
  end,
}
