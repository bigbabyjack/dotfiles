#!/usr/bin/env bash

set -e

# Source utility functions
source "$(dirname "$0")/utils.sh"

# Package definitions
declare -A SHARED_PACKAGES=(
  ["git"]="Git version control"
  ["neovim"]="Neovim text editor"
  ["zsh"]="Z shell"
  ["eza"]="Modern ls replacement"
  ["fd"]="Modern find replacement"
  ["ripgrep"]="Modern grep replacement"
  ["btop"]="Modern top replacement"
  ["make"]="Build tool"
  ["unzip"]="Archive extraction"
  ["go"]="Go programming language"
  ["python3"]="Python 3"
  ["nodejs"]="Node.js runtime"
  ["npm"]="Node package manager"
  ["starship"]="Cross-shell prompt"
)

declare -A MACOS_PACKAGES=(
  ["lazygit"]="Git TUI"
  ["rustup"]="Rust toolchain installer"
)

declare -A ARCH_PACKAGES=(
  ["lazygit"]="Git TUI"
  ["rustup"]="Rust toolchain installer"
  ["base-devel"]="Development tools"
  ["git"]="Git version control"
)

declare -A MACOS_CASK_PACKAGES=(
  ["wezterm"]="Terminal emulator"
)

declare -A AUR_PACKAGES=(
  ["wezterm"]="Terminal emulator"
)

install_shared_packages() {
  log_header "Installing Shared Packages"
  
  for package in "${!SHARED_PACKAGES[@]}"; do
    # Map package names for different systems
    local actual_package="$package"
    
    case $OS in
      arch)
        case $package in
          "neovim") actual_package="neovim" ;;
          "python3") actual_package="python" ;;
          "nodejs") actual_package="nodejs" ;;
          "npm") actual_package="npm" ;;
          "ripgrep") actual_package="ripgrep" ;;
        esac
        ;;
      macos)
        case $package in
          "neovim") actual_package="neovim" ;;
          "ripgrep") actual_package="ripgrep" ;;
        esac
        ;;
    esac
    
    install_package "$actual_package" "${SHARED_PACKAGES[$package]}"
  done
}

install_os_specific_packages() {
  case $OS in
    macos)
      install_macos_packages
      ;;
    arch)
      install_arch_packages
      ;;
  esac
}

install_macos_packages() {
  log_header "Installing macOS Specific Packages"
  
  # Check if Homebrew is installed
  if ! command_exists brew; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for current session
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  
  # Install regular packages
  for package in "${!MACOS_PACKAGES[@]}"; do
    install_package "$package" "${MACOS_PACKAGES[$package]}"
  done
  
  # Install cask packages
  for package in "${!MACOS_CASK_PACKAGES[@]}"; do
    if brew list --cask "$package" &>/dev/null; then
      log_info "${MACOS_CASK_PACKAGES[$package]} is already installed"
    else
      log_info "Installing ${MACOS_CASK_PACKAGES[$package]}..."
      brew install --cask "$package"
    fi
  done
  
  # Install AeroSpace window manager
  if ! brew list --cask aerospace &>/dev/null; then
    log_info "Installing AeroSpace window manager..."
    brew install --cask nikitabobko/tap/aerospace
  fi
  
  # Install borders
  if ! command_exists borders; then
    log_info "Installing borders..."
    brew tap FelixKratz/formulae
    brew install borders
  fi
}

install_arch_packages() {
  log_header "Installing Arch Linux Specific Packages"
  
  # Update package database
  log_info "Updating package database..."
  sudo pacman -Sy
  
  # Install regular packages
  for package in "${!ARCH_PACKAGES[@]}"; do
    install_package "$package" "${ARCH_PACKAGES[$package]}"
  done
  
  # Install AUR packages
  for package in "${!AUR_PACKAGES[@]}"; do
    install_aur_package "$package" "${AUR_PACKAGES[$package]}"
  done
}

setup_rust() {
  log_header "Setting up Rust Toolchain"
  
  if command_exists rustup; then
    log_info "Rust toolchain is already installed"
    # Update to latest stable
    rustup update stable
  else
    log_info "Installing Rust toolchain..."
    if [[ $OS == "macos" ]]; then
      # rustup should be installed via homebrew
      if ! command_exists rustup; then
        log_error "rustup not found, please check Homebrew installation"
        return 1
      fi
    elif [[ $OS == "arch" ]]; then
      # Initialize rustup on Arch
      rustup default stable
    fi
  fi
  
  # Install common components
  log_info "Installing Rust components..."
  rustup component add clippy rustfmt rust-analyzer
  
  # Add cargo bin to PATH for current session
  if [[ -d "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
  fi
}

setup_node() {
  log_header "Setting up Node.js"
  
  if command_exists npm; then
    log_info "Updating npm to latest version..."
    npm install -g npm@latest
  fi
}

setup_python() {
  log_header "Setting up Python"
  
  # Install uv if not already installed
  if ! command_exists uv; then
    log_info "Installing uv Python package manager..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
  else
    log_info "uv is already installed"
  fi
}

setup_go() {
  log_header "Setting up Go"
  
  if command_exists go; then
    log_info "Go is installed: $(go version)"
    
    # Create Go workspace directory
    local go_path="${GOPATH:-$HOME/go}"
    ensure_dir "$go_path/bin"
    ensure_dir "$go_path/src"
    ensure_dir "$go_path/pkg"
    
    log_info "Go workspace created at $go_path"
  fi
}

main() {
  log_info "🚀 Starting package installation for $OS..."
  
  # Install shared packages
  install_shared_packages
  
  # Install OS-specific packages
  install_os_specific_packages
  
  # Setup language toolchains
  setup_rust
  setup_node
  setup_python
  setup_go
  
  log_success "✅ Package installation complete!"
}

main "$@"
