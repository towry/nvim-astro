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
  keys = {
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
      ["Next edit suggestion"] = {
        strategy = "inline",
        description = "Get the next edit suggestion that user can directly apply to the code without user editing",
        prompts = {
          {
            role = "system",
            content = function(context)
              return "I want you to act as a senior "
                .. context.filetype
                .. " developer. I will ask you to suggest some edits to the code, you should suggest the best and only one edit at a time, so user can apply your suggestion without further modification."
            end,
          },
          {
            role = "user",
            content = function(_context)
              local prompts = {
                "I have the following edit changes in vim editor for current buffer, please suggest the next best edit and only one at a time.",
                "Make sure only code changes are suggested, so the user can apply the changes directly.",
                "Here are the edit changes to current buffer:",
                "",
                vim.fn.execute("changes"),
                "",
              }

              return table.concat(prompts, "\n")
            end,
          },
        },
        opts = {
          placement = "replace",
          short_name = "next",
          contains_code = true,
          auto_submit = true,
          stop_context_insertion = true,
          user_prompt = false,
        },
      },
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
  },

  specs = {
    {
      "j-hui/fidget.nvim",
      opts = function() require("plugins.extras.codecompanion-extras.fidget-spinner"):init() end,
    },
  },
}
