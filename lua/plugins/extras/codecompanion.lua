return {
  "olimorris/codecompanion.nvim",
  event = { "VeryLazy" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "codecompanion" },
      },
      ft = { "markdown", "codecompanion" },
    },
    {
      "echasnovski/mini.diff", -- Inline and better diff over the default
      config = function()
        local diff = require("mini.diff")
        diff.setup({
          -- Disabled by default
          source = diff.gen_source.git(),
        })
      end,
    },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  opts = {
    display = {
      diff = {
        enabled = true,
        close_chat_at = 240,
        layout = "vertical",
        provider = "mini_diff",
      },
    },
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
        keymaps = {
          accept_change = {
            modes = { n = "ga" },
            description = "Accept the suggested change",
          },
          reject_change = {
            modes = { n = "gr" },
            description = "Reject the suggested change",
          },
        },
      },
    },
    adapters = {
      deepseek = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          env = {
            url = "https://api.deepseek.com",
            api_key = vim.env.DEEPSEEK_API_KEY,
            chat_url = "/chat/completions",
          },
          schema = {
            model = {
              default = "deepseek-coder",
            },
          },
          headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. vim.env.DEEPSEEK_API_KEY,
          },
          parameters = {
            sync = true,
          },
        })
      end,
      opts = {
        allow_insecure = false, -- Use if required
        proxy = "socks5://127.0.0.1:1080",
      },
    },
  },

  specs = {
    {
      "j-hui/fidget.nvim",
      opts = function() require("plugins.extras.codecompanion-extras.fidget-spinner"):init() end,
    },
  },
}
