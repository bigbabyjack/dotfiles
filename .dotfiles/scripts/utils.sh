#!/usr/bin/env bash

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1" >&2
}

log_header() {
  echo
  echo -e "${PURPLE}$1${NC}"
  echo -e "${PURPLE}$(printf '=%.0s' $(seq 1 ${#1}))${NC}"
}

# OS Detection
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export OS="macos"
  elif [[ -f /etc/arch-release ]]; then
    export OS="arch"
  elif [[ -f /etc/os-release ]]; then
    # Generic Linux detection - could be expanded
    . /etc/os-release
    if [[ "$ID" == "arch" ]] || [[ "$ID_LIKE" == *"arch"* ]]; then
      export OS="arch"
    else
      export OS="linux"
      log_warn "Detected Linux distribution '$ID' - using generic Linux setup"
    fi
  else
    log_error "Unsupported operating system: $OSTYPE"
    exit 1
  fi
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check if a package is installed (cross-platform)
package_installed() {
  local package="$1"
  
  case $OS in
    macos)
      brew list "$package" &>/dev/null
      ;;
    arch)
      pacman -Qi "$package" &>/dev/null
      ;;
    *)
      # Fallback to command check
      command_exists "$package"
      ;;
  esac
}

# Install a package (cross-platform)
install_package() {
  local package="$1"
  local description="${2:-$package}"
  
  if package_installed "$package"; then
    log_info "$description is already installed"
    return 0
  fi
  
  log_info "Installing $description..."
  
  case $OS in
    macos)
      brew install "$package"
      ;;
    arch)
      sudo pacman -S --noconfirm "$package"
      ;;
    *)
      log_error "Package installation not supported for OS: $OS"
      return 1
      ;;
  esac
}

# Install packages from AUR (Arch only)
install_aur_package() {
  local package="$1"
  local description="${2:-$package}"
  
  if [[ $OS != "arch" ]]; then
    log_warn "AUR packages only available on Arch Linux, skipping $description"
    return 0
  fi
  
  if package_installed "$package"; then
    log_info "$description is already installed"
    return 0
  fi
  
  # Check if yay is installed
  if ! command_exists yay; then
    log_info "Installing yay AUR helper..."
    install_yay
  fi
  
  log_info "Installing $description from AUR..."
  yay -S --noconfirm "$package"
}

# Install yay AUR helper
install_yay() {
  if command_exists yay; then
    return 0
  fi
  
  log_info "Installing yay AUR helper..."
  
  # Create temp directory
  local temp_dir=$(mktemp -d)
  cd "$temp_dir"
  
  # Clone and build yay
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  
  # Cleanup
  cd "$HOME"
  rm -rf "$temp_dir"
}

# Create a backup of a file if it exists
backup_file() {
  local file="$1"
  
  if [[ -f $file ]] || [[ -L $file ]]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "Backing up existing $file to $backup"
    mv "$file" "$backup"
  fi
}

# Create directory if it doesn't exist
ensure_dir() {
  local dir="$1"
  
  if [[ ! -d $dir ]]; then
    log_info "Creating directory: $dir"
    mkdir -p "$dir"
  fi
}

# Create a file from template if it doesn't exist
create_from_template() {
  local template_file="$1"
  local target_file="$2"
  local description="${3:-$(basename "$target_file")}"
  
  if [[ ! -f $target_file ]]; then
    if [[ -f $template_file ]]; then
      log_info "Creating $description from template..."
      cp "$template_file" "$target_file"
      log_warn "⚠️  $description was created from template, please review and customize"
    else
      log_warn "Template $template_file not found, cannot create $description"
    fi
  fi
}

# Prompt for user input with default value
prompt_with_default() {
  local prompt="$1"
  local default="$2"
  local result
  
  read -p "$prompt [$default]: " result
  echo "${result:-$default}"
}
