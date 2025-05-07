return {
  "olimorris/codecompanion.nvim",
  event = { "VeryLazy" },
  -- commit = "c0a820e01",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      "ravitemer/mcphub.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
      },
      -- uncomment the following line to load hub lazily
      --cmd = "MCPHub",  -- lazy load
      build = "pnpm add --global mcp-hub@latest", -- Installs required mcp-hub npm module
      -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
      -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
      config = function() require("mcphub").setup() end,
    },
    "ravitemer/codecompanion-history.nvim",
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
          mappings = {
            goto_first = "",
            goto_prev = "",
            goto_next = "",
            goto_last = "",
            textobject = "",
            reset = "",
            apply = "",
          },
        })
      end,
    },
  },
  cmd = {
    "CodeCompanion",
    "CodeCompanionChat",
    "CodeCompanionActions",
  },
  keys = {
    {
      mode = { "v" },
      "<localleader>aa",
      function() vim.cmd("CodeCompanionActions") end,
      desc = "Code Companion: Inline assistant",
    },
    {
      mode = "n",
      "<leader>aa",
      function() vim.cmd("CodeCompanionActions") end,
      desc = "Code Companion: Actions",
    },
    {
      mode = { "n", "v" },
      "<leader>ai",
      function()
        -- use input to get the prompt and run command :CodeCompanion /buffer <prompt>
        -- if in visual mode, run command :'<,'>CodeCompanion /buffer <prompt>
        vim.ui.input({
          prompt = "AI Inline Edit: ",
        }, function(input)
          -- return if input is empty
          if vim.trim(input or "") == "" then return end
          input = vim.trim(input)

          if vim.fn.mode() == "v" then
            vim.cmd(":'<,'>CodeCompanion #buffer " .. input)
          else
            vim.cmd(":CodeCompanion #buffer " .. input)
          end
        end)
      end,
      desc = "Code Companion: Inline assistant",
    },
  },
  opts = {
    prompt_library = {
      ["elixir-with-condition-label"] = require(
        "plugins.extras.codecompanion-extras.prompts.elixir-with-condition-label"
      ),
    },
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
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = "gh",
          -- Automatically generate titles for new chats
          auto_generate_title = true,
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          -- Picker interface ("telescope" or "default")
          picker = "default",
          ---Enable detailed logging for history extension
          enable_logging = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
        },
      },
      mcphub = {
        enabled = true,
        callback = "mcphub.extensions.codecompanion",
        opts = {
          show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
          make_vars = true, -- make chat #variables from MCP server resources
          make_slash_commands = true, -- make /slash_commands from MCP server prompts
        },
      },
    },
  },

  specs = {
    {
      "j-hui/fidget.nvim",
      optional = true,
      opts = function() require("plugins.extras.codecompanion-extras.fidget-spinner"):init() end,
    },
  },
}
