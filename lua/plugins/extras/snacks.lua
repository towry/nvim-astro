local V = require("v")

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

        --- pickers
        maps.n["<Leader>f"] = vim.tbl_get(opts, "_map_sections", "f")
        maps.v["<Leader>f"] = {
          desc = "🔎 Find",
        }

        maps.n["<Leader>f<CR>"] = {
          function() Snacks.picker.resume() end,
          desc = "Resume previous search",
        }

        maps.n["<Leader>f'"] = { function() Snacks.picker.marks() end, desc = "Find marks" }
        maps.n["<Leader>f/"] = { function() Snacks.picker.lines() end, desc = "Find words in current buffer" }
        maps.n["<Leader>fr"] = { function() Snacks.picker.registers() end, desc = "Find registers" }
        maps.n["<Leader>fs"] = {
          function()
            Snacks.picker.grep_word({
              layout = "vertical",
            })
          end,
          desc = "Grep words",
        }
        maps.n["<Leader>fc"] = {
          function()
            Snacks.picker.grep_word({
              layout = "vertical",
              search = vim.fn.expand("<cword>"),
            })
          end,
          desc = "Find word under cursor",
        }

        maps.n["<leader>fj"] = {
          function() Snacks.picker.jumps() end,
          desc = "Jumps",
        }

        -- maps.n["<localleader>,"] = {
        --   function() Snacks.picker.buffers() end,
        --   desc = "Buffers",
        -- }

        --- scratch keymaps
        maps.n["<Leader>xs"] = {
          function() Snacks.scratch() end,
          desc = "Toggle Scratch",
        }
        maps.n["<Leader>xS"] = {
          function() Snacks.scratch.select() end,
          desc = "Select Scratch",
        }

        ---- explores
        maps.n["<leader>ee"] = {
          function() Snacks.explorer.reveal() end,
          desc = "Explorer reveal",
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
      "AstroNvim/astrolsp",
      opts = function(_, opts)
        ---- https://github.com/AstroNvim/astrocommunity/blob/main/lua/astrocommunity/fuzzy-finder/snacks-picker/init.lua
        local maps = opts.mappings
        -- local astro = require("astrocore")
        --- Lsp keymaps
        maps.n.gd = {
          function() Snacks.picker.lsp_definitions() end,
          desc = "LSP Definitions",
        }

        maps.n["<leader>le"] = {
          function() Snacks.picker.lsp_symbols() end,
          desc = "LSP Symbols",
        }
        if maps.n.gri then maps.n.gri[1] = function() Snacks.picker.lsp_implementations() end end
        if maps.n.grr then maps.n.grr[1] = function() Snacks.picker.lsp_references() end end
        if maps.n.gy then maps.n.gy[1] = function() Snacks.picker.lsp_type_definitions() end end
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
