return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    specs = {
      { "nvim-telescope/telescope.nvim", optional = true, enabled = false },
      { "nvim-telescope/telescope-fzf-native.nvim", optional = true, enabled = false },
      { "stevearc/dressing.nvim", optional = true, opts = { select = { backend = { "fzf_lua" } } } },
      {
        "AstroNvim/astrolsp",
        optional = true,
        opts = function(_, opts)
          if require("astrocore").is_available("fzf-lua") then
            local maps = opts.mappings
            maps.n["<Leader>lD"] =
              { function() require("fzf-lua").diagnostics_document() end, desc = "Search diagnostics" }
            if maps.n.gd then maps.n.gd[1] = function() require("fzf-lua").lsp_definitions() end end
            if maps.n.gI then maps.n.gI[1] = function() require("fzf-lua").lsp_implementations() end end
            if maps.n["<Leader>lR"] then
              maps.n["<Leader>lR"][1] = function() require("fzf-lua").lsp_references() end
            end
            if maps.n.gy then maps.n.gy[1] = function() require("fzf-lua").lsp_typedefs() end end
            if maps.n["<Leader>lG"] then
              maps.n["<Leader>lG"][1] = function() require("fzf-lua").lsp_workspace_symbols() end
            end
          end
        end,
      },
    },
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      local local_actions = require("plugins.finder.fzf-lua._actions")
      -- local actions = require("fzf-lua.actions")
      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.fzf["tab"] = "toggle+down"
      config.defaults.keymap.fzf["shift-tab"] = "toggle+up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"
      -- config.defaults.actions.buffers["default"] = local_actions.buffers_open_default
      -- config.defaults.actions.buffers["ctrl-o"] = local_actions.buffers_open_in_window
      config.defaults.actions.files["ctrl-o"] = local_actions.files_open_in_window

      return vim.tbl_deep_extend("force", opts, {
        "default",
        defaults = {
          formatter = "path.filename_first",
          file_icons = true,
        },
        winopts = {
          backdrop = 100,
          border = "single",
          preview = {
            delay = 150,
            layout = "flex",
            flip_columns = 240,
            horizontal = "right:45%",
            vertical = "down:40%",
            -- winopts = {
            --   cursorlineopt = "line",
            --   foldcolumn = 0,
            -- },
          },
        },
        fzf_colors = false,
        fzf_opts = {
          ["--ansi"] = "",
          ["--info"] = "inline",
          ["--height"] = "100%",
          ["--layout"] = "reverse",
          ["--margin"] = "0%",
          ["--padding"] = "0%",
          ["--border"] = "none",
          ["--cycle"] = "",
          ["--no-separator"] = "",
        },
        lsp = {
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      })
    end,
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          local maps = opts.mappings
          local PickerMod = "plugins.finder.fzf-lua._pickers"
          local fmt = string.format
          local rooter_is_on = vim.g.internal_rooter_scope == "tab"
          local picker_method_call = function(method, arg)
            return fmt([[:lua require("%s").%s(%s)<cr>]], PickerMod, method, arg)
          end

          ---- keymap section
          maps.n["<Leader>f"] = vim.tbl_get(opts, "_map_sections", "f")
          maps.v["<Leader>f"] = {
            desc = "🔎 Find",
          }
          -----
          maps.n["<Leader>f."] = {
            "<cmd>FzfLua<cr>",
            desc = "Open FzfLua",
            silent = true,
          }

          maps.n["<localleader>,"] = {
            picker_method_call("buffers_or_recent", "false"),
            desc = "Buffers or recent buffers",
            silent = true,
          }

          maps.n["<Leader>fq"] = {
            "<cmd>FzfLua quickfix<cr>",
            desc = "Quickfix List",
          }

          maps.n["<Leader>fj"] = {
            "<cmd>FzfLua jumps<cr>",
            desc = "Jumplist",
          }

          maps.n["<leader>fo"] = {
            function()
              require(PickerMod).folders({
                cwd = V.nvim_root(),
                cwd_header = true,
              })
            end,
            desc = "Find all folders",
          }
          if rooter_is_on then
            maps.n["<leader>fO"] = {
              function()
                require(PickerMod).folders({
                  cwd = V.nvim_workspaces_root(),
                  cwd_header = true,
                })
              end,
              desc = "Find all folders (global cwd)",
            }
          end

          maps.n["<leader>fz"] = {
            picker_method_call("zoxide_folders"),
            desc = "Zoxide folders",
          }

          if vim.fn.executable("git") == 1 then
            maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
            maps.n["<Leader>gf"] = "[+] Git fuzzy"
            maps.n["<Leader>gfb"] = { function() require("fzf-lua").git_branches() end, desc = "Git branches" }
            maps.n["<Leader>gfc"] =
              { function() require("fzf-lua").git_commits() end, desc = "Git commits (repository)" }
            maps.n["<Leader>gfC"] =
              { function() require("fzf-lua").git_bcommits() end, desc = "Git commits (current file)" }
            maps.n["<Leader>gfs"] = { function() require("fzf-lua").git_status() end, desc = "Git status" }
          end

          maps.n["<Leader>f<CR>"] = {
            function() require("fzf-lua").resume() end,
            desc = "Resume previous search",
          }
          maps.n["<Leader>f'"] = { function() require("fzf-lua").marks() end, desc = "Find marks" }
          maps.n["<Leader>f/"] =
            { function() require("fzf-lua").lgrep_curbuf() end, desc = "Find words in current buffer" }
          maps.n["<Leader>fXa"] = {
            function() require("fzf-lua").files({ prompt = "Config> ", cwd = vim.fn.stdpath("config") }) end,
            desc = "Find nvim config files",
          }

          do
            maps.n["<Leader>fc"] = {
              function()
                require("fzf-lua").grep_cword({
                  cwd = V.nvim_root(),
                })
              end,
              desc = "Find word under cursor",
            }
            if rooter_is_on then
              maps.n["<Leader>fC"] = {
                function()
                  require("fzf-lua").grep_cword({
                    cwd = V.nvim_workspaces_root(),
                  })
                end,
                desc = "Find word under cursor (global cwd)",
              }
            end
          end
          maps.n["<Leader>f;"] = {
            function() require("fzf-lua").command_history() end,
            desc = "Find commands history",
          }
          maps.n["<Leader>f:"] = { function() require("fzf-lua").commands() end, desc = "Find commands" }
          maps.n["<Leader>ff"] = {
            function()
              require("fzf-lua").files({
                cwd = V.nvim_root(),
              })
            end,
            desc = "Find files",
          }
          if rooter_is_on then
            maps.n["<Leader>fF"] = {
              function()
                require("fzf-lua").files({
                  cwd = V.nvim_workspaces_root(),
                })
              end,
              desc = "Find files (global cwd)",
            }
          end
          maps.n["<Leader>fh"] = { function() require("fzf-lua").helptags() end, desc = "Find help" }
          maps.n["<Leader>fk"] = { function() require("fzf-lua").keymaps() end, desc = "Find keymaps" }
          maps.n["<Leader>fm"] = { function() require("fzf-lua").manpages() end, desc = "Find man" }

          maps.n["<leader>f<tab>"] =
            { function() require(PickerMod).buffers_or_recent(true) end, desc = "Find history" }

          maps.n["<Leader>fr"] = { function() require("fzf-lua").registers() end, desc = "Find registers" }

          if vim.fn.executable("rg") == 1 or vim.fn.executable("grep") == 1 then
            maps.n["<Leader>fs"] = {
              function()
                require("fzf-lua").grep({
                  cwd = V.nvim_root(),
                })
              end,
              desc = "Grep words",
            }
            maps.v["<Leader>fS"] = {
              function()
                require("fzf-lua").grep({
                  cwd = V.nvim_root(),
                  query = V.nvim_visual_text(),
                })
              end,
              desc = "Grep words",
            }
            maps.n["<Leader>fg"] = {
              function()
                require("fzf-lua").live_grep_native({
                  cwd = V.nvim_root(),
                })
              end,
              desc = "Grep words",
            }
            maps.v["<Leader>fg"] = {
              function()
                require("fzf-lua").live_grep_native({
                  cwd = V.nvim_root(),
                  query = V.nvim_visual_text(),
                })
              end,
              desc = "Grep words",
            }

            if rooter_is_on then
              maps.n["<Leader>fG"] = {
                function()
                  require("fzf-lua").live_grep_native({
                    cwd = V.nvim_workspaces_root(),
                  })
                end,
                desc = "Grep words (global cwd)",
              }
              maps.v["<Leader>fG"] = {
                function()
                  require("fzf-lua").live_grep_native({
                    cwd = V.nvim_workspaces_root(),
                    query = V.nvim_visual_text(),
                  })
                end,
                desc = "Grep words (global cwd)",
              }
            end
          end

          maps.n["<Leader>ls"] = {
            function()
              require("fzf-lua").lsp_document_symbols({
                regex_filter = require("plugins.finder.fzf-lua._utils").symbols_filter,
              })
            end,
            desc = "Search symbols",
          }
        end,
      },
    },
  },
}
