return {
  {
    "stevearc/overseer.nvim",
    optional = true,
    opts = function()
      local overseer = require("overseer")
      overseer.register_template({
        name = "nim.build",
        builder = function()
          return {
            cmd = { "nim" },
            args = {
              "c",
              vim.fn.expand("%:p"),
            },
          }
        end,
        condition = {
          filetype = { "nim" },
        },
      })
    end,
  },
}
