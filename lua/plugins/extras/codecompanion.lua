return {
  "olimorris/codecompanion.nvim",
  event = { "VeryLazy" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- The following are optional:
    "nvim-telescope/telescope.nvim", -- For using slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
    },
    adapters = {
      opts = {
        allow_insecure = false, -- Use if required
        proxy = "socks5://127.0.0.1:1080",
      },
    },
  },
}
