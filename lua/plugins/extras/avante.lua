local prefix = "<Leader>A"

local Providers = {
  deepseek = "deepseek",
  ark = "ark",
  copilot = "copilot",
}
local current = Providers.copilot

return {
  "yetone/avante.nvim",
  event = "User AstroFile",
  -- commit = "0a837a4583d66abaf85c9d31f5efad12af87c736",
  cond = function()
    if vim.g.vscode then return false end

    if current == Providers.deepseek then
      return vim.env.DEEPSEEK_API_KEY ~= nil
    elseif current == Providers.ark then
      return vim.env.ARK_API_KEY ~= nil
    end

    return true
  end,
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
    provider = current,
    auto_suggestions_provider = current,
    behaviour = {
      auto_suggestions = false,
      auto_apply_diff_after_generation = false,
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
        endpoint = "https://api.deepseek.com",
        model = "deepseek-coder",
        api_key_name = "DEEPSEEK_API_KEY",
        temperature = 0,
        max_tokens = 8000,
        timeout = 30000, -- Timeout in milliseconds
      },
      ark = {
        __inherited_from = "openai",
        endpoint = "https://ark.cn-beijing.volces.com/api",
        model = "ep-20250116091506-bn9dd",
        api_key_name = "ARK_API_KEY",
        temperature = 0,
      },
    },

    copilot = {
      -- endpoint = "https://api.githubcopilot.com",
      -- model = "gpt-4o-2024-08-06",
      proxy = "http://localhost:1080", -- [protocol://]host[:port] Use this proxy
      allow_insecure = false, -- Allow insecure server connections
      timeout = 30000, -- Timeout in milliseconds
      temperature = 0,
      max_tokens = 4096,
    },
    suggestion = {
      debounce = 2000,
      throttle = 600,
    },
  },
  build = "make",
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    { "AstroNvim/astrocore", opts = function(_, opts) opts.mappings.n[prefix] = { desc = " Avante" } end },
    --- The below dependencies are optional,
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
