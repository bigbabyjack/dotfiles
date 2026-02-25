# Web Dev Neovim Support Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add TypeScript/JavaScript (+ React JSX/TSX), HTML, and CSS support to Neovim with LSP, Prettier formatting, ESLint linting, type checking, and auto-tag.

**Architecture:** Four changes across existing files plus one new file. LSP servers registered in `lsp-config.lua` using the existing `vim.lsp.config` / `vim.lsp.enable` pattern. Prettier runs via `conform.nvim` (a new plugin) on BufWritePre for web filetypes. The existing generic LSP format-on-save in `lsp-config.lua` is guarded to skip web filetypes. Mason auto-installs all required binaries via `mason-tool-installer`.

**Tech Stack:** Neovim 0.11+ native LSP, typescript-language-server, vscode-langservers-extracted (html/css/eslint), tailwindcss-language-server, prettier, conform.nvim, nvim-ts-autotag, mason-tool-installer.nvim

---

## Note on Testing

This is Neovim config — there are no automated tests. Each task ends with a manual verification step in a real Neovim session. Steps include what to open, what to look for, and what success looks like.

---

### Task 1: Add missing Treesitter parsers

**Files:**
- Modify: `nvim/lua/custom/plugins/treesitter.lua:6`

Treesitter needs `tsx`, `css`, and `scss` parsers. They're currently missing. `tsx` is a separate parser from `typescript` in Treesitter (they are different grammars). `nvim-ts-autotag` (added later) also needs these.

**Step 1: Add the three parsers to ensure_installed**

Open `nvim/lua/custom/plugins/treesitter.lua`. On line 6, change:

```lua
ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'python', 'go', 'javascript', 'typescript', 'rust' },
```

to:

```lua
ensure_installed = { 'bash', 'c', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'python', 'go', 'javascript', 'typescript', 'tsx', 'css', 'scss', 'rust' },
```

**Step 2: Verify it loads without Lua errors**

```bash
nvim --headless -u nvim/init.lua +'lua print("ok")' +qa 2>&1
```

Expected: prints `ok` with no error output.

**Step 3: Commit**

```bash
git add nvim/lua/custom/plugins/treesitter.lua
git commit -m "feat: add tsx, css, scss treesitter parsers"
```

---

### Task 2: Add mason-tool-installer for auto-installing web dev binaries

**Files:**
- Modify: `nvim/lua/custom/plugins/mason.lua`

Currently Mason has no `ensure_installed` — servers must be installed manually. `mason-tool-installer.nvim` adds this. It reads an `ensure_installed` list and installs any missing tools on startup.

**Step 1: Rewrite mason.lua to include both mason and mason-tool-installer**

Replace the entire contents of `nvim/lua/custom/plugins/mason.lua` with:

```lua
return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    opts = {
      ensure_installed = {
        -- Web dev servers (added now)
        'typescript-language-server',
        'eslint-lsp',
        'vscode-langservers-extracted', -- provides html, cssls, jsonls
        'tailwindcss-language-server',
        'prettier',
      },
    },
  },
}
```

**Step 2: Verify it loads without Lua errors**

```bash
nvim --headless -u nvim/init.lua +'lua print("ok")' +qa 2>&1
```

Expected: `ok` with no errors.

**Step 3: Commit**

```bash
git add nvim/lua/custom/plugins/mason.lua
git commit -m "feat: add mason-tool-installer with web dev binaries"
```

**Step 4: Manual verification — install the binaries**

Launch a real Neovim session:

```bash
nvim
```

Run `:Lazy sync` to install `mason-tool-installer`. Then run `:MasonToolsInstall` (or it may auto-run). Open `:Mason` and confirm `typescript-language-server`, `eslint-lsp`, `vscode-langservers-extracted`, `tailwindcss-language-server`, and `prettier` are all installed (green checkmark).

---

### Task 3: Add 5 LSP server configs and update LspAttach

**Files:**
- Modify: `nvim/lua/custom/lsp-config.lua`

This is the biggest task. We add 5 server configs and update the `LspAttach` autocmd in two ways:
1. Skip LSP format-on-save for web filetypes (Prettier will handle those via conform in Task 4)
2. Add special ESLint handling: run `EslintFixAll` on save instead of LSP format

**Step 1: Add the 5 server configs**

In `nvim/lua/custom/lsp-config.lua`, after the `-- YAML LSP` block (around line 116) and before the `vim.lsp.enable` call, add:

```lua
-- TypeScript / JavaScript LSP (type checking, completions, inlay hints)
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- ESLint LSP (linting diagnostics; auto-fix wired in LspAttach below)
vim.lsp.config('eslint', {
  cmd = { 'vscode-eslint-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx' },
  root_markers = { '.eslintrc', '.eslintrc.js', '.eslintrc.cjs', '.eslintrc.json', '.eslintrc.yaml', '.eslintrc.yml', 'eslint.config.js', 'eslint.config.mjs', 'package.json', '.git' },
  settings = {
    validate = 'on',
    lint = { enable = true },
    format = false, -- Prettier handles formatting
    run = 'onType',
    workingDirectory = { mode = 'location' },
  },
})

-- HTML LSP
vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    provideFormatter = false, -- Prettier handles formatting
  },
})

-- CSS / SCSS / Less LSP
vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json', '.git' },
  settings = {
    css = { validate = true },
    scss = { validate = true },
    less = { validate = true },
  },
})

-- Tailwind CSS LSP (only activates when tailwind.config.* is present)
vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = { 'html', 'css', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'tailwind.config.cjs', 'tailwind.config.mjs', 'postcss.config.js', 'postcss.config.ts' },
  settings = {
    tailwindCSS = {
      validate = true,
    },
  },
})
```

**Step 2: Update vim.lsp.enable() to include the new servers**

Find the existing `vim.lsp.enable` call (line 122):

```lua
vim.lsp.enable({ 'bashls', 'clangd', 'gopls', 'jsonls', 'lua_ls', 'ruff', 'ty', 'yamlls' })
```

Replace with:

```lua
vim.lsp.enable({ 'bashls', 'clangd', 'gopls', 'jsonls', 'lua_ls', 'ruff', 'ty', 'yamlls', 'ts_ls', 'eslint', 'html', 'cssls', 'tailwindcss' })
```

**Step 3: Update LspAttach to handle ESLint and skip web format**

Find the `LspAttach` callback function (around line 128). Inside the callback, find the format-on-save block:

```lua
    -- Format on save with timeout protection
    if client.supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = event.buf,
            async = false,
            timeout_ms = 2000,
          })
        end,
      })
    end
```

Replace it with:

```lua
    -- ESLint: fix all auto-fixable issues on save (linting, not formatting)
    if client.name == 'eslint' then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = event.buf,
        callback = function()
          vim.cmd('EslintFixAll')
        end,
      })
    end

    -- Format on save via LSP — skipped for web filetypes (conform/Prettier handles those)
    local web_filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html', 'css', 'scss', 'less' }
    local is_web = vim.tbl_contains(web_filetypes, vim.bo[event.buf].filetype)
    if client.supports_method('textDocument/formatting') and not is_web then
      vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({
            bufnr = event.buf,
            async = false,
            timeout_ms = 2000,
          })
        end,
      })
    end
```

**Step 4: Verify it loads without Lua errors**

```bash
nvim --headless -u nvim/init.lua +'lua print("ok")' +qa 2>&1
```

Expected: `ok` with no errors.

**Step 5: Commit**

```bash
git add nvim/lua/custom/lsp-config.lua
git commit -m "feat: add ts_ls, eslint, html, cssls, tailwindcss LSP configs"
```

**Step 6: Manual verification**

Create a small test file:

```bash
echo 'const x: number = "wrong"' > /tmp/test.ts
nvim /tmp/test.ts
```

Expected:
- Red squiggle under `"wrong"` (ts_ls type error: Type 'string' is not assignable to type 'number')
- Run `:LspInfo` — should show `ts_ls` attached
- Press `K` on a symbol — should show hover documentation
- Press `gd` on a symbol — should go to definition

---

### Task 4: Create webdev.lua with Prettier, auto-tag, and 2-space indent

**Files:**
- Create: `nvim/lua/custom/plugins/webdev.lua`

This file groups all web-specific plugin config. `conform.nvim` runs Prettier on save. `nvim-ts-autotag` auto-closes HTML/JSX tags. An autocmd sets 2-space indentation for web filetypes (the global default is 4 spaces).

**Step 1: Create the file**

Create `nvim/lua/custom/plugins/webdev.lua` with the following contents:

```lua
return {
  -- Prettier formatting via conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false, -- Don't fall back to LSP; Prettier or nothing
      },
    },
  },

  -- Auto-close and auto-rename HTML/JSX tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}
```

**Step 2: Add a 2-space indent autocmd**

`conform.nvim` handles formatting, but indentation settings (how Neovim inserts spaces as you type) are separate. Add this autocmd after the `return { ... }` block — but since Lua `return` must be last, place it in the `config` function of conform. Cleanest approach: add a standalone autocmd at the bottom of the file using a `vim.api.nvim_create_autocmd` call inside an `init` function or, simpler, by appending a separate non-plugin entry at the bottom that uses a no-op plugin trick.

The cleanest pattern matching your codebase: add the autocmd as a third entry in the return table using a dummy plugin that runs an `init` function:

```lua
return {
  -- Prettier formatting via conform.nvim
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    opts = {
      formatters_by_ft = {
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
      },
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = false,
      },
    },
  },

  -- Auto-close and auto-rename HTML/JSX tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },
}
```

Then add an `after/ftplugin` file for each web filetype to set 2-space indent. Create `nvim/after/ftplugin/javascript.lua`:

```lua
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
```

Create the same content for: `typescript.lua`, `javascriptreact.lua`, `typescriptreact.lua`, `html.lua`, `css.lua`, `scss.lua`.

These files live in `nvim/after/ftplugin/` and are auto-sourced by Neovim when the matching filetype is detected. They use `vim.opt_local` (not `vim.opt`) so they only affect the current buffer.

**Step 3: Create the ftplugin files**

```bash
mkdir -p nvim/after/ftplugin
```

Create `nvim/after/ftplugin/javascript.lua`:
```lua
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
```

Create the same 3-line content in each of these files:
- `nvim/after/ftplugin/typescript.lua`
- `nvim/after/ftplugin/javascriptreact.lua`
- `nvim/after/ftplugin/typescriptreact.lua`
- `nvim/after/ftplugin/html.lua`
- `nvim/after/ftplugin/css.lua`
- `nvim/after/ftplugin/scss.lua`

**Step 4: Verify it loads without Lua errors**

```bash
nvim --headless -u nvim/init.lua +'lua print("ok")' +qa 2>&1
```

Expected: `ok` with no errors.

**Step 5: Commit**

```bash
git add nvim/lua/custom/plugins/webdev.lua nvim/after/ftplugin/
git commit -m "feat: add conform/prettier, nvim-ts-autotag, and 2-space indent for web filetypes"
```

**Step 6: Manual verification — Prettier formatting**

1. Install prettier globally (if not already): `npm install -g prettier`
2. Create a messy JS file:
   ```bash
   echo 'const x={a:1,b:2};function foo(x,y){return x+y}' > /tmp/test.js
   nvim /tmp/test.js
   ```
3. Save with `:w` — file should auto-format to multi-line, properly spaced output
4. Confirm indentation is 2 spaces (not 4)

**Step 7: Manual verification — auto-tag**

```bash
echo '<div></div>' > /tmp/test.html
nvim /tmp/test.html
```

1. Position cursor on `div` in the opening tag, press `cw` to change word, type `section`
2. The closing `</div>` should automatically rename to `</section>`

---

## Post-Installation Notes

- **Prettier**: Must be available per-project (`npm install --save-dev prettier`) or globally (`npm install -g prettier`). conform silently skips if not found.
- **ESLint**: Requires an ESLint config file in the project root (`.eslintrc.json`, `eslint.config.js`, etc.). The ESLint LSP won't attach without one.
- **Tailwind**: Only activates when `tailwind.config.*` or `postcss.config.*` is found in the project root.
- **ts_ls inlay hints**: Will show parameter names, return types, etc. inline. Toggle with `:lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())` if they get noisy.
