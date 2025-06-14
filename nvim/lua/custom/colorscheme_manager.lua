-- ~/.config/nvim/lua/colorscheme_manager.lua
local M = {}

-- 🎨  Put every colourscheme you keep installed here
local schemes = {
  "tokyonight-storm",
  "gruvbox-material",
  "rose-pine-moon",
  "catppuccin-mocha",
}

function M.apply_default_scheme()
  pcall(vim.cmd.colorscheme, "rose-pine-moon")
end

local state_file = vim.fn.stdpath("state") .. "/current_colorscheme"

-- Internal helper ------------------------------------------------------------
local function _write_state(name)
  -- Write the chosen scheme to disk so it survives restarts
  vim.fn.writefile({ name }, state_file)
end

local function _apply(name)
  local ok, err = pcall(vim.cmd.colorscheme, name)
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

  if ok then
    _write_state(name)
  else
    vim.notify("Colourscheme “" .. name .. "” failed: " .. err,
      vim.log.levels.ERROR)
  end
end
-------------------------------------------------------------------------------

---Public API------------------------------------------------------------------
---Apply a scheme *and* persist it
---@param name string
function M.set(name) _apply(name) end

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
  local f = io.open(state_file, "r")
  if f then
    local name = f:read("*l")
    f:close()
    if name and name ~= "" then
      pcall(vim.cmd.colorscheme, name)
      -- vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
    end
  end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Telescope picker: live-preview & fuzzy-find colourschemes
-- Usage:  <leader>cs  or  :ColorSchemePick
-- ─────────────────────────────────────────────────────────────────────────────
local function telescope_picker()
  local ok, _ = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope isn’t installed", vim.log.levels.ERROR)
    return
  end

  local pickers   = require("telescope.pickers")
  local finders   = require("telescope.finders")
  local previewer = require("telescope.previewers").new_buffer_previewer
  local conf      = require("telescope.config").values
  local actions   = require("telescope.actions")
  local state     = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title    = "Colourschemes",
    finder          = finders.new_table { results = schemes },
    sorter          = conf.generic_sorter({}),
    previewer       = previewer {
      define_preview = function(self, entry)
        -- apply & persist on every cursor move
        _apply(entry[1])
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false,
          { "Previewing: " .. entry[1] })
      end,
    },
    attach_mappings = function(bufnr, _)
      -- confirm selection
      actions.select_default:replace(function()
        local sel = state.get_selected_entry()
        actions.close(bufnr)
        _apply(sel[1])
      end)
      return true
    end,
  }):find()
end

M.pick = telescope_picker -- public API

-- -- Commands & key-mapping ------------------------------------------------------
vim.api.nvim_create_user_command("ColorSchemePick", telescope_picker, {})
vim.keymap.set("n", "<leader>cs",
  function() M.pick() end,
  { desc = "Pick colourscheme (Telescope)" })

-------------------------------------------------------------------------------
---
vim.api.nvim_set_hl(1, "Normal", { bg = "None" })

-- Expose commands so you don’t have to remember Lua calls
vim.api.nvim_create_user_command("ColorNext", M.next, {})
vim.api.nvim_create_user_command("ColorPrev", M.prev, {})
vim.api.nvim_create_user_command("ColorSchemeSet", function(opts)
  M.set(opts.args)
end, { nargs = 1, complete = function() return schemes end })

vim.keymap.set("n", "<leader>cn", function() M.next() end,
  { desc = "Next colourscheme" })
vim.keymap.set("n", "<leader>cp", function() M.prev() end,
  { desc = "Previous colourscheme" })

return M
