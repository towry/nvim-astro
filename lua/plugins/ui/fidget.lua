local V = require("v")

return {
  "j-hui/fidget.nvim",
  enabled = not V.git_start_nvim(),
  specs = {
    { "rcarriga/nvim-notify", optional = true, enabled = false },
  },
  opts = {
    progress = {
      ignore = {
        "null-ls",
        "tailwindcss",
        "jsonls",
        -- "copilot",
      },
    },
    notification = {
      override_vim_notify = true,
      window = {
        winblend = 15,
        normal_hl = "NormalFloat",
        max_width = 50,
        border = "solid",
        -- align = 'top',
      },
    },
  },
  init = function()
    vim.notify = function(...) require("fidget").notify(...) end
  end,
}
