local buf_utils = require("astrocore.buffer")
local rooter_is_on = vim.g.internal_rooter_scope == "tab"

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

        -- Finder keymaps
        maps.n["<Leader>f"] = vim.tbl_get(opts, "_map_sections", "f")
        maps.v["<Leader>f"] = { desc = "🔎 Find" }

        maps.n["<localleader><tab>"] = {
          function() Snacks.picker.smart() end,
          desc = "Smart Find Files",
        }

        maps.n["<localleader>,"] = {
          function() Snacks.picker.buffers() end,
          desc = "Buffers",
        }

        maps.n["<Leader>fq"] = {
          function() Snacks.picker.qflist() end,
          desc = "Quickfix List",
        }

        maps.n["<Leader>fj"] = {
          function() Snacks.picker.jumps() end,
          desc = "Jumplist",
        }

        maps.n["<Leader>f<CR>"] = {
          function() Snacks.picker.resume() end,
          desc = "Resume previous search",
        }

        maps.n["<Leader>f'"] = {
          function() Snacks.picker.marks() end,
          desc = "Find marks",
        }

        maps.n["<Leader>f/"] = {
          function() Snacks.picker.lines() end,
          desc = "Find words in current buffer",
        }

        maps.n["<Leader>fc"] = {
          function() Snacks.picker.grep_word() end,
          desc = "Find word under cursor",
        }

        maps.n["<Leader>f;"] = {
          function() Snacks.picker.command_history() end,
          desc = "Find commands history",
        }

        maps.n["<Leader>f:"] = {
          function() Snacks.picker.commands() end,
          desc = "Find commands",
        }

        maps.n["<Leader>ff"] = {
          function() Snacks.picker.smart() end,
          desc = "Find files",
        }
        maps.n["<Leader>ff"] = {
          function()
            Snacks.picker.smart({
              cwd = V.nvim_workspaces_root(),
            })
          end,
          desc = "Find files (WOrkspace)",
        }

        maps.n["<Leader>fh"] = {
          function() Snacks.picker.help() end,
          desc = "Find help",
        }

        maps.n["<Leader>fk"] = {
          function() Snacks.picker.keymaps() end,
          desc = "Find keymaps",
        }

        maps.n["<Leader>fm"] = {
          function() Snacks.picker.man() end,
          desc = "Find man",
        }

        maps.n["<Leader>fr"] = {
          function() Snacks.picker.registers() end,
          desc = "Find registers",
        }

        if vim.fn.executable("rg") == 1 or vim.fn.executable("grep") == 1 then
          maps.n["<Leader>fs"] = {
            function() Snacks.picker.grep() end,
            desc = "Grep words",
          }
          maps.n["<Leader>fg"] = {
            function() Snacks.picker.grep({ live = true }) end,
            desc = "Live grep",
          }
          maps.v["<Leader>fg"] = {
            function()
              Snacks.picker.grep({
                live = true,
                search = V.nvim_visual_text(),
              })
            end,
            desc = "Live grep selection",
          }

          if rooter_is_on then
            maps.n["<Leader>fS"] = {
              function() Snacks.picker.grep({ cwd = V.nvim_workspaces_root() }) end,
              desc = "Grep words (Workspace root)",
            }
            maps.n["<Leader>fG"] = {
              function() Snacks.picker.grep({ live = true, cwd = V.nvim_workspaces_root() }) end,
              desc = "Live grep (Workspace root)",
            }
            maps.v["<Leader>fG"] = {
              function()
                Snacks.picker.grep({ live = true, cwd = V.nvim_workspaces_root(), search = V.nvim_visual_text() })
              end,
              desc = "Live grep (Workspace root)",
            }
          end
        end

        -- Git keymaps
        if vim.fn.executable("git") == 1 then
          maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
          maps.n["<Leader>gf"] = "[+] Git fuzzy"
          maps.n["<Leader>gfb"] = {
            function() Snacks.picker.git_branches() end,
            desc = "Git branches",
          }
          maps.n["<Leader>gfc"] = {
            function() Snacks.picker.git_log() end,
            desc = "Git commits (repository)",
          }
          maps.n["<Leader>gfC"] = {
            function() Snacks.picker.git_log_file() end,
            desc = "Git commits (current file)",
          }
          maps.n["<Leader>gfs"] = {
            function() Snacks.picker.git_status() end,
            desc = "Git status",
          }
        end

        -- LSP keymaps
        if maps.n.gd then maps.n.gd[1] = function() Snacks.picker.lsp_definitions() end end
        if maps.n.gri then maps.n.gri[1] = function() Snacks.picker.lsp_implementations() end end
        if maps.n.grr then maps.n.grr[1] = function() Snacks.picker.lsp_references() end end
        if maps.n.gy then maps.n.gy[1] = function() Snacks.picker.lsp_type_definitions() end end
        if maps.n["<Leader>lG"] then maps.n["<Leader>lG"][1] = function() Snacks.picker.lsp_workspace_symbols() end end
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
      enabled = true,
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
