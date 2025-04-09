return {
  {
    dir = "~/workspace/flux.nvim",
    dependencies = {
      "lunarmodules/luasocket",
    },
    config = function()
      require "flux.init".setup({})
    end
  }
}
