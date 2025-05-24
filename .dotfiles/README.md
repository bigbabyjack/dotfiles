# Dotfiles

Cross-platform dotfiles configuration for macOS and Arch Linux with profile support.

## Features

- 🍎 **macOS Support**: AeroSpace window manager, borders, Homebrew packages
- 🐧 **Arch Linux Support**: Pacman/AUR packages, systemd services
- 👤 **Profile System**: Work/Personal configurations (macOS)
- 🔗 **GNU Stow**: Clean symlink management
- ⚡ **Starship Prompt**: Fast, customizable shell prompt
- 🛠️ **Development Tools**: Rust, Go, Python, Node.js, and more

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the bootstrap script:**
   ```bash
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```

3. **Restart your shell:**
   ```bash
   exec zsh
   ```

## Structure

```
dotfiles/
├── bootstrap.sh              # Main setup script
├── .env.example             # Environment template
├── .gitignore               # Git ignore rules
├── .editorconfig           # Editor configuration
├── scripts/                # Setup scripts
│   ├── utils.sh            # Utility functions
│   ├── install-packages.sh # Package installation
│   ├── setup-macos.sh      # macOS specific setup
│   ├── setup-arch.sh       # Arch Linux specific setup
│   └── setup-profiles.sh   # Profile configuration
└── config/                 # Stow packages
    ├── git/                # Git configuration
    ├── nvim/               # Neovim configuration
    ├── zsh/                # Zsh configuration
    ├── wezterm/            # WezTerm configuration
    ├── starship/           # Starship prompt config
    ├── aerospace/          # AeroSpace (macOS only)
    └── borders/            # Borders (macOS only)
```

## Profiles (macOS)

The dotfiles support Work/Personal profiles on macOS:

### Setup Profiles

1. **Create environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit the DEV_ENV variable:**
   ```bash
   # For work setup
   DEV_ENV=work
   
   # For personal setup  
   DEV_ENV=personal
   ```

3. **Configure profile-specific files:**
   - Edit `git/.gitconfig-work` and `git/.gitconfig-personal`
   - Edit `zsh/.aliases.work.zsh` and `zsh/.aliases.personal.zsh`

### Switching Profiles

Change the `DEV_ENV` variable in `.env` and restart your shell:

```bash
echo "DEV_ENV=work" > .env
exec zsh
```

The prompt will show your current environment:
- 🏢 Work environment
- 🏠 Personal environment

## Package Management

### Shared Packages (Both OS)
- **Development**: git, neovim, make, unzip
- **Shell**: zsh, starship, eza, fd, ripgrep, btop
- **Languages**: go, python3, nodejs, rust
- **Tools**: lazygit, wezterm

### macOS Specific
- **Package Manager**: Homebrew
- **Window Management**: AeroSpace, borders
- **Terminal**: WezTerm (via Homebrew Cask)

### Arch Linux Specific
- **Package Managers**: pacman, yay (AUR)
- **Development**: base-devel, gcc, gdb
- **System**: pipewire, networkmanager, ufw

## Configuration Files

### Git
- Global config with includes for profile-specific settings
- Separate work/personal configurations
- Git credential manager integration

### Zsh
- No oh-my-zsh dependency (lightweight)
- Starship prompt integration
- Git aliases built-in
- Profile-specific aliases and configurations
- Plugin support (autosuggestions, syntax highlighting)

### Neovim
- Based on kickstart.nvim
- LSP configuration for multiple languages
- Plugin management with lazy.nvim
- Custom colorscheme management

### WezTerm
- Lua-based configuration
- Tab management and styling
- Key bindings for pane management
- Integrated with system theme

## Development Setup

### Rust
```bash
# Installed via rustup
rustup component add clippy rustfmt rust-analyzer
```

### Go
```bash
# Workspace setup at ~/go
export GOPATH="$HOME/go"
```

### Python
```bash
# UV package manager
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Node.js
```bash
# Global packages directory
export PATH="$HOME/.npm-global/bin:$PATH"
```

## Troubleshooting

### Missing Template Files
If you see warnings about missing files, they will be created automatically:
- `.gitconfig-work` and `.gitconfig-personal`
- `.aliases.work.zsh` and `.aliases.personal.zsh`

Edit these files to customize your setup.

### Stow Conflicts
If stow reports conflicts:
```bash
# Remove existing files
rm ~/.zshrc ~/.gitconfig

# Re-run stow
cd ~/dotfiles
stow -R zsh git
```

### Package Installation Failures
For missing packages:

**macOS:**
```bash
# Update Homebrew
brew update && brew upgrade

# Install missing packages manually
brew install <package-name>
```

**Arch Linux:**
```bash
# Update package database
sudo pacman -Sy

# Install missing packages manually
sudo pacman -S <package-name>
```

## Customization

### Adding New Packages
Edit `scripts/install-packages.sh` and add to the appropriate package arrays:
- `SHARED_PACKAGES` - Available on both systems
- `MACOS_PACKAGES` - macOS specific
- `ARCH_PACKAGES` - Arch Linux specific

### Adding New Configurations
1. Create a new directory in the root (e.g., `tmux/`)
2. Add your config files with proper home directory structure
3. Update `bootstrap.sh` to include the new stow package

### Profile-Specific Configurations
Add new profile-specific files to `.gitignore` with pattern:
```
.config-work/
.aliases.*.zsh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test on both macOS and Arch Linux (if possible)
4. Submit a pull request

## License

MIT License - feel free to use and modify for your own dotfiles setup.
