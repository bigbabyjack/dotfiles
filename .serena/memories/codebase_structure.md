# Codebase Structure

## Root Directory Layout
```
dotfiles/
├── .dotfiles/              # Legacy/alternative dotfiles setup
├── .serena/                # Serena project files
├── .claude/                # Claude configuration
├── .git/                   # Git repository data
├── nvim/                   # Neovim configuration (Lua-based)
├── hypr/                   # Hyprland window manager configs
├── zsh/                    # Zsh shell configuration
├── tmux/                   # Tmux configuration
├── ghostty/                # Ghostty terminal config
├── waybar/                 # Waybar status bar config
├── wofi/                   # Wofi launcher config
├── dunst/                  # Dunst notification config
├── fastfetch/              # Fastfetch system info config
├── scripts/                # Utility scripts
├── .gitignore              # Git ignore rules
└── .editorconfig           # Editor configuration
```

## Neovim Structure
```
nvim/
├── init.lua                # Main entry point
├── lazy-lock.json          # Plugin version lock file
├── .stylua.toml            # Lua formatter config
└── lua/
    ├── kickstart/          # Kickstart.nvim base
    │   └── health.lua
    └── custom/             # User customizations
        ├── options.lua
        ├── keymaps.lua
        ├── autocommands.lua
        ├── theme.lua
        ├── formatting.lua
        ├── colorscheme_manager.lua
        └── plugins/        # Plugin configurations
            ├── lsp.lua
            ├── treesitter.lua
            ├── telescope.lua
            ├── harpoon.lua
            ├── gitsigns.lua
            ├── copilot.lua
            ├── avante.lua
            ├── blink-cmp.lua
            └── [30+ plugin configs]
```

## Hyprland Configuration
```
hypr/
├── hyprland.conf           # Main Hyprland config
├── hypridle.conf           # Idle daemon config
├── hyprlock.conf           # Lock screen config
└── hyprpaper.conf          # Wallpaper config
```

## Scripts Directory
```
scripts/
├── now_playing.sh          # Media info script
├── session_switcher.sh     # Session management
├── session_killer.sh       # Kill sessions
├── tmux-sessionizer        # Tmux session helper
├── confirm_exit_hyprland.sh # Exit confirmation
└── grub-reboot-menu.sh     # GRUB reboot helper
```

## Configuration Philosophy
- Each application has its own top-level directory
- Configurations use native formats (Lua for nvim, INI for Hyprland)
- Modular plugin system in Neovim (one file per plugin)
- Utility scripts are centralized in scripts/
- Uses kickstart.nvim as base, extended with custom configurations
