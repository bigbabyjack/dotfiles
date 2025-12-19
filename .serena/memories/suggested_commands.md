# Suggested Commands

## Git Commands (Standard)
```bash
# Common git operations
git status                  # Check repository status
git add <files>             # Stage files
git commit -m "message"     # Commit changes
git push                    # Push to remote
git pull                    # Pull from remote
git log                     # View commit history
git diff                    # View changes

# Branch operations
git branch                  # List branches
git checkout -b <branch>    # Create new branch
git switch <branch>         # Switch branches
```

## File Operations (Linux)
```bash
# Navigation and listing
ls -la                      # List all files with details
eza                         # Modern ls alternative
cd <directory>              # Change directory
pwd                         # Print working directory

# File searching
find . -name "*.lua"        # Find files by name
fd <pattern>                # Modern find alternative
grep -r "pattern" .         # Search in files
rg "pattern"                # Modern grep (ripgrep)

# File operations
cp <source> <dest>          # Copy files
mv <source> <dest>          # Move/rename files
rm <file>                   # Remove files
mkdir <directory>           # Create directory
```

## Neovim Commands
```bash
# Editing Neovim config
nvim nvim/init.lua                          # Edit main config
nvim nvim/lua/custom/plugins/<plugin>.lua   # Edit plugin config

# Format Lua files
stylua nvim/                                # Format all Lua files in nvim/
stylua nvim/lua/custom/                     # Format custom configs
```

## Stow Commands (Symlink Management)
```bash
# From .dotfiles/ or dotfiles root
stow nvim                   # Link Neovim config
stow zsh                    # Link Zsh config
stow hypr                   # Link Hyprland config
stow -R nvim                # Re-link (useful after changes)
stow -D nvim                # Unlink configuration
```

## System Management (Arch Linux)
```bash
# Package management
sudo pacman -S <package>    # Install package
sudo pacman -R <package>    # Remove package
sudo pacman -Syu            # System update
yay -S <package>            # Install from AUR

# System monitoring
btop                        # System resource monitor
fastfetch                   # System information
```

## Hyprland Commands
```bash
# Reload Hyprland config (from within Hyprland)
hyprctl reload

# View Hyprland info
hyprctl monitors            # List monitors
hyprctl clients             # List clients
```

## Development Tools
```bash
# Lazy git (Git TUI)
lazygit

# Tmux
tmux                        # Start tmux
tmux ls                     # List sessions
tmux attach -t <session>    # Attach to session
./scripts/tmux-sessionizer  # Custom session manager
```

## Testing/Validation
```bash
# Validate Lua syntax
lua -c nvim/init.lua                    # Check Lua syntax
lua -c nvim/lua/custom/plugins/*.lua    # Check all plugins

# Check Neovim health
nvim +checkhealth                       # Run health checks
```

## Common Workflows
```bash
# After modifying Neovim config
cd ~/dotfiles
stylua nvim/                            # Format the changes
git add nvim/
git commit -m "Update neovim config"
git push

# After modifying shell scripts
chmod +x scripts/<script>.sh            # Make executable if new
git add scripts/
git commit -m "Add/update script"
git push

# After modifying Hyprland config
git add hypr/
git commit -m "Update hyprland config"
git push
hyprctl reload                          # Apply changes
```
