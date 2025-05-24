#!/usr/bin/env bash
#
# install/arch.sh — bootstrap a fresh Arch Linux machine with dotfiles and core tools
#
set -euo pipefail

# 1. Ensure we have sudo privileges
if ! sudo -n true 2>/dev/null; then
  echo "ERROR: This script requires sudo privileges. Please run as a user in the wheel group." >&2
  exit 1
fi

# 2. Bootstrap yay (AUR helper) if missing
if ! command -v yay &>/dev/null; then
  echo "➜ Installing base-devel & git via pacman..."
  sudo pacman -Sy --noconfirm --needed base-devel git

  echo "➜ Cloning yay..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay

  echo "➜ Building & installing yay..."
  (cd /tmp/yay && makepkg -si --noconfirm)

  rm -rf /tmp/yay
  echo "✔ yay installed"
fi

# 3. Define package lists
PACMAN_PKGS=(
  git
  zsh
  stow
  curl
  wget
  fzf
  ripgrep
  fd
  bat
  btop
  neovim
  wezterm
  zsh-autosuggestions
  zsh-syntax-highlighting
)
AUR_PKGS=(
  starship
)

# 4. System update & install pacman packages
echo "➜ Updating system & installing pacman packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
echo "✔ pacman packages installed"

# 5. Install AUR packages via yay
echo "➜ Installing AUR packages..."
yay -S --noconfirm --needed "${AUR_PKGS[@]}"
echo "✔ AUR packages installed"

# 6. Set zsh as default shell (optional)
if [[ "$SHELL" != "$(which zsh)" ]]; then
  echo "➜ Changing default shell to zsh..."
  chsh -s "$(which zsh)"
  echo "✔ Default shell set to zsh"
fi

# 7. Stow your dotfiles modules
#    Assumes this script lives in ~/dotfiles/install/arch.sh
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
echo "➜ Stowing modules from $DOTFILES_ROOT/modules..."
cd "$DOTFILES_ROOT/modules"
for module in *; do
  # skip any macOS-only dirs
  [[ -d $module ]] || continue
  stow --restow --verbose "$module"
done
echo "✔ Dotfiles modules stowed"

# 8. Final message
echo
echo "🎉 Your Arch setup is complete! Open a new terminal to start using your dotfiles."
