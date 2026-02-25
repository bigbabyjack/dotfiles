# Neovim Web Dev Support Design

Date: 2026-02-24
Status: Approved

## Goal

Add TypeScript/JavaScript, React (JSX/TSX), HTML, and CSS support to the Neovim config. Includes LSP, formatting (Prettier), linting (ESLint), type checking (ts_ls), and per-filetype settings.

## Scope

- Plain TS/JS and React (JSX/TSX)
- HTML and CSS (+ Tailwind CSS ready)
- No framework-specific plugins (Vue, Svelte, etc.) at this stage

## Architecture

Follows the existing pattern: language-specific plugin config in `lua/custom/plugins/webdev.lua`, LSP server configs in `lua/custom/lsp-config.lua`.

## LSP Servers

All added to `lsp-config.lua` using the existing `vim.lsp.config` / `vim.lsp.enable` pattern.

| Server | Binary | Filetypes | Role |
|--------|--------|-----------|------|
| `ts_ls` | `typescript-language-server` | js, ts, jsx, tsx | Type checking, completions, inlay hints, go-to-def, rename |
| `eslint` | `vscode-eslint-language-server` | js, ts, jsx, tsx | Linting diagnostics + auto-fix on save |
| `html` | `vscode-html-language-server` | html | Completions, hover |
| `cssls` | `vscode-css-language-server` | css, scss, less | Completions, hover |
| `tailwindcss` | `tailwindcss-language-server` | html, css, js, ts, jsx, tsx | Class completions (activates only with tailwind.config.*) |

### Special ESLint handling in LspAttach

The `eslint` server should run `EslintFixAll` on `BufWritePre` (not LSP formatting). The existing generic format-on-save in `LspAttach` must skip `eslint` by client name.

### Skip LSP format-on-save for web filetypes

The existing `LspAttach` format-on-save uses `vim.lsp.buf.format`. For web filetypes, Prettier (via conform) handles formatting instead. Add a filetype guard to skip LSP formatting for: `javascript`, `typescript`, `javascriptreact`, `typescriptreact`, `html`, `css`, `scss`.

## Formatting

- Plugin: `conform.nvim` in `webdev.lua`
- Formatter: `prettier` for js, ts, jsx, tsx, html, css, scss
- Trigger: `BufWritePre` autocmd in `webdev.lua`
- Fallback: conform silently skips if prettier not found (no breakage in non-JS projects)
- Prettier must be installed per-project (`npm install --save-dev prettier`) or globally

## Per-filetype Settings

Autocmd in `webdev.lua` sets 2-space indentation for web filetypes:
- `tabstop = 2`, `shiftwidth = 2`, `softtabstop = 2`
- Filetypes: javascript, typescript, javascriptreact, typescriptreact, html, css, scss

## Extras

- `nvim-ts-autotag` — auto-close and auto-rename HTML/JSX tags via Treesitter

## Mason Auto-install

Modify `mason.lua` to add `mason-tool-installer.nvim` with `ensure_installed`:
- `typescript-language-server`
- `eslint-lsp`
- `vscode-langservers-extracted` (provides html + cssls)
- `tailwindcss-language-server`
- `prettier`

## Files Changed

| File | Change |
|------|--------|
| `lua/custom/plugins/webdev.lua` | **Create** — conform, autotag, indent autocmd |
| `lua/custom/lsp-config.lua` | **Modify** — add 5 servers, ESLint fix-on-save, skip web format |
| `lua/custom/plugins/mason.lua` | **Modify** — add mason-tool-installer with ensure_installed |
