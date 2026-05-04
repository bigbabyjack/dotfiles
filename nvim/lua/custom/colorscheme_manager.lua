-- ~/.config/nvim/lua/colorscheme_manager.lua
local M = {}

-- 🎨  Put every colourscheme you keep installed here
local schemes = {
  'tokyonight-storm',
  'gruvbox-material',
  'rose-pine-moon',
  'catppuccin-mocha',
}

function M.apply_default_scheme()
  pcall(vim.cmd.colorscheme, 'rose-pine-moon')
end

local state_file = vim.fn.stdpath 'state' .. '/current_colorscheme'

-- Internal helper ------------------------------------------------------------
local function _write_state(name)
  -- Write the chosen scheme to disk so it survives restarts
  vim.fn.writefile({ name }, state_file)
end

local function _apply(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })

  if ok then
    _write_state(name)
  else
    vim.notify('Colourscheme “' .. name .. '” failed: ' .. err, vim.log.levels.ERROR)
  end
end
-------------------------------------------------------------------------------

---Public API------------------------------------------------------------------
---Apply a scheme *and* persist it
---@param name string
function M.set(name)
  _apply(name)
end

---Cycle to the next scheme in the list
function M.next()
  local cur = vim.g.colors_name
  local idx = 1
  for i, s in ipairs(schemes) do
    if s == cur then
      idx = i
      break
    end
  end
  _apply(schemes[(idx % #schemes) + 1])
end

---Cycle to the previous scheme in the list
function M.prev()
  local cur = vim.g.colors_name
  local idx = 1
  for i, s in ipairs(schemes) do
    if s == cur then
      idx = i
      break
    end
  end
  _apply(schemes[((idx - 2 + #schemes) % #schemes) + 1])
end

---Read the saved choice (if any) and apply it at start-up
function M.apply_saved()
  local f = io.open(state_file, 'r')
  if f then
    local name = f:read '*l'
    f:close()
    if name and name ~= '' then
      pcall(vim.cmd.colorscheme, name)
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'None' })
    end
  end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- fzf-lua picker: fuzzy-find + persist colourschemes
-- Usage:  <leader>cs  or  :ColorSchemePick
-- ─────────────────────────────────────────────────────────────────────────────
local function fzf_picker()
  local ok, fzf = pcall(require, 'fzf-lua')
  if not ok then
    vim.notify('fzf-lua isn’t installed', vim.log.levels.ERROR)
    return
  end

  local original = vim.g.colors_name
  fzf.fzf_exec(schemes, {
    prompt = 'Colourscheme> ',
    actions = {
      ['default'] = function(selected)
        if selected and selected[1] then
          _apply(selected[1])
        end
      end,
      ['esc'] = function()
        if original then
          pcall(vim.cmd.colorscheme, original)
        end
      end,
    },
  })
end

M.pick = fzf_picker -- public API

-- Commands & key-mapping ------------------------------------------------------
vim.api.nvim_create_user_command('ColorSchemePick', fzf_picker, {})
vim.keymap.set('n', '<leader>cs', function()
  M.pick()
end, { desc = 'Pick colourscheme' })

-------------------------------------------------------------------------------
---
vim.api.nvim_set_hl(1, 'Normal', { bg = 'None' })

-- Expose commands so you don’t have to remember Lua calls
vim.api.nvim_create_user_command('ColorNext', M.next, {})
vim.api.nvim_create_user_command('ColorPrev', M.prev, {})
vim.api.nvim_create_user_command('ColorSchemeSet', function(opts)
  M.set(opts.args)
end, {
  nargs = 1,
  complete = function()
    return schemes
  end,
})

vim.keymap.set('n', '<leader>cn', function()
  M.next()
end, { desc = 'Next colourscheme' })
vim.keymap.set('n', '<leader>cp', function()
  M.prev()
end, { desc = 'Previous colourscheme' })

return M
