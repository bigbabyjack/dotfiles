#!/usr/bin/env bash

set -e

# Source utility functions
source "$(dirname "$0")/utils.sh"

setup_aerospace() {
  log_header "Setting up AeroSpace Window Manager"
  
  # Check if AeroSpace is installed
  if ! command_exists aerospace; then
    log_warn "AeroSpace not found, please install it first"
    return 1
  fi
  
  log_info "AeroSpace is installed"
  
  # The .aerospace.toml file will be symlinked by stow
  # We just need to make sure AeroSpace can start
  
  log_info "Testing AeroSpace configuration..."
  if aerospace validate-config; then
    log_success "AeroSpace configuration is valid"
  else
    log_warn "AeroSpace configuration validation failed"
  fi
  
  # Start AeroSpace if not running
  if ! pgrep -f "AeroSpace" > /dev/null; then
    log_info "Starting AeroSpace..."
    open -a AeroSpace
  else
    log_info "AeroSpace is already running"
  fi
}

setup_borders() {
  log_header "Setting up Borders"
  
  # Check if borders is installed
  if ! command_exists borders; then
    log_warn "borders not found, please install it first"
    return 1
  fi
  
  log_info "borders is installed"
  
  # The bordersrc file will be symlinked by stow
  # We can set up borders to start with AeroSpace or at login
  
  # Create a simple launch agent for borders if desired
  local launch_agents_dir="$HOME/Library/LaunchAgents"
  local borders_plist="$launch_agents_dir/com.user.borders.plist"
  
  ensure_dir "$launch_agents_dir"
  
  if [[ ! -f $borders_plist ]]; then
    log_info "Creating launch agent for borders..."
    cat > "$borders_plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.borders</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HOME/.bordersrc</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardErrorPath</key>
    <string>/tmp/borders.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/borders.out</string>
</dict>
</plist>
EOF
    
    log_info "Loading borders launch agent..."
    launchctl load "$borders_plist"
  else
    log_info "borders launch agent already exists"
  fi
}

setup_macos_defaults() {
  log_header "Setting up macOS Preferences"
  
  # Key repeat settings for better development experience
  log_info "Setting up key repeat preferences..."
  defaults write -g ApplePressAndHoldEnabled -bool false
  defaults write -g InitialKeyRepeat -int 15
  defaults write -g KeyRepeat -int 2
  
  # Dock preferences
  log_info "Setting up Dock preferences..."
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock autohide-delay -float 0
  defaults write com.apple.dock autohide-time-modifier -float 0.3
  
  # Finder preferences
  log_info "Setting up Finder preferences..."
  defaults write com.apple.finder ShowHiddenFiles -bool true
  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  
  # Screenshots
  log_info "Setting up screenshot preferences..."
  defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
  defaults write com.apple.screencapture type -string "png"
  defaults write com.apple.screencapture disable-shadow -bool true
  
  # Create Screenshots directory
  ensure_dir "$HOME/Desktop/Screenshots"
  
  log_info "Restarting affected applications..."
  killall Dock 2>/dev/null || true
  killall Finder 2>/dev/null || true
}

setup_homebrew_services() {
  log_header "Setting up Homebrew Services"
  
  # Start and enable useful services
  local services=()
  
  # Check which services are available and add them to the list
  if brew list postgresql@14 &>/dev/null; then
    services+=("postgresql@14")
  fi
  
  if brew list redis &>/dev/null; then
    services+=("redis")
  fi
  
  for service in "${services[@]}"; do
    log_info "Starting $service service..."
    brew services start "$service" 2>/dev/null || true
  done
}

setup_xcode_tools() {
  log_header "Setting up Xcode Command Line Tools"
  
  # Check if Xcode command line tools are installed
  if ! xcode-select -p &>/dev/null; then
    log_info "Installing Xcode command line tools..."
    xcode-select --install
    
    # Wait for installation to complete
    log_info "Please complete the Xcode command line tools installation and press Enter to continue..."
    read -r
  else
    log_success "Xcode command line tools are already installed"
  fi
}

setup_git_credential_manager() {
  log_header "Setting up Git Credential Manager"
  
  # Install Git Credential Manager if not present
  if ! command_exists git-credential-manager; then
    log_info "Installing Git Credential Manager..."
    brew install --cask git-credential-manager
  else
    log_info "Git Credential Manager is already installed"
  fi
  
  # Configure Git to use the credential manager
  git config --global credential.helper manager
}

main() {
  log_info "🍎 Starting macOS specific setup..."
  
  # Setup Xcode tools first (required for many other tools)
  setup_xcode_tools
  
  # Setup Git credential manager
  setup_git_credential_manager
  
  # Setup window management
  setup_aerospace
  setup_borders
  
  # Setup macOS preferences
  setup_macos_defaults
  
  # Setup Homebrew services
  setup_homebrew_services
  
  log_success "✅ macOS setup complete!"
  log_info "💡 You may need to restart your computer for all changes to take effect"
}

main "$@"
