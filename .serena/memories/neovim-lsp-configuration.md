# Neovim LSP Configuration

## Overview
The Neovim LSP configuration uses **native Neovim 0.11+ APIs** (`vim.lsp.config()` and `vim.lsp.enable()`) instead of plugin-based solutions like mason.nvim and nvim-lspconfig.

## Architecture

### Key Files
- `nvim/lua/custom/lsp-config.lua` - Main LSP configuration using native APIs
- `nvim/lua/custom/plugins/lsp.lua` - Minimal plugin file (lazydev + schemastore only)
- `nvim/lua/custom/plugins/rust.lua` - rustaceanvim configuration for Rust
- `nvim/init.lua` - Loads lsp-config.lua after lazy.nvim plugin setup

### Load Order (Critical!)
1. Options, keymaps, autocommands, formatting, theme
2. lazy.nvim setup (loads all plugins including blink.cmp)
3. `require 'custom.lsp-config'` - LSP config loaded AFTER plugins
4. Colorscheme manager

**Why this order matters:** lsp-config.lua uses `blink.cmp` for completion capabilities, so it must load after lazy.nvim loads the plugins.

## Language Servers

### Installation
Language servers are installed via **system package manager** (paru/pacman), NOT Mason:

```bash
paru -S bash-language-server clang gopls vscode-json-languageserver \
        lua-language-server pyright ruff yaml-language-server
```

### Configured Servers (in lsp-config.lua)

1. **bashls** - Shell scripts (.sh, .bash, .zsh)
   - Command: `bash-language-server start`

2. **clangd** - C/C++
   - Command: `clangd`
   - Root markers: compile_commands.json, compile_flags.txt, .git

3. **gopls** - Go
   - Command: `gopls`
   - Root markers: go.work, go.mod, .git

4. **jsonls** - JSON with schema validation
   - Command: `vscode-json-language-server --stdio`
   - Uses schemastore.nvim for automatic schema validation

5. **lua_ls** - Lua
   - Command: `lua-language-server`
   - Setting: completion.callSnippet = 'Replace'
   - lazydev.nvim provides Neovim API completions

6. **pyright** - Python type checking
   - Command: `pyright-langserver --stdio`
   - Setting: disableOrganizeImports = true (ruff handles this)
   - Setting: reportUndefinedVariable = 'none'

7. **ruff** - Python linting/formatting
   - Command: `ruff server`
   - Special handling: hover and definition disabled (defers to pyright)

8. **yamlls** - YAML with schema validation
   - Command: `yaml-language-server --stdio`
   - Uses schemastore.nvim for automatic schema validation

### Rust (rustaceanvim)
**Does NOT use lspconfig** - uses dedicated rustaceanvim plugin:
- Provides enhanced features: `:RustLsp runnables`, `:RustLsp debuggables`
- Configured with clippy on save, all features enabled
- Inlay hints enabled by default
- Special keybinds: `<leader>rr` (runnables), `<leader>dr` (debuggables)

## LSP Features (LspAttach autocmd)

### Keybindings
- `gd` - Go to definition (Telescope)
- `gr` - Go to references (Telescope)
- `gI` - Go to implementation (Telescope)
- `gD` - Go to declaration
- `<leader>D` - Type definition (Telescope)
- `<leader>ds` - Document symbols (Telescope)
- `<leader>ws` - Workspace symbols (Telescope)
- `<leader>rn` - Rename
- `<leader>ca` - Code action
- `K` - Hover documentation

### Auto-features
1. **Format on save** - With 2s timeout protection (async=false, timeout_ms=2000)
2. **Inlay hints** - Enabled globally for all supporting servers (Rust, Go, etc.)
3. **Document highlighting** - Highlights references on CursorHold, clears on CursorMoved

### Special Server Handling
- **ruff**: hover and definition capabilities disabled in LspAttach (lets pyright handle these)

## Configuration Pattern

### Native API Usage
```lua
-- Global capabilities (once for all servers)
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(...),
})

-- Per-server configuration
vim.lsp.config('server_name', {
  cmd = { 'command', 'args' },
  filetypes = { 'ft1', 'ft2' },
  root_markers = { 'marker1', 'marker2' },
  settings = { ... },
})

-- Enable all servers
vim.lsp.enable({ 'bashls', 'clangd', ... })
```

## Plugins

### Removed (no longer needed)
- ❌ mason.nvim
- ❌ mason-lspconfig.nvim
- ❌ mason-tool-installer.nvim
- ❌ nvim-lspconfig (Neovim 0.11+ has this built-in)
- ❌ fidget.nvim (removed due to conflict with transparent theme)

### Kept
- ✅ lazydev.nvim - Provides Neovim Lua API completions
- ✅ schemastore.nvim - JSON/YAML schema catalog for validation
- ✅ rustaceanvim - Enhanced Rust tooling

## Autocommands (custom/autocommands.lua)

### Removed
- Duplicate Rust format-on-save (now handled by LspAttach)

### Changed
- `RustInlayHint` → `LspInlayHint` - Works for all language servers, not just Rust

## Transparent Theme Compatibility

The colorscheme_manager sets `Normal` highlight to `bg = "none"` for transparency. This caused issues with fidget.nvim showing black boxes, so fidget was removed.

## Troubleshooting

### Check LSP Status
- `:LspInfo` - Shows attached clients and configuration
- `:checkhealth lsp` - Check LSP health

### Common Issues
1. **Server not attaching**: Ensure server is installed via paru/pacman
2. **Capabilities error**: Ensure lsp-config.lua loads AFTER lazy.nvim
3. **Format-on-save not working**: Check `:LspInfo` for formatting capability

## Benefits of Native Approach

1. **Faster startup** - Fewer plugins to load
2. **Simpler config** - Direct Neovim API, no plugin abstraction
3. **Better control** - Explicit configuration of every aspect
4. **Future-proof** - Uses latest Neovim built-in features
5. **System integration** - LSPs managed by package manager (updates with system)
