# Working Notes

## Where we are
Active dotfiles for Arch Linux + Hyprland. Stowed via GNU Stow from this repo. Currently on branch `arch`, ~15 commits ahead of `origin/arch` from the modernization sweep.

## Active task
Modernization sweep nearly done. Remaining items below.

## Recent decisions (and why)
- Removed all dead/disabled nvim plugin specs (copilot, avante, copilotchat, indent_line, floaterminal, lint).
- nvim-lint deleted: `linters_by_ft` was empty; LSPs (ruff, clippy, gopls, lua_ls, bashls) handle all linting today.
- Attempted to migrate nvim-treesitter to `branch = 'main'`; reverted (commit ea05a59) — the main-branch rewrite was too disruptive in this session. Stayed on archived master with the existing directive workarounds.
- Replaced telescope with fzf-lua (faster on large repos, fewer deps, integrates with system fzf). Lost live-preview-on-cursor in the colorscheme picker; selection applies on accept.
- Added conform.nvim and consolidated format-on-save through it (removed the LSP-side BufWritePre autocmd in lsp-config.lua to avoid double-formatting).
- Migrated `windowrulev2` → `windowrule` (Hyprland 0.45+ unified syntax).
- Standardized Hyprland script paths to `~/.config/scripts/`.
- `vim.loop` → `vim.uv`; lazy.nvim `as=` → `name=`.
- `$HOME` over hardcoded `/home/jack` in zshrc.
- Dropped Python venv aliases (`activate`, `mkvenv`) — uv now handles this.
- Bootstrapped lualine with active LSP-clients display and lazy/oil/quickfix extensions.

## Open threads
- **Treesitter main migration deferred.** nvim-treesitter master is archived; we're still on it. Future attempt should: (a) read the main-branch README carefully for the actual setup pattern, (b) test in a temporary nvim --clean session before committing, (c) be ready for textobjects-main rough edges.
- **Install missing formatters:** `paru -S shfmt prettier` to make conform's shell/json/yaml/markdown/js/ts formatters functional.
- **`.dotfiles/` parallel tree** — old macOS bootstrap/profile system still present unused. Decision pending.
- **tmux-resurrect** (`tmux/tmux.conf:138`) — hardcoded path; either adopt tpm or document the manual install.
- Pre-existing uncommitted change in `claude/.claude/settings.json` (yours, unrelated).

## Don't lose
- zsh-syntax-highlighting MUST be sourced last per upstream docs — keep the bottom block in `zsh/.zshrc`.
- Neovim LSP setup is native (vim.lsp.config / vim.lsp.enable) — do NOT reintroduce Mason or nvim-lspconfig.
- Rust uses `rustaceanvim`, not `lspconfig` — don't add a `rust_analyzer` entry to `lsp-config.lua`.
- Format-on-save is now owned by conform.nvim with `lsp_format = 'fallback'`. Don't re-add a BufWritePre autocmd to lsp-config.lua.
- ruff hover/definition is intentionally disabled in lsp-config.lua so `ty` owns Python hover.
