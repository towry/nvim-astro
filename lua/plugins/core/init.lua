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
      opts.delay = function(ctx) return ctx.plugin and 0 or 200 end
      opts.defer = function(ctx) return ctx.mode == "V" or ctx.mode == "<C-V>" end

      opts.preset = "helix"
      opts.win = {
        no_overlap = false,
        border = "single",
        title_pos = "left",
        wo = {
          winblend = 20,
        },
      }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.window = {
        completion = cmp.config.window.bordered({
          border = "single",
          winhighlight = "CursorLine:PmenuSel,NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          winblend = 0,
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          border = "single",
        }),
      }
      return opts
    end,
  },
}
