# Working Notes

## Where we are
Active dotfiles for Arch Linux + Hyprland. Stowed via GNU Stow from this repo. Currently on branch `arch`.

## Active task
Modernization sweep: removing dead code, fixing deprecated APIs (Neovim 0.11+ / Hyprland 0.45+), tightening hygiene.

## Recent decisions (and why)
- Removed all disabled/commented-out nvim plugin specs (copilot, avante, copilotchat, indent_line, floaterminal). Carrying dead code violates the "no half-finished implementations" rule and confuses future readers.
- Migrated `windowrulev2` → `windowrule` to match Hyprland 0.45+ unified syntax.
- Standardized script paths in hyprland.conf to use stowed `~/.config/scripts/` instead of mixing in `~/dotfiles/scripts/`.
- Dropped Python venv aliases (`activate`, `mkvenv`) in favor of `uv`.

## Open threads
- `.dotfiles/` parallel tree (old macOS bootstrap/profile system) still sits in the repo unused. Decision pending: archive to a branch or keep with a DEPRECATED marker.
- Several "consider" items from the audit not yet acted on: conform.nvim adoption, fzf-lua evaluation, treesitter master-archive workaround verification, DAP coverage beyond Go/Rust.
- Tmux-resurrect path is hardcoded in tmux.conf:138 — needs a tpm-based setup or a documented manual install path.

## Don't lose
- zsh-syntax-highlighting MUST be sourced last per upstream docs — keep the bottom block in `zsh/.zshrc`.
- Neovim LSP setup is native (vim.lsp.config / vim.lsp.enable) — do NOT reintroduce Mason.
- Rust uses `rustaceanvim`, not `lspconfig` — don't add a `rust_analyzer` entry to `lsp-config.lua`.
