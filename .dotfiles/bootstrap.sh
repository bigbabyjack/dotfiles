#!/usr/bin/env bash

set -e

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# Source utility functions
source "$DOTFILES_DIR/scripts/utils.sh"

main() {
  log_info "🚀 Starting dotfiles setup..."
  log_info "Dotfiles directory: $DOTFILES_DIR"
  
  # Check if required tools are available
  check_requirements
  
  # Detect OS
  detect_os
  log_info "Detected OS: $OS"
  
  # Setup environment file
  setup_environment
  
  # Install packages
  log_info "📦 Installing packages..."
  "$DOTFILES_DIR/scripts/install-packages.sh"
  
  # OS-specific setup
  case $OS in
    macos)
      log_info "🍎 Running macOS specific setup..."
      "$DOTFILES_DIR/scripts/setup-macos.sh"
      ;;
    arch)
      log_info "🐧 Running Arch Linux specific setup..."
      "$DOTFILES_DIR/scripts/setup-arch.sh"
      ;;
  esac
  
  # Setup profiles (macOS only for now)
  if [[ $OS == "macos" ]]; then
    log_info "👤 Setting up profiles..."
    "$DOTFILES_DIR/scripts/setup-profiles.sh"
  fi
  
  # Stow dotfiles
  log_info "🔗 Setting up symlinks with stow..."
  setup_stow_packages
  
  # Setup shell
  setup_shell
  
  log_success "✅ Dotfiles setup complete!"
  log_info "Please restart your shell or run: source ~/.zshrc"
}

check_requirements() {
  local required_tools=("git" "stow")
  
  for tool in "${required_tools[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
      log_error "❌ Required tool '$tool' is not installed"
      log_info "Please install $tool and run this script again"
      exit 1
    fi
  done
}

setup_environment() {
  local env_file="$DOTFILES_DIR/.env"
  local env_example="$DOTFILES_DIR/.env.example"
  
  if [[ ! -f $env_file ]]; then
    if [[ -f $env_example ]]; then
      log_info "📝 Creating .env file from template..."
      cp "$env_example" "$env_file"
      log_warn "⚠️  Please edit $env_file to set your preferences"
    else
      log_info "📝 Creating default .env file..."
      cat > "$env_file" << EOF
# Environment configuration
# Set to 'work' or 'personal' (macOS only)
DEV_ENV=personal
EOF
    fi
  fi
  
  # Source the environment file
  source "$env_file"
  export DEV_ENV
  log_info "Environment: DEV_ENV=$DEV_ENV"
}

setup_stow_packages() {
  cd "$DOTFILES_DIR"
  
  # Define stow packages - these correspond to directories in the dotfiles repo
  local shared_packages=("git" "nvim" "zsh" "wezterm")
  local macos_packages=("aerospace" "borders")
  
  # Stow shared packages
  for package in "${shared_packages[@]}"; do
    if [[ -d $package ]]; then
      log_info "Stowing $package..."
      stow -R "$package"
    else
      log_warn "Package directory '$package' not found, skipping..."
    fi
  done
  
  # Stow OS-specific packages
  if [[ $OS == "macos" ]]; then
    for package in "${macos_packages[@]}"; do
      if [[ -d $package ]]; then
        log_info "Stowing $package..."
        stow -R "$package"
      else
        log_warn "Package directory '$package' not found, skipping..."
      fi
    done
  fi
  
  # Stow editorconfig at root level
  if [[ -f .editorconfig ]]; then
    log_info "Linking .editorconfig..."
    ln -sf "$DOTFILES_DIR/.editorconfig" "$HOME/.editorconfig"
  fi
}

setup_shell() {
  log_info "🐚 Setting up shell configuration..."
  
  # Make zsh the default shell if it isn't already
  if [[ $SHELL != *"zsh"* ]]; then
    log_info "Setting zsh as default shell..."
    if command -v zsh &> /dev/null; then
      chsh -s "$(which zsh)"
    else
      log_warn "zsh not found in PATH, please set it manually"
    fi
  fi
  
  # Install starship prompt if not already installed
  if ! command -v starship &> /dev/null; then
    log_info "Installing starship prompt..."
    if [[ $OS == "macos" ]]; then
      brew install starship
    elif [[ $OS == "arch" ]]; then
      sudo pacman -S --noconfirm starship
    fi
  fi
}

# Run main function
main "$@"
