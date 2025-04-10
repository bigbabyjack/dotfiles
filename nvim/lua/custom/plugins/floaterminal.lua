local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  -- Set the background color for the terminal window
  vim.api.nvim_win_set_option(win, "winhl", "Normal:TermBackground,FloatBorder:TermBackground")

  return { buf = buf, win = win }
end


local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    -- Automatically enter insert mode when terminal is opened
    vim.cmd('startinsert')
  else
    -- Store the mode before hiding the window
    local is_in_insert_mode = vim.api.nvim_get_mode().mode:match('i')
    vim.api.nvim_win_hide(state.floating.win)
    -- If we were in insert mode, restore it for the next buffer
    if is_in_insert_mode then
      vim.defer_fn(function() vim.cmd('stopinsert') end, 10)
    end
  end
end

-- Example usage:
-- Create a floating window with default dimensions
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})

-- Set up a key mapping to toggle the terminal
vim.keymap.set("n", "<leader>tt", function()
  toggle_terminal()
end, { desc = "Toggle floating terminal" })

vim.keymap.set("t", "<Esc><Esc>", function()
  if vim.api.nvim_win_is_valid(state.floating.win) then
    vim.api.nvim_win_hide(state.floating.win)
  end
end, { desc = "Close floating terminal" })

return {}
