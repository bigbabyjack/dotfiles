# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform dotfiles for **Arch Linux** (primary) and macOS with GNU Stow for symlink management. Currently running on Arch Linux with Hyprland.

## Key Commands

### Formatting
```bash
stylua nvim/                      # Format all Lua configs in nvim/
stylua nvim/lua/custom/           # Format only custom configs
```

### Configuration Management
```bash
# Apply configurations via GNU Stow (from dotfiles root)
stow nvim                         # Link Neovim config
stow hypr                         # Link Hyprland config
stow zsh                          # Link Zsh config
stow -R <package>                 # Re-link after changes
stow -D <package>                 # Unlink configuration

# Reload configurations
hyprctl reload                    # Reload Hyprland (when in Hyprland session)
source ~/.zshrc                   # Reload shell config
```

### Testing
```bash
# No automated tests - manual validation only
lua -c <file.lua>                 # Check Lua syntax
bash -n <script>.sh               # Check bash syntax
nvim +checkhealth                 # Check Neovim health
```

## Architecture

### Configuration Structure
The repository uses **top-level directories for each application** (not a nested config/ structure):
- Each directory mirrors the home directory structure for Stow
- Configurations are in their native formats (Lua, INI, shell scripts)

### Neovim Architecture (nvim/)
**Based on kickstart.nvim with extensive customization**

Entry point: `nvim/init.lua`
1. Loads custom modules: options, keymaps, autocommands, formatting, theme
2. Bootstraps lazy.nvim plugin manager
3. Imports all plugins from `custom/plugins/` (30+ individual plugin configs)
4. Applies saved colorscheme via colorscheme_manager

**Plugin organization**: One file per plugin in `nvim/lua/custom/plugins/`
- Each file returns a lazy.nvim plugin spec
- Plugins auto-loaded via `{ import = 'custom.plugins' }`

**Colorscheme system** (`custom/colorscheme_manager.lua`):
- Persistent colorscheme selection stored in state file
- Telescope picker for switching schemes
- Keybinds: `<leader>tc` (pick), `<leader>tn` (next), `<leader>tp` (prev)
- Commands: `:ColorSchemeSet`, `:ColorSchemeNext`, `:ColorSchemePrev`, `:ColorSchemePick`

**LSP Architecture** (Neovim 0.11+ Native):
- **NO Mason plugins** - Uses native `vim.lsp.config()` and `vim.lsp.enable()` APIs
- LSP configuration in `custom/lsp-config.lua` (loaded after plugins in init.lua)
- Language servers installed via system package manager (paru/pacman)
- Minimal plugin file: `custom/plugins/lsp.lua` only contains lazydev + schemastore

**Configured Language Servers**:
- **bashls** - Shell scripts (.sh, .bash, .zsh)
- **clangd** - C/C++
- **gopls** - Go
- **jsonls** - JSON with schema validation (via schemastore.nvim)
- **lua_ls** - Lua
- **pyright** - Python type checking
- **ruff** - Python linting/formatting (hover/definition disabled, defers to pyright)
- **yamlls** - YAML with schema validation (via schemastore.nvim)

**Rust Tooling**:
- Uses `rustaceanvim` plugin for enhanced features (NOT lspconfig)
- Provides `:RustLsp runnables`, `:RustLsp debuggables`, enhanced hover
- Configured with clippy on save, all features enabled, inlay hints
- Keybinds: `<leader>rr` (runnables), `<leader>dr` (debuggables)

**LSP Features** (configured in lsp-config.lua):
- Format-on-save with 2s timeout protection (all servers)
- Inlay hints enabled globally (Rust, Go, etc.)
- Document highlighting on cursor hold
- Consistent keybinds: `gd` (definition), `gr` (references), `K` (hover), `<leader>ca` (code action)

### Hyprland Architecture (hypr/)
**Four configuration files** for the Wayland compositor:
- `hyprland.conf` - Main config: keybinds, window rules, animations, layout
- `hypridle.conf` - Idle management
- `hyprlock.conf` - Lock screen
- `hyprpaper.conf` - Wallpaper management

**Key patterns**:
- Uses `$mainMod = ALT` for all window manager keybinds
- Custom scripts in `~/dotfiles/scripts/` for session management
- Window opacity overrides for YouTube/Twitch (see windowrulev2 rules)
- XWayland force_zero_scaling for better rendering

### Shell Architecture (zsh/)
**Lightweight Zsh setup** (no oh-my-zsh):
- `.zshrc` - Main config with plugins, PATH management, tool initialization
- `.aliases.zsh` - Command aliases
- External plugins: zsh-autosuggestions, zsh-syntax-highlighting
- Uses Starship for prompt, Zoxide for directory jumping

### Scripts (scripts/)
Utility scripts referenced by configs:
- `session_switcher.sh` - Tmux session switcher (bound to ALT+T in Hyprland)
- `session_killer.sh` - Kill Tmux sessions
- `tmux-sessionizer` - Custom Tmux session manager
- `confirm_exit_hyprland.sh` - Exit confirmation dialog
- `grub-reboot-menu.sh` - GRUB reboot helper (ALT+SHIFT+R)

## Code Style

### Lua (Neovim configs)
From `.stylua.toml` and `.editorconfig`:
- **Indent**: 2 spaces
- **Column width**: 160 characters
- **Quotes**: Auto prefer single
- **Call parentheses**: None (StyLua style)
- **Line endings**: Unix (LF)

### Shell Scripts
- **Indent**: 2 spaces
- Make new scripts executable: `chmod +x scripts/<name>.sh`

### General
- UTF-8 encoding
- Trim trailing whitespace
- Insert final newline

## Workflow Notes

### Adding/Modifying Neovim Plugins
1. Create or edit file in `nvim/lua/custom/plugins/<plugin>.lua`
2. Return a lazy.nvim spec table
3. Format with `stylua nvim/`
4. Restart Neovim - lazy.nvim auto-detects changes

### Adding Custom Neovim Modules
1. Add to `nvim/lua/custom/<module>.lua`
2. Require in `nvim/init.lua`
3. Format with `stylua nvim/`

### Modifying Hyprland Keybinds
- All user keybinds use `$mainMod` (currently ALT)
- Format: `bind = $mainMod [SHIFT] [CTRL], key, action, params`
- Reload with `hyprctl reload` after changes

### Profile System (macOS only - not active)
The repository supports work/personal profiles on macOS via `.env` file, but this is **not used on Arch Linux**.

## Important Patterns

### Neovim Lazy Loading
Plugins specify lazy-loading via:
- `event` - Load on Neovim event
- `keys` - Load when keymap pressed  
- `ft` - Load for filetype
- `cmd` - Load on command

### Hyprland Window Rules
Use `windowrulev2` for advanced rules with multiple criteria:
```conf
windowrulev2 = opacity 1.0 override 1.0 override,title:(.*YouTube.*)
```

### Path Management in Zsh
Uses `append_path()` function that checks directory existence before adding to PATH.

## File Locations When Stowed

After stowing, configs symlink to:
- `nvim/` → `~/.config/nvim/`
- `hypr/` → `~/.config/hypr/`
- `zsh/.zshrc` → `~/.zshrc`
- `zsh/.aliases.zsh` → `~/.aliases.zsh`
- `scripts/` → `~/.config/scripts/` (referenced by Hyprland keybinds)
