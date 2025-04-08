return {
  {
    dir = "~/workspace/ai-editor.nvim",
    dependencies = {
      "lunarmodules/luasocket",
    },
    config = function()
      require "ai-editor".setup({})
    end
  }
}
