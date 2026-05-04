return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = function()
      local lsp_clients = function()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ''
        end
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return ' ' .. table.concat(names, ',')
      end

      return {
        options = {
          theme = 'auto',
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = {
            'branch',
            'diff',
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
            },
          },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { lsp_clients, 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'lazy', 'oil', 'quickfix' },
      }
    end,
  },
}
