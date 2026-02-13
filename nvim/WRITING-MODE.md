# Neovim Creative Writing Mode

Quick reference for using Neovim as a creative writing tool.

## Quick Start

1. Open any markdown file: `nvim my-story.md`
2. Writing features auto-activate (spell check, soft wrap, vim-pencil)
3. Press `<leader>zz` to enter zen mode for distraction-free writing

## Keybindings

### Focus Modes (`<leader>z`)
- `<leader>zz` - Zen mode (clean UI, centered text) - **Best for drafting**
- `<leader>zf` - Zen mode + Twilight (dims inactive paragraphs) - **Best for editing/revising**
- `<leader>zt` - Toggle Twilight only (paragraph focus without zen mode)

### Writing Utils (`<leader>w`)
- `<leader>wc` - Word count (normal mode: whole file, visual mode: selection)

### Toggles (`<leader>t`)
- `<leader>ts` - Toggle spell checking on/off
- `<leader>tp` - Toggle vim-pencil wrap mode (soft wrap ↔ hard wrap)

### Markdown (`<leader>m`)
- `<leader>mp` - Start markdown preview in browser
- `<leader>ms` - Stop markdown preview
- `<leader>mt` - Toggle markdown preview

### Spell Checking
- `]s` - Jump to next misspelled word
- `[s` - Jump to previous misspelled word
- `z=` - Show spelling suggestions for word under cursor
- `zg` - Add word to dictionary
- `zw` - Mark word as misspelled

### Navigation
- `j` / `k` - Move by visual lines (screen lines, not file lines)
- `gj` / `gk` - Move by file lines (actual line breaks)
- `0` / `$` - Move to visual line start/end
- `g0` / `g$` - Move to file line start/end

## Auto-Enabled Features

When you open a markdown/text file, these are automatically enabled:

✓ Spell checking (en_us)
✓ Soft word wrap at word boundaries
✓ Indented wrapped lines
✓ Visual line navigation (j/k move by screen lines)
✓ Clean UI (no line numbers, no column guides)
✓ vim-pencil soft wrap mode

## Workflow Tips

### Drafting (Initial Writing)
- Use `<leader>zz` (zen mode without twilight)
- Less distracting, lets you see more context
- Focus on getting words down, not perfection

### Editing/Revising
- Use `<leader>zf` (zen mode with twilight)
- Dims everything except current paragraph
- Helps you focus on one section at a time
- Great for line-editing and polishing

### Quick Edits
- Don't use zen mode
- Work in normal view
- Faster for small changes

### Reviewing Final Output
- Use `<leader>mp` to open markdown preview
- See how your markdown renders
- Live updates as you edit

## Wrap Modes

**Soft Wrap** (default):
- Lines wrap visually, no actual line breaks inserted
- Text flows naturally like a modern word processor
- Best for creative writing (flexibility to reformat later)
- Toggle: `<leader>tp` or `:SoftPencil`

**Hard Wrap**:
- Inserts actual line breaks (`\n`) at textwidth (80 chars)
- Like email or git commit messages
- Best for technical writing, documentation
- Toggle: `<leader>tp` or `:HardPencil`

## Customization

### Change Zen Mode Width
Edit `/Users/jack/dotfiles/nvim/lua/custom/plugins/zen-mode.lua`:
```lua
width = 90, -- Change this number (60-120 recommended)
```

### Change Twilight Dimming
Edit `/Users/jack/dotfiles/nvim/lua/custom/plugins/twilight.lua`:
```lua
alpha = 0.25, -- 0 = no dim, 1 = completely hidden
```

### Change Spell Language
Edit `/Users/jack/dotfiles/nvim/after/ftplugin/markdown.lua`:
```lua
vim.opt_local.spelllang = 'en_us' -- Change to 'en_gb', etc.
```

### Disable Auto-Features
Edit `/Users/jack/dotfiles/nvim/lua/custom/autocommands.lua`:
Comment out the WritingMode autocmd to disable auto-activation.

## Comparison: Zen Mode vs No-Neck-Pain

You have **both** plugins installed - use them for different purposes:

**zen-mode.nvim** (`<leader>zz`):
- Hides UI chrome (statusline, line numbers, etc.)
- Integrates with twilight for paragraph focus
- Best for: Writing, reading, focused work

**no-neck-pain.nvim** (`<leader>nn`):
- Centers content with padding buffers
- Keeps UI elements visible
- Best for: Code review, side-by-side comparison

## Troubleshooting

**Spell check not working?**
- Check if enabled: `:set spell?` (should show `spell`)
- Toggle: `<leader>ts`
- Check language: `:set spelllang?`

**Word count shows 0?**
- Make sure you're in a markdown/text buffer
- Try `:echo wordcount()` to see raw output

**Zen mode keybindings not working?**
- Plugins lazy load - try `:ZenMode` first to load the plugin
- Check `:Lazy` to ensure plugins installed

**Pencil not auto-enabling?**
- Check filetype: `:set filetype?` (should be `markdown` or `text`)
- Manually enable: `:SoftPencil`

## Future Enhancements

Want more features? Consider adding:

**Grammar Checking**:
- Install LTeX language server: `:MasonInstall ltex-ls`
- Configure in lsp-config.lua
- Provides grammar and style suggestions

**Thesaurus**:
- Install vim-lexical plugin
- Adds synonym lookup and word completion

**Distraction-Free by Default**:
- Add autocommand to auto-enable zen mode for markdown files
- See autocommands.lua for examples
