local prefix = "<Leader>A"

return {
  "yetone/avante.nvim",
  event = "User AstroFile",
  version = false, --
  cond = vim.env.DEEPSEEK_API_KEY ~= nil,
  cmd = {
    "AvanteAsk",
    "AvanteBuild",
    "AvanteEdit",
    "AvanteRefresh",
    "AvanteSwitchProvider",
    "AvanteChat",
    "AvanteToggle",
    "AvanteClear",
  },
  opts = {
    provider = "deepseek",
    auto_suggestions_provider = "deepseek",
    behaviour = {
      auto_suggestions = true,
      auto_apply_diff_after_generation = true,
    },
    mappings = {
      ask = "<M-i>",
      edit = "<M-e>",
      refresh = prefix .. "r",
      focus = prefix .. "f",
      toggle = {
        default = prefix .. "t",
        debug = prefix .. "d",
        hint = prefix .. "h",
        suggestion = prefix .. "s",
        repomap = prefix .. "R",
      },
      diff = {
        next = "]c",
        prev = "[c",
      },
      files = {
        add_current = prefix .. ".",
      },
    },
    vendors = {
      deepseek = {
        __inherited_from = "openai",
        -- https://api-docs.deepseek.com/api/create-chat-completion
        -- endpoint = "https://api.deepseek.com/chat/completions",
        endpoint = "https://api.deepseek.com",
        model = "deepseek-coder",
        api_key_name = "DEEPSEEK_API_KEY",
        temperature = 0,
        max_tokens = 8000,
        timeout = 30000, -- Timeout in milliseconds
      },
    },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
    --- The below dependencies are optional,
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  specs = {
    { "AstroNvim/astroui", opts = { icons = { Avante = "" } } },
  },
}
