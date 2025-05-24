#!/usr/bin/env bash

set -e

# Source utility functions
source "$(dirname "$0")/utils.sh"

setup_git_profiles() {
  log_header "Setting up Git Profiles"
  
  local git_dir="$DOTFILES_DIR/git"
  local work_config="$git_dir/.gitconfig-work"
  local personal_config="$git_dir/.gitconfig-personal"
  local env_config="$git_dir/.gitconfig-env"
  
  # Create work git config if it doesn't exist
  if [[ ! -f $work_config ]]; then
    log_warn "Work git config not found, creating template..."
    cat > "$work_config" << 'EOF'
[user]
    name = Your Work Name
    email = your.work.email@company.com
[core]
    sshCommand = ssh -i ~/.ssh/id_rsa_work
[credential]
    helper = manager
[url "git@github.com-work:"]
    insteadOf = git@github.com:your-work-org/
EOF
    log_warn "⚠️  Please edit $work_config with your work details"
  fi
  
  # Create personal git config if it doesn't exist
  if [[ ! -f $personal_config ]]; then
    log_warn "Personal git config not found, creating template..."
    cat > "$personal_config" << 'EOF'
[user]
    name = Your Personal Name
    email = your.personal.email@gmail.com
[core]
    sshCommand = ssh -i ~/.ssh/id_rsa_personal
[credential]
    helper = manager
[github]
    user = your-github-username
EOF
    log_warn "⚠️  Please edit $personal_config with your personal details"
  fi
  
  # Link the appropriate config based on DEV_ENV
  case ${DEV_ENV:-personal} in
    work)
      log_info "Linking work git configuration..."
      ln -sf "$work_config" "$env_config"
      ;;
    personal)
      log_info "Linking personal git configuration..."
      ln -sf "$personal_config" "$env_config"
      ;;
    *)
      log_warn "Unknown DEV_ENV value: $DEV_ENV, defaulting to personal"
      ln -sf "$personal_config" "$env_config"
      ;;
  esac
  
  log_success "Git profile configured for: ${DEV_ENV:-personal}"
}

setup_ssh_profiles() {
  log_header "Setting up SSH Profiles"
  
  local ssh_dir="$HOME/.ssh"
  local ssh_config="$ssh_dir/config"
  
  ensure_dir "$ssh_dir"
  chmod 700 "$ssh_dir"
  
  # Create SSH config if it doesn't exist
  if [[ ! -f $ssh_config ]]; then
    log_info "Creating SSH config template..."
    cat > "$ssh_config" << 'EOF'
# Default settings
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/id_rsa

# Work GitHub (if using separate work account)
Host github.com-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_work
    IdentitiesOnly yes

# Personal GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_personal
    IdentitiesOnly yes
EOF
    chmod 600 "$ssh_config"
    log_warn "⚠️  SSH config created. Please generate SSH keys and update the config as needed"
  else
    log_info "SSH config already exists"
  fi
  
  # Create SSH key generation instructions
  local ssh_instructions="$ssh_dir/KEY_GENERATION_INSTRUCTIONS.md"
  if [[ ! -f $ssh_instructions ]]; then
    cat > "$ssh_instructions" << 'EOF'
# SSH Key Generation Instructions

## Generate Personal SSH Key
```bash
ssh-keygen -t ed25519 -C "your.personal.email@gmail.com" -f ~/.ssh/id_rsa_personal
```

## Generate Work SSH Key (if needed)
```bash
ssh-keygen -t ed25519 -C "your.work.email@company.com" -f ~/.ssh/id_rsa_work
```

## Add Keys to SSH Agent
```bash
ssh-add ~/.ssh/id_rsa_personal
ssh-add ~/.ssh/id_rsa_work  # if you have a work key
```

## Add Public Keys to GitHub
1. Copy the public key: `pbcopy < ~/.ssh/id_rsa_personal.pub`
2. Go to GitHub Settings > SSH and GPG keys
3. Add the key

Remember to do the same for your work GitHub account if you have separate work and personal accounts.
EOF
    log_info "Created SSH key generation instructions at $ssh_instructions"
  fi
}

setup_zsh_profiles() {
  log_header "Setting up Zsh Profiles"
  
  local zsh_dir="$DOTFILES_DIR/zsh"
  local work_aliases="$zsh_dir/.aliases.work.zsh"
  local personal_aliases="$zsh_dir/.aliases.personal.zsh"
  
  # Create work-specific aliases if they don't exist
  if [[ ! -f $work_aliases ]]; then
    log_warn "Work aliases not found, creating template..."
    cat > "$work_aliases" << 'EOF'
# Work-specific aliases and configurations

# Work-specific navigation
alias workspace='cd ~/workspace'
alias workprojec='cd ~/workspace/main-project'

# Work-specific tools
# alias vpn='sudo openconnect your-work-vpn.com'
# alias work-docker='docker context use work'

# Work environment variables
# export WORK_API_URL="https://api.work.com"
# export WORK_ENV="development"

# Add work-specific PATH additions here
# export PATH="/usr/local/work-tools/bin:$PATH"
EOF
    log_warn "⚠️  Please edit $work_aliases with your work-specific configurations"
  fi
  
  # Create personal-specific aliases if they don't exist  
  if [[ ! -f $personal_aliases ]]; then
    log_warn "Personal aliases not found, creating template..."
    cat > "$personal_aliases" << 'EOF'
# Personal-specific aliases and configurations

# Personal navigation
alias workspace='cd ~/workspace'
alias projects='cd ~/workspace/personal'
alias blog='cd ~/workspace/blog'

# Personal tools
# alias homelab='ssh user@homelab.local'
# alias backup='rsync -av ~/Documents/ /backup/location/'

# Personal environment variables
# export PERSONAL_API_KEY="your-api-key"

# Add personal-specific PATH additions here
# export PATH="$HOME/personal-tools/bin:$PATH"
EOF
    log_warn "⚠️  Please edit $personal_aliases with your personal configurations"
  fi
  
  log_success "Zsh profile templates created"
}

setup_environment_indicator() {
  log_header "Setting up Environment Indicator"
  
  # The environment indicator is handled in the zsh config and starship prompt
  # We just need to make sure the DEV_ENV variable is properly set
  
  case ${DEV_ENV:-personal} in
    work)
      log_info "Environment set to: 🏢 Work"
      ;;
    personal)
      log_info "Environment set to: 🏠 Personal"
      ;;
    *)
      log_warn "Unknown environment: $DEV_ENV"
      ;;
  esac
}

setup_application_profiles() {
  log_header "Setting up Application Profiles"
  
  # This function can be extended to handle other application-specific profiles
  # For now, we'll just create placeholder directories
  
  local config_dir="$HOME/.config"
  ensure_dir "$config_dir"
  
  # Create profile-specific config directories if needed
  case ${DEV_ENV:-personal} in
    work)
      # Work-specific application configs could go here
      log_info "Work profile application setup..."
      ;;
    personal)
      # Personal-specific application configs could go here
      log_info "Personal profile application setup..."
      ;;
  esac
}

validate_profile_setup() {
  log_header "Validating Profile Setup"
  
  local issues=0
  
  # Check if git config is properly linked
  if [[ -L "$DOTFILES_DIR/git/.gitconfig-env" ]]; then
    local target=$(readlink "$DOTFILES_DIR/git/.gitconfig-env")
    log_success "Git config linked to: $(basename "$target")"
  else
    log_error "Git config environment file not properly linked"
    ((issues++))
  fi
  
  # Check if profile-specific aliases exist
  local aliases_file="$DOTFILES_DIR/zsh/.aliases.${DEV_ENV:-personal}.zsh"
  if [[ -f $aliases_file ]]; then
    log_success "Profile aliases found: $(basename "$aliases_file")"
  else
    log_error "Profile aliases not found: $aliases_file"
    ((issues++))
  fi
  
  if [[ $issues -eq 0 ]]; then
    log_success "All profile validations passed"
  else
    log_warn "$issues validation issues found"
  fi
}

main() {
  log_info "👤 Setting up profiles for: ${DEV_ENV:-personal}"
  
  # Setup different profile components
  setup_git_profiles
  setup_ssh_profiles
  setup_zsh_profiles
  setup_environment_indicator
  setup_application_profiles
  
  # Validate the setup
  validate_profile_setup
  
  log_success "✅ Profile setup complete!"
  log_info "💡 Active profile: ${DEV_ENV:-personal}"
  log_info "💡 To switch profiles, edit the DEV_ENV variable in .env and re-run the setup"
}

main "$@"
