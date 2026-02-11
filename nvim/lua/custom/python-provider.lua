-- Configure Python provider for Neovim remote plugins (like Molten)
-- This ensures pynvim is available for remote plugin functionality

-- Try to use uv's python3 if available, otherwise use system python3
local function find_python()
  -- Try uv run python3 first (project-specific)
  local handle = io.popen('uv run which python3 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    if result and result ~= '' then
      return vim.trim(result)
    end
  end

  -- Fall back to system python3
  return vim.fn.exepath('python3')
end

vim.g.python3_host_prog = find_python()
