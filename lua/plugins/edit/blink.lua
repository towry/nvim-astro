return {
  "Saghen/blink.cmp",
  version = false,
  optional = true,
  build = "nix run --accept-flake-config .#build-plugin",
  opts = function(_, opts)
    opts.cmdline = {
      enabled = false,
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
          preselect = true,
          auto_insert = function(ctx) return ctx.mode == "cmdline" end,
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
  end,
}
