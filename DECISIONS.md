# Decisions

Append-only ADR-lite log. Dated entries; never edit, never reorder.

---

## 2026-05-03 — Drop disabled and commented-out Neovim plugin specs

**Context:** `copilot.lua`, `avante.lua`, `copilotchat.lua`, `indent_line.lua`, and `floaterminal.lua` were either `enabled = false` or fully commented out. Carrying them violated the project's "no half-finished implementations" rule.

**Decision:** Delete all five files outright rather than gating them behind a feature flag.

**Rationale:** Git history preserves anything we want to revive. Live config files should reflect current intent.

**Consequences:** `<leader>tt` floating-terminal keybind no longer exists. `<leader>cpt` Copilot-toggle keybind no longer exists. Re-adding any of these requires a fresh, deliberate plugin spec.

---

## 2026-05-03 — Migrate windowrulev2 → windowrule (Hyprland 0.45+)

**Context:** Hyprland 0.45.0 (Oct 2024) unified `windowrulev2` into `windowrule`. The v2 form still parses but is deprecated. Running 0.54.3.

**Decision:** Replace all `windowrulev2` references in `hyprland.conf` and `CLAUDE.md` with `windowrule`.

**Rationale:** Stay on supported syntax; avoid surprise breakage on a future Hyprland update.

**Consequences:** None at runtime — the only `windowrulev2` reference was already commented out. Documentation is now accurate.

---

## 2026-05-03 — Standardize Hyprland script paths to `~/.config/scripts/`

**Context:** `hyprland.conf:300` (GRUB reboot bind) referenced `~/dotfiles/scripts/grub-reboot-menu.sh` while sibling binds at lines 222-223 used the stowed `~/.config/scripts/` path. Both work because of the stow symlink, but the inconsistency was confusing.

**Decision:** All script execs in Hyprland config use the stowed `~/.config/scripts/` path.

**Rationale:** Treat `~/.config/scripts/` (the symlink target) as the canonical runtime path. The repo location `~/dotfiles/scripts/` is an implementation detail of where files live before stowing.

**Consequences:** Config now portable to anyone who stows the repo, regardless of where they cloned it.

---

## 2026-05-03 — Drop Python venv aliases in favor of uv

**Context:** `.aliases.zsh` carried `alias activate='source env/bin/activate'` (twice) and `alias mkvenv='python -m venv env'`. Workflow has migrated to `uv`.

**Decision:** Remove both aliases. Keep `alias python='python3'`.

**Rationale:** `uv` provides `uv venv`, `uv run`, and project-aware execution. Manual venv activation is no longer the standard entry point.

**Consequences:** Any muscle-memory `activate` invocations will fail until retrained.

---

## 2026-05-03 — Delete nvim-lint plugin

**Context:** `lint.lua` had `linters_by_ft = {}` with the autocmd calling `try_lint()` on no configured linters. Effectively dead code.

**Decision:** Delete the plugin entirely.

**Rationale:** LSP servers (ruff, clippy via rustaceanvim, gopls, lua_ls, bashls) cover all currently-edited languages. nvim-lint adds a load-time cost for zero benefit.

**Consequences:** No non-LSP linters available. Re-add deliberately if shellcheck, markdownlint, vale, etc. become wanted.

---

## 2026-05-03 — Migrate nvim-treesitter and textobjects to main branch

**Context:** nvim-treesitter master is archived. The previous config carried a custom set-lang-from-info-string!/set-lang-from-mimetype!/downcase!/kind-eq? workaround because master's queries broke on Neovim 0.12.

**Decision:** Switch both nvim-treesitter and nvim-treesitter-textobjects to `branch = 'main'`. Use the new install/start API. Drop the directive workaround.

**Rationale:** main is the active rewrite. The workaround was a stopgap that we don't need on a maintained branch.

**Consequences:** Textobjects API is different (`require('nvim-treesitter-textobjects.select').select_textobject`). All af/if/ac/ic/al/il/ab/ib/aa/ia and ]m/[m/]]/[[ binds rewritten and preserved. The main-branch textobjects plugin is still stabilizing — verify in nvim and revert to master pin if broken.

---

## 2026-05-03 — Replace telescope with fzf-lua

**Context:** Telescope was the search/picker plugin and underpinned the custom colorscheme picker, the LSP navigation keybinds, and `vim.ui.select`.

**Decision:** Switch to fzf-lua. Migrate all keybinds. Rewrite the colorscheme picker.

**Rationale:** fzf-lua is faster on large repos, has fewer Lua dependencies, and integrates with the system `fzf` binary already installed via pacman.

**Consequences:** The colorscheme picker no longer live-previews on cursor move — selection applies on accept and Esc restores the original. ui.select is now backed by `fzf.register_ui_select()`. Removed the `telescope` integration flag from catppuccin and dropped the telescope dep from `go.nvim`.

---

## 2026-05-03 — Add conform.nvim and consolidate format-on-save

**Context:** Format-on-save was wired into `lsp-config.lua` via a BufWritePre autocmd that ran `vim.lsp.buf.format` on every buffer with a formatting-capable LSP. No support for non-LSP formatters (e.g., prettier on markdown).

**Decision:** Add conform.nvim. Configure stylua/shfmt/prettier per filetype. Remove the LSP BufWritePre autocmd. Use `lsp_format = 'fallback'` so Python/Rust/Go (no conform formatter configured) fall back to their LSPs.

**Rationale:** Single source of truth for formatting. Avoids double-formatting (LSP + tool) on filetypes where both could apply.

**Consequences:** `shfmt` and `prettier` are not yet installed system-wide; conform will warn and skip until `paru -S shfmt prettier` is run. Format-on-save behavior for Python/Rust/Go is unchanged because conform falls back to their LSPs.

---

## 2026-05-03 — Revert treesitter main-branch migration

**Context:** The main-branch migration committed earlier today (f869473) didn't work cleanly in practice. The exact failure wasn't fully diagnosed before reverting.

**Decision:** Revert via git revert (commit ea05a59). Restore lazy-lock.json and the on-disk checkout to master @ 42fc28ba. Keep using the existing directive workarounds for master's broken queries on Neovim 0.12.

**Rationale:** Master is archived but functional. The user's textobjects + highlighting workflow matters more than being on the maintained branch right now. A future attempt should test against `nvim --clean` first.

**Consequences:** We're on an archived plugin branch and carrying the set-lang-from-info-string!/set-lang-from-mimetype!/downcase!/kind-eq? workarounds indefinitely. Net config is unchanged from before today's sweep.
