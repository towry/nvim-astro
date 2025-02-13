return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    picker = { ui_select = true },
    input = {},
    indent = {},
    scope = {},
    scratch = {},
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
