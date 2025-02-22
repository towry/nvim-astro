local buf_utils = require("astrocore.buffer")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings

        --- scratch keymaps
        maps.n["<Leader>xs"] = {
          function() Snacks.scratch() end,
          desc = "Toggle Scratch",
        }
        maps.n["<Leader>xS"] = {
          function() Snacks.scratch.select() end,
          desc = "Select Scratch",
        }
      end,
    },
  },
  opts = {
    notifier = {
      enabled = false,
    },
    dashboard = {
      enabled = false,
    },
    picker = {
      enabled = false,
      ui_select = false,
      layout = {
        cycle = true,
        preset = function() return vim.o.columns >= 120 and "default" or "vertical" end,
      },
      layouts = {
        vertical = {
          layout = {
            backdrop = false,
            width = 0.5,
            min_width = 80,
            height = 0.8,
            min_height = 30,
            box = "vertical",
            border = "single",
            title = "{title} {live} {flags}",
            title_pos = "center",
            { win = "input", height = 1, border = "bottom" },
            { win = "list", border = "none" },
            { win = "preview", title = "{preview}", height = 0.4, border = "top" },
          },
        },
        default = {
          layout = {
            box = "horizontal",
            width = 0.8,
            min_width = 120,
            height = 0.8,
            {
              box = "vertical",
              border = "single",
              title = "{title} {live} {flags}",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "none" },
            },
            { win = "preview", title = "{preview}", border = "single", width = 0.5 },
          },
        },
      },
    },
    input = {},
    indent = {
      filter = function(bufnr)
        return buf_utils.is_valid(bufnr)
          and not buf_utils.is_large(bufnr)
          and vim.g.snacks_indent ~= false
          and vim.b[bufnr].snacks_indent ~= false
      end,
    },
    scope = {
      filter = function(bufnr) return buf_utils.is_valid(bufnr) and not buf_utils.is_large(bufnr) end,
    },
    scratch = {},
    explorer = {
      enabled = false,
      replace_netrw = true,
    },
  },
  specs = {
    { "nvim-telescope/telescope.nvim", enabled = false },
    { "stevearc/dressing.nvim", enabled = false, opts = { select = { enabled = false } } },
  },
}
