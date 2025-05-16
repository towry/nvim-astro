return {
  { import = "plugins.core.astrocore" },
  { import = "plugins.core.astroui" },
  { import = "plugins.core.disabled" },
  { import = "plugins.core.smart-split" },
  {
    "windwp/nvim-autopairs",
    optional = true,
    opts = {
      ignored_next_char = "[%w%.]",
    },
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.notify = true
      opts.triggers = opts.triggers or {
        { "<auto>", mode = "nixsotc" },
      }
      opts.delay = function(ctx) return ctx.plugin and 0 or 150 end
      opts.defer = function(ctx) return ctx.mode == "V" or ctx.mode == "<C-V>" end

      opts.preset = "helix"
      opts.win = {
        no_overlap = true,
        border = "single",
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
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.preselect = cmp.PreselectMode.Item
      opts.completion = vim.tbl_deep_extend("keep", {
        completeopt = "menu,menuone",
      }, opts.completion or {})
      opts.sources = vim.tbl_deep_extend("force", {
        { name = "nvim_lsp_signature_help" },
      }, opts.sources or {})

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
