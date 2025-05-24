# Dotfiles Makefile
# Provides convenient shortcuts for common tasks

.PHONY: help install stow unstow update clean backup switch-work switch-personal

# Default target
help:
	@echo "Dotfiles Management Commands:"
	@echo ""
	@echo "  install          - Run full bootstrap setup"
	@echo "  stow            - Apply symlinks using stow"
	@echo "  unstow          - Remove symlinks"
	@echo "  update          - Update packages and configurations"
	@echo "  clean           - Clean up temporary files"
	@echo "  backup          - Backup existing configurations"
	@echo "  switch-work     - Switch to work profile (macOS)"
	@echo "  switch-personal - Switch to personal profile (macOS)"
	@echo ""
	@echo "Environment:"
	@echo "  Current OS: $$(uname -s)"
	@if [ -f .env ]; then \
		echo "  Profile: $$(grep DEV_ENV .env | cut -d'=' -f2)"; \
	else \
		echo "  Profile: Not configured (.env missing)"; \
	fi

# Install everything
install:
	@echo "🚀 Starting full dotfiles installation..."
	./bootstrap.sh

# Apply stow packages
stow:
	@echo "🔗 Applying symlinks..."
	@for dir in git nvim zsh wezterm; do \
		if [ -d "$$dir" ]; then \
			echo "Stowing $$dir..."; \
			stow -R "$$dir"; \
		fi; \
	done
	@if [ "$$(uname -s)" = "Darwin" ]; then \
		for dir in aerospace borders; do \
			if [ -d "$$dir" ]; then \
				echo "Stowing $$dir..."; \
				stow -R "$$dir"; \
			fi; \
		done; \
	fi
	@if [ -f .editorconfig ]; then \
		ln -sf "$$(pwd)/.editorconfig" "$$HOME/.editorconfig"; \
	fi

# Remove stow packages
unstow:
	@echo "🔗 Removing symlinks..."
	@for dir in git nvim zsh wezterm aerospace borders; do \
		if [ -d "$$dir" ]; then \
			echo "Unstowing $$dir..."; \
			stow -D "$$dir" 2>/dev/null || true; \
		fi; \
	done
	@rm -f "$$HOME/.editorconfig"

# Update packages
update:
	@echo "📦 Updating packages..."
	@if command -v brew >/dev/null 2>&1; then \
		echo "Updating Homebrew packages..."; \
		brew update && brew upgrade; \
	elif command -v pacman >/dev/null 2>&1; then \
		echo "Updating Arch packages..."; \
		sudo pacman -Syu; \
		if command -v yay >/dev/null 2>&1; then \
			yay -Syu; \
		fi; \
	fi
	@if command -v rustup >/dev/null 2>&1; then \
		echo "Updating Rust toolchain..."; \
		rustup update; \
	fi
	@if command -v npm >/dev/null 2>&1; then \
		echo "Updating npm..."; \
		npm update -g; \
	fi

# Clean temporary files
clean:
	@echo "🧹 Cleaning temporary files..."
	@find . -name "*.tmp" -delete
	@find . -name "*.backup.*" -delete
	@find . -name ".DS_Store" -delete
	@rm -rf .tmp/

# Backup existing configurations
backup:
	@echo "💾 Backing up existing configurations..."
	@timestamp=$$(date +%Y%m%d_%H%M%S); \
	mkdir -p "$$HOME/.config-backup-$$timestamp"; \
	for file in .zshrc .gitconfig .editorconfig; do \
		if [ -f "$$HOME/$$file" ] || [ -L "$$HOME/$$file" ]; then \
			cp -L "$$HOME/$$file" "$$HOME/.config-backup-$$timestamp/" 2>/dev/null || true; \
		fi; \
	done; \
	if [ -d "$$HOME/.config/nvim" ]; then \
		cp -r "$$HOME/.config/nvim" "$$HOME/.config-backup-$$timestamp/" 2>/dev/null || true; \
	fi; \
	echo "Backup created at: $$HOME/.config-backup-$$timestamp"

# Switch to work profile (macOS only)
switch-work:
	@if [ "$$(uname -s)" != "Darwin" ]; then \
		echo "❌ Profiles are only supported on macOS"; \
		exit 1; \
	fi
	@echo "🏢 Switching to work profile..."
	@if [ ! -f .env ]; then cp .env.example .env; fi
	@sed -i '' 's/DEV_ENV=.*/DEV_ENV=work/' .env
	@echo "Profile switched to work. Restart your shell to apply changes."

# Switch to personal profile (macOS only)
switch-personal:
	@if [ "$$(uname -s)" != "Darwin" ]; then \
		echo "❌ Profiles are only supported on macOS"; \
		exit 1; \
	fi
	@echo "🏠 Switching to personal profile..."
	@if [ ! -f .env ]; then cp .env.example .env; fi
	@sed -i '' 's/DEV_ENV=.*/DEV_ENV=personal/' .env
	@echo "Profile switched to personal. Restart your shell to apply changes."

# Test the configuration
test:
	@echo "🧪 Testing configuration..."
	@echo "Checking required tools..."
	@command -v git >/dev/null 2>&1 || (echo "❌ git not found" && exit 1)
	@command -v stow >/dev/null 2>&1 || (echo "❌ stow not found" && exit 1)
	@command -v zsh >/dev/null 2>&1 || (echo "❌ zsh not found" && exit 1)
	@echo "✅ All required tools found"
	@echo "Checking file structure..."
	@for dir in git nvim zsh scripts; do \
		if [ ! -d "$$dir" ]; then \
			echo "❌ Missing directory: $$dir"; \
			exit 1; \
		fi; \
	done
	@echo "✅ File structure looks good"

# Show current status
status:
	@echo "📊 Dotfiles Status:"
	@echo ""
	@echo "Environment:"
	@echo "  OS: $$(uname -s)"
	@if [ -f .env ]; then \
		echo "  Profile: $$(grep DEV_ENV .env | cut -d'=' -f2)"; \
	else \
		echo "  Profile: Not configured"; \
	fi
	@echo ""
	@echo "Installed Tools:"
	@for tool in git stow zsh nvim starship; do \
		if command -v "$$tool" >/dev/null 2>&1; then \
			echo "  ✅ $$tool"; \
		else \
			echo "  ❌ $$tool"; \
		fi; \
	done
	@echo ""
	@echo "Symlinks:"
	@for file in .zshrc .gitconfig; do \
		if [ -L "$$HOME/$$file" ]; then \
			echo "  ✅ $$file -> $$(readlink "$$HOME/$$file")"; \
		elif [ -f "$$HOME/$$file" ]; then \
			echo "  ⚠️  $$file (not a symlink)"; \
		else \
			echo "  ❌ $$file (missing)"; \
		fi; \
	done
