-- Markdown-specific configuration for creative writing
-- Follows the same pattern as rust.lua (buffer-local settings and keymaps)

local bufnr = vim.api.nvim_get_current_buf()

-- ============================================================================
-- PROSE-FRIENDLY DISPLAY SETTINGS
-- ============================================================================

-- Enable spell checking (built-in Neovim, no plugin needed!)
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'

-- Word wrapping at word boundaries (not mid-word)
vim.opt_local.wrap = true -- Enable visual wrapping
vim.opt_local.linebreak = true -- Wrap at word boundaries (spaces, hyphens)
vim.opt_local.breakindent = true -- Indent wrapped lines to match paragraph
vim.opt_local.showbreak = '↪ ' -- Visual indicator for wrapped lines

-- Clean UI for writing (hide distracting elements)
vim.opt_local.number = false -- Hide line numbers (distracting for prose)
vim.opt_local.relativenumber = false -- Hide relative line numbers
vim.opt_local.colorcolumn = '' -- Hide column guide (not relevant for prose)
vim.opt_local.list = false -- Hide whitespace characters

-- Paragraph formatting
vim.opt_local.formatoptions:append('t') -- Auto-wrap text using textwidth
vim.opt_local.formatoptions:append('c') -- Auto-wrap comments
vim.opt_local.formatoptions:append('q') -- Allow formatting with 'gq'
vim.opt_local.formatoptions:remove('o') -- Don't continue comments with 'o' or 'O'

-- ============================================================================
-- VISUAL LINE NAVIGATION (j/k move by screen lines, not file lines)
-- ============================================================================

-- In prose, wrapped lines are one continuous thought
-- We want j/k to move by visual lines (what you see on screen)
-- instead of file lines (actual line breaks in the file)
vim.keymap.set('n', 'j', 'gj', { buffer = bufnr, desc = 'Move down by visual line' })
vim.keymap.set('n', 'k', 'gk', { buffer = bufnr, desc = 'Move up by visual line' })
vim.keymap.set('n', '0', 'g0', { buffer = bufnr, desc = 'Go to visual line start' })
vim.keymap.set('n', '$', 'g$', { buffer = bufnr, desc = 'Go to visual line end' })

-- Keep regular line navigation available with g-prefixed commands
vim.keymap.set('n', 'gj', 'j', { buffer = bufnr, desc = 'Move down by file line' })
vim.keymap.set('n', 'gk', 'k', { buffer = bufnr, desc = 'Move up by file line' })

-- ============================================================================
-- WRITING-SPECIFIC KEYMAPS (<leader>w prefix)
-- ============================================================================

-- Word count (words, characters, lines)
vim.keymap.set('n', '<leader>wc', function()
  local word_count = vim.fn.wordcount()
  local message = string.format(
    'Words: %d | Characters: %d | Lines: %d',
    word_count.words,
    word_count.chars,
    vim.fn.line('$')
  )
  vim.notify(message, vim.log.levels.INFO)
end, { buffer = bufnr, desc = '[W]ord [C]ount' })

-- Visual mode word count (selected text only)
vim.keymap.set('v', '<leader>wc', function()
  local word_count = vim.fn.wordcount()
  local message = string.format(
    'Selected - Words: %d | Characters: %d',
    word_count.visual_words or 0,
    word_count.visual_chars or 0
  )
  vim.notify(message, vim.log.levels.INFO)
end, { buffer = bufnr, desc = '[W]ord [C]ount (selection)' })

-- ============================================================================
-- TOGGLE KEYMAPS (<leader>t prefix)
-- ============================================================================

-- Toggle spell checking
vim.keymap.set('n', '<leader>ts', function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  local status = vim.opt_local.spell:get() and 'enabled' or 'disabled'
  vim.notify('Spell check ' .. status, vim.log.levels.INFO)
end, { buffer = bufnr, desc = '[T]oggle [S]pell check' })

-- Toggle vim-pencil wrap mode (soft vs hard wrap)
-- Note: Requires vim-pencil plugin to be installed (:Lazy sync)
vim.keymap.set('n', '<leader>tp', function()
  -- Check if vim-pencil commands are available
  if vim.fn.exists(':SoftPencil') ~= 2 then
    vim.notify('vim-pencil not installed. Run :Lazy sync to install.', vim.log.levels.WARN)
    return
  end

  -- Use buffer variable to track pencil mode
  -- Default to 'soft' if not set (matches our autocommand default)
  local current_mode = vim.b.pencil_mode or 'soft'

  if current_mode == 'soft' then
    vim.cmd('HardPencil')
    vim.b.pencil_mode = 'hard'
    vim.notify('Hard wrap mode (inserts line breaks at 80 chars)', vim.log.levels.INFO)
  else
    vim.cmd('SoftPencil')
    vim.b.pencil_mode = 'soft'
    vim.notify('Soft wrap mode (visual wrapping only)', vim.log.levels.INFO)
  end
end, { buffer = bufnr, desc = '[T]oggle [P]encil wrap mode' })

-- ============================================================================
-- SPELL CHECKING NAVIGATION
-- ============================================================================

-- Navigate to next/previous misspelled word
-- (Built-in Vim commands, just adding descriptions for which-key)
vim.keymap.set('n', ']s', ']s', { buffer = bufnr, desc = 'Next misspelled word' })
vim.keymap.set('n', '[s', '[s', { buffer = bufnr, desc = 'Previous misspelled word' })

-- Spell suggestions (z= is built-in, adding description)
vim.keymap.set('n', 'z=', 'z=', { buffer = bufnr, desc = 'Spelling suggestions' })

-- Add word to dictionary (zg is built-in, adding description)
vim.keymap.set('n', 'zg', 'zg', { buffer = bufnr, desc = 'Add word to dictionary' })

-- Mark as misspelled (zw is built-in, adding description)
vim.keymap.set('n', 'zw', 'zw', { buffer = bufnr, desc = 'Mark word as misspelled' })

-- ============================================================================
-- MARKDOWN PREVIEW KEYMAPS (<leader>m prefix)
-- ============================================================================

-- Start markdown preview (requires markdown-preview.nvim plugin)
vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', {
  buffer = bufnr,
  desc = '[M]arkdown [P]review start',
})

-- Stop markdown preview
vim.keymap.set('n', '<leader>ms', '<cmd>MarkdownPreviewStop<CR>', {
  buffer = bufnr,
  desc = '[M]arkdown preview [S]top',
})

-- Toggle markdown preview
vim.keymap.set('n', '<leader>mt', '<cmd>MarkdownPreviewToggle<CR>', {
  buffer = bufnr,
  desc = '[M]arkdown preview [T]oggle',
})
