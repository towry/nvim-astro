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
      poll_rate = 100,
      override_vim_notify = true,
      view = {
        -- fix https://github.com/yioneko/vtsls/issues/159
        render_message = function(msg, count) 
          if msg and msg:match("vtsls:") then
            return ""
          end
          return (cnt ~= nil and cnt <= 1) and msg or string.format("(%dx) %s", cnt or 0, msg or "")
        end
      },
      window = {
        winblend = 35,
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
