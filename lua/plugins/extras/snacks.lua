local V = require("v")

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    picker = {
      ui_select = true,
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
    indent = {},
    scope = {},
    scratch = {},
    explorer = {
      replace_netrw = true,
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        ---- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/fuzzy-finder/snacks-picker/init.lua
        local maps = opts.mappings
        -- local astro = require("astrocore")

        --- scratch keymaps
        maps.n["<Leader>xs"] = {
          function() Snacks.scratch() end,
          desc = "Toggle Scratch",
        }
        maps.n["<Leader>xS"] = {
          function() Snacks.scratch.select() end,
          desc = "Select Scratch",
        }

        ----- picker
        maps.n["<Leader>ff"] = {
          function()
            Snacks.picker.files({
              cwd = V.nvim_root(),
            })
          end,
          desc = "Find files",
        }
        maps.n["<Leader>fF"] = {
          function() Snacks.picker.git_files() end,
          desc = "Find git files",
        }
        maps.n["<leader>f<tab>"] = {
          function()
            Snacks.picker.recent({
              cwd = V.nvim_workspaces_root(),
            })
          end,
          desc = "Find recent",
        }
        -- buffers
        maps.n["<localleader>,"] = {
          function() Snacks.picker.buffers() end,
          desc = "Buffers",
        }
        -- quickfix
        maps.n["<Leader>fq"] = {
          function() Snacks.picker.qflist() end,
          desc = "Quickfix",
        }
        -- jumps
        maps.n["<Leader>fj"] = {
          function() Snacks.picker.jumps() end,
          desc = "Jumps",
        }
      end,
    },
    {
      "folke/todo-comments.nvim",
      optional = true,
      dependencies = { "folke/snacks.nvim" },
      specs = {
        {
          "AstroNvim/astrocore",
          opts = {
            mappings = {
              n = {
                ["<Leader>fT"] = {
                  function()
                    if not package.loaded["todo-comments"] then -- make sure to load todo-comments
                      require("lazy").load({ plugins = { "todo-comments.nvim" } })
                    end
                    require("snacks").picker.todo_comments()
                  end,
                  desc = "Todo Comments",
                },
              },
            },
          },
        },
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      optional = true,
      opts = {
        commands = {
          find_in_dir = function(state)
            local node = state.tree:get_node()
            local path = node.type == "file" and node:get_parent_id() or node:get_id()
            require("snacks").picker.files({ cwd = path })
          end,
        },
        window = { mappings = { F = "find_in_dir" } },
      },
    },
    { "nvim-telescope/telescope.nvim", enabled = false },
    { "stevearc/dressing.nvim", enabled = false, opts = { select = { enabled = false } } },
  },
}
