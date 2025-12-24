return {
  'mrcjkb/rustaceanvim',
  version = '^6',
  lazy = false,
  ft = { 'rust' },
  opts = {
    -- Disable automatic DAP configuration (prevents Mason codelldb error)
    dap = {
      adapter = false,
    },
    server = {
      on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc })
        end

        -- Rust-specific keybindings
        map('<leader>ca', function()
          vim.cmd.RustLsp 'codeAction'
        end, '[C]ode [A]ction')

        map('<leader>dr', function()
          vim.cmd.RustLsp 'debuggables'
        end, '[D]ebuggables [R]un')

        map('<leader>rr', function()
          vim.cmd.RustLsp 'runnables'
        end, '[R]unnables [R]un')

        map('K', function()
          vim.cmd.RustLsp { 'hover', 'actions' }
        end, 'Hover Actions')

        -- Enable inlay hints by default for Rust
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end,
      default_settings = {
        ['rust-analyzer'] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          checkOnSave = {
            allFeatures = true,
            command = 'clippy',
          },
          procMacro = {
            enable = true,
            ignored = {
              ['async-trait'] = { 'async_trait' },
              ['napi-derive'] = { 'napi' },
              ['async-recursion'] = { 'async_recursion' },
            },
          },
          inlayHints = {
            bindingModeHints = {
              enable = false,
            },
            chainingHints = {
              enable = true,
            },
            closingBraceHints = {
              enable = true,
              minLines = 25,
            },
            closureReturnTypeHints = {
              enable = 'never',
            },
            lifetimeElisionHints = {
              enable = 'never',
              useParameterNames = false,
            },
            maxLength = 25,
            parameterHints = {
              enable = true,
            },
            reborrowHints = {
              enable = 'never',
            },
            renderColons = true,
            typeHints = {
              enable = true,
              hideClosureInitialization = false,
              hideNamedConstructor = false,
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    vim.g.rustaceanvim = vim.tbl_deep_extend('keep', vim.g.rustaceanvim or {}, opts or {})
  end,
}
