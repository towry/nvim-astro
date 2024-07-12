return {
  { import = "plugins.core.astrocore" },
  { import = "plugins.core.astrolsp" },
  { import = "plugins.core.astroui" },
  { import = "plugins.core.disabled" },
  { import = "plugins.core.smart-split" },
  {
    "folke/which-key.nvim",
    opts = {
      modes = {
        --- issue 1: if press C-d in visual mode, the which-key window will be scrolled down instead of
        --- scroll down the selection.
        -- x = false,
      },
      preset = "modern",
      win = {
        border = "single",
      },
    },
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
