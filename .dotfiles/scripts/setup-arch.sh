#!/usr/bin/env bash

set -e

# Source utility functions
source "$(dirname "$0")/utils.sh"

setup_yay() {
  log_header "Setting up AUR Helper (yay)"
  
  if command_exists yay; then
    log_success "yay is already installed"
    return 0
  fi
  
  log_info "Installing yay AUR helper..."
  
  # Make sure git and base-devel are installed
  sudo pacman -S --needed --noconfirm git base-devel
  
  # Create temp directory and clone yay
  local temp_dir=$(mktemp -d)
  cd "$temp_dir"
  
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  
  # Cleanup
  cd "$HOME"
  rm -rf "$temp_dir"
  
  log_success "yay installed successfully"
}

setup_development_tools() {
  log_header "Setting up Development Tools"
  
  # Essential development packages
  local dev_packages=(
    "gcc"
    "gdb" 
    "valgrind"
    "strace"
    "ltrace"
    "tree"
    "htop"
    "wget"
    "curl"
    "vim"
    "tmux"
    "man-db"
    "man-pages"
  )
  
  log_info "Installing essential development tools..."
  for package in "${dev_packages[@]}"; do
    install_package "$package"
  done
}

setup_fonts() {
  log_header "Setting up Fonts"
  
  local font_packages=(
    "ttf-fira-code"
    "ttf-jetbrains-mono"
    "noto-fonts"
    "noto-fonts-emoji"
    "ttf-liberation"
  )
  
  log_info "Installing fonts..."
  for font in "${font_packages[@]}"; do
    install_package "$font"
  done
  
  # Install Nerd Fonts from AUR
  local nerd_fonts=(
    "ttf-meslo-nerd"
    "ttf-firacode-nerd"
  )
  
  for font in "${nerd_fonts[@]}"; do
    install_aur_package "$font"
  done
  
  # Refresh font cache
  log_info "Refreshing font cache..."
  fc-cache -fv
}

setup_audio() {
  log_header "Setting up Audio"
  
  # Install PipeWire (modern audio system)
  local audio_packages=(
    "pipewire"
    "pipewire-alsa" 
    "pipewire-pulse"
    "pipewire-jack"
    "wireplumber"
    "pavucontrol"
  )
  
  log_info "Installing PipeWire audio system..."
  for package in "${audio_packages[@]}"; do
    install_package "$package"
  done
  
  # Enable PipeWire services
  log_info "Enabling PipeWire services..."
  systemctl --user enable --now pipewire.service
  systemctl --user enable --now pipewire-pulse.service
  systemctl --user enable --now wireplumber.service
}

setup_display_server() {
  log_header "Setting up Display Server"
  
  # Install Wayland/X11 support
  local display_packages=(
    "wayland"
    "xorg-server"
    "xorg-xwayland" 
    "xorg-xinit"
    "xorg-xrandr"
    "xclip"
    "wl-clipboard"
  )
  
  log_info "Installing display server packages..."
  for package in "${display_packages[@]}"; do
    install_package "$package"
  done
}

setup_networking() {
  log_header "Setting up Networking Tools"
  
  local network_packages=(
    "networkmanager"
    "network-manager-applet"
    "openssh"
    "rsync"
  )
  
  log_info "Installing networking tools..."
  for package in "${network_packages[@]}"; do
    install_package "$package"
  done
  
  # Enable NetworkManager
  log_info "Enabling NetworkManager..."
  sudo systemctl enable --now NetworkManager
  
  # Enable SSH service
  log_info "Enabling SSH service..."
  sudo systemctl enable --now sshd
}

setup_security() {
  log_header "Setting up Security Tools"
  
  local security_packages=(
    "gnupg"
    "pass"
    "ufw"
  )
  
  log_info "Installing security tools..."
  for package in "${security_packages[@]}"; do
    install_package "$package"
  done
  
  # Setup basic firewall
  log_info "Setting up UFW firewall..."
  sudo ufw --force enable
  sudo systemctl enable --now ufw
}

setup_shell_enhancements() {
  log_header "Setting up Shell Enhancements"
  
  # Install zsh plugins that aren't available via package manager
  local zsh_plugins_dir="$HOME/.zsh"
  ensure_dir "$zsh_plugins_dir"
  
  # Install zsh-autosuggestions
  if [[ ! -d "$zsh_plugins_dir/zsh-autosuggestions" ]]; then
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_plugins_dir/zsh-autosuggestions"
  fi
  
  # Install zsh-syntax-highlighting
  if [[ ! -d "$zsh_plugins_dir/zsh-syntax-highlighting" ]]; then
    log_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_plugins_dir/zsh-syntax-highlighting"
  fi
}

setup_systemd_services() {
  log_header "Setting up System Services"
  
  # Enable useful system services
  local services=(
    "systemd-timesyncd"    # Time synchronization
    "fstrim.timer"         # SSD trim timer
  )
  
  for service in "${services[@]}"; do
    log_info "Enabling $service..."
    sudo systemctl enable --now "$service" 2>/dev/null || log_warn "Failed to enable $service"
  done
}

create_user_directories() {
  log_header "Creating User Directories"
  
  # Create common directories
  local directories=(
    "$HOME/workspace"
    "$HOME/Downloads"
    "$HOME/Documents"
    "$HOME/Pictures"
    "$HOME/Videos"
    "$HOME/.local/bin"
  )
  
  for dir in "${directories[@]}"; do
    ensure_dir "$dir"
  done
  
  # Add ~/.local/bin to PATH if not already there
  if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    log_info "Adding ~/.local/bin to PATH..."
    export PATH="$HOME/.local/bin:$PATH"
  fi
}

setup_arch_specific_config() {
  log_header "Setting up Arch-specific Configuration"
  
  # Enable parallel downloads for pacman
  log_info "Configuring pacman for parallel downloads..."
  sudo sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
  
  # Enable multilib repository for 32-bit packages
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    log_info "Enabling multilib repository..."
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy
  fi
}

main() {
  log_info "🐧 Starting Arch Linux specific setup..."
  
  # Core setup
  setup_yay
  setup_development_tools
  setup_arch_specific_config
  
  # System components
  setup_fonts
  setup_audio
  setup_display_server
  setup_networking
  setup_security
  
  # Development environment
  setup_shell_enhancements
  
  # System services
  setup_systemd_services
  
  # User environment
  create_user_directories
  
  log_success "✅ Arch Linux setup complete!"
  log_info "💡 You may want to install a desktop environment or window manager next"
  log_info "💡 Consider installing: plasma-meta, gnome, i3, sway, etc."
}

main "$@"
