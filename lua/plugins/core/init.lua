return {
  { import = "plugins.core.astrocore" },
  -- { import = "plugins.core.astrolsp" },
  { import = "plugins.core.astroui" },
  { import = "plugins.core.disabled" },
  { import = "plugins.core.smart-split" },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.notify = true
      opts.triggers = opts.triggers or {
        { "<auto>", mode = "nixsotc" },
      }
      opts.delay = function(ctx) return ctx.plugin and 0 or 150 end
      opts.defer = function(ctx) return ctx.mode == "V" or ctx.mode == "<C-V>" end

      opts.preset = "modern"
      opts.win = {
        no_overlap = true,
        border = "none",
        title_pos = "center",
        wo = {
          winblend = 20,
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.preselect = cmp.PreselectMode.Item
      opts.completion = vim.tbl_deep_extend("keep", {
        completeopt = "menu,menuone",
      }, opts.completion or {})

      opts.window = {
        completion = cmp.config.window.bordered({
          border = "none",
          winhighlight = "CursorLine:PmenuSel,Normal:NormalFloat,FloatBorder:WinSeparator",
          winblend = 50,
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          border = "none",
        }),
      }
      return opts
    end,
  },
}
