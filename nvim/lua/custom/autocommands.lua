vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "BlinkCmpMenuClose",
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

-- Auto-format Rust files on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
  end,
  group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
})

-- Highlight rust_analyzer inlay hints
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "RustInlayHint", { fg = "#7d8590", italic = true })
  end,
})

-- ============================================================================
-- CREATIVE WRITING AUTOCOMMANDS
-- ============================================================================

-- Auto-enable vim-pencil for prose files (soft wrap mode by default)
-- Note: vim-pencil must be installed first via :Lazy sync
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "asciidoc" },
  callback = function()
    -- Check if vim-pencil is available before trying to use it
    if vim.fn.exists(':SoftPencil') == 2 then
      vim.cmd("SoftPencil")
      vim.b.pencil_mode = 'soft'
    end
  end,
  group = vim.api.nvim_create_augroup("WritingMode", { clear = true }),
  desc = "Enable vim-pencil soft wrap for prose files",
})
