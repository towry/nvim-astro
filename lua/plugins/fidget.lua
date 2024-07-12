return {
  "j-hui/fidget.nvim",
  event = { "VeryLazy" },
  enabled = not vim.g.cfg_inside.git,
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
        winblend = 30,
        normal_hl = "NormalFloat",
        max_width = 50,
        border = "solid",
        -- align = 'top',
      },
    },
  },
  init = function()
    require("v").nvim_command("FidgetHistory", function() require("fidget.notification").show_history() end, {
      desc = "Show fidget notification history",
    })
  end,
}
