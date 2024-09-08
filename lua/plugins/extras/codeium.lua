local V = require("v")

return {
  "pze/codeium.vim",
  lazy = true,
  -- event = { "InsertEnter" },
  cmd = { "Codeium" },
  specs = {
    {
      "hrsh7th/nvim-cmp",
      opts = function(_, opts)
        local cmp = require("cmp")
        local cmp_utils = require("plugins.utils._cmp")

        opts.mapping["<C-E>"] = cmp.mapping(function(fallback)
          if vim.g.codeium_enabled == 1 and V.plugin_has_ai_suggestion_text() then vim.fn["codeium#Clear"]() end
          if not require("cmp").abort() then fallback() end
        end, { "i", "c" })

        opts.mapping["<C-P>"] = cmp.mapping(function()
          if vim.g.codeium_enabled == 1 and V.plugin_has_ai_suggestions() then
            if cmp_utils.cmp_is_visible(cmp) then cmp.close() end
            vim.fn["codeium#CycleCompletions"](-1)
            return
          end
          if cmp_utils.cmp_is_visible(cmp) then
            cmp.select_prev_item()
          else
            cmp.complete()
          end
        end)
        opts.mapping["<C-N>"] = cmp.mapping(function()
          if vim.g.codeium_enabled == 1 and V.plugin_has_ai_suggestions() then
            if cmp_utils.cmp_is_visible(cmp) then cmp.close() end
            vim.fn["codeium#CycleCompletions"](1)
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
  dependencies = {
    V.astro_extend_core({
      mappings = {
        n = {
          ["<Leader>u?"] = {
            desc = "Toggle AI",
          },
          ["<Leader>u?a"] = {
            function()
              vim.cmd("Codeium Toggle")
              if vim.g.codeium_enabled == 1 then
                vim.g.codeium_manual = 0
                vim.notify("🤖 Enable auto codeium", vim.log.levels.INFO, {
                  key = "codeium",
                })
              else
                vim.g.codeium_manual = 1
                vim.fn["codeium#Clear"]()
                vim.notify("🤖 Disable auto codeium", vim.log.levels.INFO, {
                  key = "codeium",
                })
              end
            end,
            desc = "Toggle AI(auto)",
            noremap = true,
          },
          ["<Leader>u?<cr>"] = {
            function()
              vim.cmd("Codeium Toggle")
              if vim.g.codeium_enabled == 1 then
                vim.notify("🤖 Enable codeium", vim.log.levels.INFO, {
                  key = "codeium",
                })
              else
                vim.fn["codeium#Clear"]()
                vim.notify("🤖 Disable codeium", vim.log.levels.INFO, {
                  key = "codeium",
                })
              end
            end,
            desc = "Toggle AI",
            noremap = true,
          },
        },
        i = {
          ["<C-g>"] = {
            function()
              local core = require("astrocore")
              if core.is_available("nvim-cmp") and package.loaded["cmp"] then
                local cmp = require("cmp")
                if cmp.visible() then vim.schedule(cmp.close) end
              end

              local trigger_ai = vim.schedule_wrap(function()
                vim.notify('🤖 AI: "Codeium"', vim.log.levels.INFO, { key = "codeium" })
                if vim.fn.exists("*codeium#Complete") == 1 then vim.fn["codeium#Complete"]() end
              end)

              if V.plugin_has_ai_suggestions() and V.plugin_has_ai_suggestion_text() then
                if vim.b._codeium_completions then
                  vim.schedule(function() vim.fn.feedkeys(vim.fn["codeium#Accept"](), "i") end)
                end
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
  config = function() end,
  init = function()
    vim.g.codeium_enabled = false
    vim.g.codeium_disable_bindings = 1
    vim.g.codeium_no_map_tab = true
    vim.g.codeium_manual = false
    vim.g.codeium_filetypes = {
      ["*"] = true,
      ["oil"] = false,
      ["gitcommit"] = true,
      ["fzf"] = false,
      ["TelescopePrompt"] = false,
      ["TelescopeResults"] = false,
      ["DressingInput"] = false,
      ["DressingSelect"] = false,
    }
  end,
}
