return {
  "shortcuts/no-neck-pain.nvim",
  version = "*",
  config = function()
    require("no-neck-pain").setup({
      width = 120,
      buffers = {
        wo = {
          fillchars = "eob: ",
        },
      },
    })

    vim.keymap.set("n", "<leader>nn", function()
      require("no-neck-pain").toggle()
    end, { desc = "Toggle [N]o [N]eck Pain" })

    vim.keymap.set("n", "<leader>nr", function()
      local nopain = require("no-neck-pain")
      if not nopain.state then
        return
      end
      if not nopain.state.enabled then
        return
      end

      local win = vim.api.nvim_get_current_win()
      local width = vim.api.nvim_win_get_width(win)
      -- take input from the user for new size
      local new_width = vim.fn.input("Current width: " .. tostring(width) .. " New width: ")
      if new_width == "" then
        return
      end
      if tonumber(new_width) == nil then
        return
      end
      if tonumber(new_width) < 0 then
        return
      end
      if tonumber(new_width) == width then
        return
      end

      nopain.resize(tonumber(new_width))
    end, { desc = "Resize" })
  end
}
