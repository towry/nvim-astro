local V = require("v")

return {
  "github/copilot.vim",
  specs = {
    {
      "pze/codeium.vim",
      optional = true,
      enabled = false,
    },

    {
      "hrsh7th/nvim-cmp",
      optional = true,
      opts = function(_, opts)
        local cmp = require("cmp")
        local cmp_utils = require("plugins.utils._cmp")

        opts.mapping["<C-E>"] = cmp.mapping(function(fallback)
          if V.plugin_has_ai_suggestion_text() then vim.fn["copilot#Clear"]() end
          if not require("cmp").abort() then fallback() end
        end, { "i", "c" })

        opts.mapping["<C-P>"] = cmp.mapping(function()
          if V.plugin_has_ai_suggestions() and not cmp_utils.cmp_has_select(cmp) then
            if cmp_utils.cmp_is_visible(cmp) then cmp.close() end
            vim.fn["copilot#Previous"]()
            return
          end
          if cmp_utils.cmp_is_visible(cmp) then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end)
        opts.mapping["<C-N>"] = cmp.mapping(function()
          if V.plugin_has_ai_suggestions() and not cmp_utils.cmp_has_select(cmp) then
            if cmp_utils.cmp_is_visible(cmp) then cmp.close() end
            vim.fn["copilot#Next"]()
            return
          end
          if cmp_utils.cmp_is_visible(cmp) then
            cmp.select_next_item()
          else
            cmp.complete()
          end
        end)
      end,
    },
  },

  event = { "BufEnter" },
  cmd = { "Copilot" },
  config = function() end,
  init = function()
    local auto_start = true

    if vim.g.copilot_auto_mode == false then auto_start = false end

    vim.g.copilot_workspace_folders = { vim.fn.getcwd() }
    vim.g.copilot_filetypes = {
      ["*"] = auto_start, -- start manually
      ["fzf"] = false,
      ["OverseerForm"] = false,
    }
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_proxy = "127.0.0.1:1080"
    vim.g.copilot_proxy_strict_ssl = false
    vim.api.nvim_create_autocmd({ "FileType" }, {
      pattern = "copilot.*",
      callback = function(ctx)
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
          silent = true,
          buffer = ctx.buf,
          noremap = true,
        })
      end,
    })

    vim.api.nvim_create_user_command("ToggleCopilotAutoMode", function()
      if vim.g.copilot_auto_mode == true then
        -- disable
        vim.g.copilot_auto_mode = false
        vim.g.copilot_filetypes = vim.tbl_extend("keep", {
          ["*"] = false,
        }, vim.g.copilot_filetypes)
        vim.cmd("Copilot disable")
        vim.notify("Copilot auto mode disabled X")
      else
        vim.g.copilot_auto_mode = true
        vim.g.copilot_filetypes = vim.tbl_extend("keep", {
          ["*"] = true,
        }, vim.g.copilot_filetypes)
        vim.cmd("Copilot enable")
        vim.fn["copilot#OnFileType"]()
        vim.notify("Copilot auto mode enabled ✔")
      end
      -- vim.api.nvim_exec_autocmds("User", {
      --   pattern = "CopilotStatus",
      -- })
    end, {})
  end,
  dependencies = {
    V.astro_extend_core({
      mappings = {
        n = {
          ["<Leader>u?"] = {
            desc = "Toggle AI",
          },
          ["<Leader>u?a"] = {
            function() vim.cmd("ToggleCopilotAutoMode") end,
            desc = "Toggle AI(auto)",
            noremap = true,
          },
          ["<Leader>u?<cr>"] = {
            function()
              if vim.g.copilot_enabled == 1 then
                vim.cmd("Copilot disable")
                vim.notify("🤖 Enable copilot", vim.log.levels.INFO, {
                  key = "copilot",
                })
              else
                vim.cmd("Copilot enable")
                vim.notify("🤖 Disable copilot", vim.log.levels.INFO, {
                  key = "copilot",
                })
              end
            end,
            desc = "Toggle AI",
            noremap = true,
          },
        },
        i = {
          ["<M-j>"] = {
            function()
              if V.plugin_has_ai_suggestions() then
                vim.fn["copilot#Next"]()
                return
              end
            end,
            desc = "Copilot next suggestion",
          },
          ["<M-k>"] = {
            function()
              if V.plugin_has_ai_suggestions() then
                vim.fn["copilot#Previous"]()
                return
              end
            end,
            desc = "Copilot previous suggestion",
          },
          ["<C-g>"] = {
            function()
              local core = require("astrocore")
              if core.is_available("nvim-cmp") and package.loaded["cmp"] then
                local cmp = require("cmp")
                if cmp.visible() then vim.schedule(cmp.close) end
              elseif core.is_available("blink.cmp") and package.loaded["blink.cmp"] then
                local cmp = require("blink.cmp")
                if cmp.is_menu_visible() then cmp.hide() end
              end

              local trigger_ai = vim.schedule_wrap(function()
                vim.notify('🤖 AI: "Copilot is thinking.."', vim.log.levels.INFO, { key = "copilot" })
                if vim.fn.exists("*codeium#Suggest") == 1 then vim.fn["copilot#Suggest"]() end
              end)

              if V.plugin_has_ai_suggestions() and V.plugin_has_ai_suggestion_text() then
                if vim.b._copilot then vim.schedule(function() vim.fn.feedkeys(vim.fn["copilot#Accept"](), "i") end) end
              else
                trigger_ai()
              end
            end,
            silent = true,
            nowait = true,
            expr = true,
            noremap = true,
            desc = "Complete AI",
          },
        },
      },
    }),
  },
}
