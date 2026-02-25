-- ============================================================================
-- Native Neovim 0.11+ LSP Configuration (No Mason/lspconfig plugins needed)
-- ============================================================================

-- Setup global capabilities for completion
vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities()),
})

-- ============================================================================
-- Language Server Configurations
-- ============================================================================

-- Bash LSP
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  root_markers = { '.git' },
})

-- C/C++ LSP
vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

-- Go LSP
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

-- JSON LSP with schema validation
vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Lua LSP
vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- lazydev.nvim will configure workspace settings
    },
  },
})

-- Python type checking (Pyright) - Commented out in favor of ty
-- vim.lsp.config('pyright', {
--   cmd = { 'pyright-langserver', '--stdio' },
--   filetypes = { 'python' },
--   root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
--   settings = {
--     pyright = {
--       disableOrganizeImports = true, -- Let ruff handle this
--     },
--     python = {
--       analysis = {
--         diagnosticSeverityOverrides = {
--           reportUndefinedVariable = 'none',
--         },
--       },
--     },
--   },
-- })

-- Python linting/formatting (Ruff)
vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.git' },
})

-- Python type checking (ty - Astral's fast type checker)
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  settings = {
    ty = {
      -- Optional: Specify custom configuration file path
      -- configurationFile = "./.config/ty.toml"
    }
  }
})

-- YAML LSP with schema validation
vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.gitlab' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemaStore = {
        enable = true,
        url = 'https://www.schemastore.org/api/json/catalog.json',
      },
      schemas = require('schemastore').yaml.schemas(),
    },
  },
})

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

-- ============================================================================
-- Enable all configured language servers
-- ============================================================================

vim.lsp.enable({ 'bashls', 'clangd', 'gopls', 'jsonls', 'lua_ls', 'ruff', 'ty', 'yamlls', 'ts_ls', 'eslint', 'html', 'cssls', 'tailwindcss' })

-- ============================================================================
-- LspAttach - Buffer-local keymaps and features
-- ============================================================================

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Keybindings
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    -- Get client to check capabilities
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Special handling for ruff - disable hover/definition (let pyright handle these)
    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.definitionProvider = false
    end

    -- Enable inlay hints if supported (Neovim 0.10+)
    if client.supports_method('textDocument/inlayHint') or client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

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

    -- Document highlighting
    if client.supports_method('textDocument/documentHighlight') then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
