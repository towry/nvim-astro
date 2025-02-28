return {
  "Saghen/blink.cmp",
  version = false,
  optional = true,
  build = "nix run --accept-flake-config .#build-plugin",
  opts = function(_, opts)
    opts.keymap = opts.keymap or {}

    opts.cmdline = {
      enabled = false,
    }
    opts.appearance = {
      use_nvim_cmp_as_default = true,
    }
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      ghost_text = { enabled = false },
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },

      trigger = vim.tbl_deep_extend("force", vim.tbl_get(opts, "completion", "trigger") or {}, {
        prefetch_on_insert = false,
      }),
      list = vim.tbl_deep_extend("force", vim.tbl_get(opts, "completion", "list") or {}, {
        selection = vim.tbl_deep_extend("force", vim.tbl_get(opts, "completion", "list", "selection") or {}, {
          preselect = false,
          auto_insert = true,
          -- auto_insert = function(ctx) return ctx.mode == "cmdline" end,
        }),
        cycle = {
          from_bottom = true,
          from_top = true,
        },
      }),
      menu = vim.tbl_deep_extend("force", vim.tbl_get(opts, "completion", "menu") or {}, {
        border = "single",
        draw = {
          treesitter = {},
        },
      }),
      documentation = vim.tbl_deep_extend("force", vim.tbl_get(opts, "documentation") or {}, {
        treesitter_highlighting = false,
        window = {
          border = "single",
        },
      }),
    })

    ---- MARK: keymaps of blink

    opts.keymap["<C-E>"] = {
      function(cmp)
        if V.plugin_has_ai_suggestion_text() then vim.fn["copilot#Clear"]() end
        return cmp.hide()
      end,
      "fallback",
    }
    opts.keymap["<C-P>"] = {
      function(cmp)
        if cmp.is_menu_visible() and cmp.get_selected_item() then return cmp.select_prev() end

        if V.plugin_has_ai_suggestions() then
          if cmp.is_menu_visible() then cmp.hide() end
          vim.fn["copilot#Previous"]()
          return
        end

        return cmp.show()
      end,
    }
    opts.keymap["<C-N>"] = {
      function(cmp)
        if cmp.is_menu_visible() and cmp.get_selected_item() then return cmp.select_next() end

        if V.plugin_has_ai_suggestions() then
          if cmp.is_menu_visible() then cmp.hide() end
          vim.fn["copilot#Next"]()
          return
        end

        return cmp.show()
      end,
    }
  end,
}
