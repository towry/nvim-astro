local V = require("v")

return {
  { import = "plugins.git.fugitive" },
  {
    -- TODO: how to start inside nvim automatically
    "whiteinge/diffconflicts",
    cmd = { "DiffConflicts", "DiffConflictsWithHistory" },
    event = "User AstroGitFile",
    lazy = not V.git_start_nvim(),
    config = function() end,
    dependencies = {
      "tpope/vim-fugitive",
      V.astro_extend_core({
        commands = {
          GitOpenTwowayBlame = {
            function(params)
              local function is_valid_rev(rev)
                local res = vim.system({ "git", "rev-parse", "--verify", rev }):wait()
                if res.code ~= 0 then return false end
                return true
              end

              local line1 = params.line1
              local line2 = params.line2

              local rev = vim.trim(params.args)
              if not rev then
                vim.notify("git revision is required", vim.log.levels.ERROR)
                return
              end
              if not is_valid_rev(rev) then
                vim.notify("git revision is invalid", vim.log.levels.ERROR)
                return
              end

              local line_args = ""
              if params.range and params.range >= 1 then line_args = ("-L %d,%d"):format(line1, line2) end

              local bufname = vim.fn.bufname("%")
              -- create new tab for HEAD
              vim.cmd(("tab Git blame HEAD %s -- %s"):format(line_args, bufname))
              -- in new tab
              vim.cmd(("hor botright Git blame %s %s -- %s"):format(rev, line_args, bufname))
            end,
            range = true,
            desc = "Open blame view for current buffer(HEAD) in new tab agast another revision",
            nargs = 1,
            complete = function(arg)
              local list = {
                "MERGE_HEAD",
                "REBASE_HEAD",
                "HEAD",
                "@mh",
                "@rh",
                "ORIG_HEAD",
                "REVERT_HEAD",
              }
              if not arg or arg == "" then return list end
              return vim.fn.matchfuzzy(list, arg)
            end,
          },
        },
      }),
    },
  },
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>bu",
        "<cmd>:UndotreeToggle<cr>",
        desc = "Toggle undo tree",
      },
    },
    cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow" },
    init = function()
      local g = vim.g
      g.undotree_WindowLayout = 1
      g.undotree_SetFocusWhenToggle = 1
      g.undotree_SplitWidth = 30
      g.undotree_DiffAutoOpen = 1
    end,
  },
  {
    "junegunn/gv.vim",
    dependencies = {
      "tpope/vim-fugitive",
    },
    cmd = "GV",
    config = false,
    keys = {
      {
        "<leader>gz",
        "<cmd>GV<cr>",
        desc = "Git logs with GV",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        ignore_whitespace = false,
        delay = 300,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000,
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      on_attach = function(bufnr)
        local get_icon = require("astroui").get_icon
        local astrocore = require("astrocore")
        local prefix, maps = "gh", astrocore.empty_map_table()
        for _, mode in ipairs({ "n", "v" }) do
          maps[mode][prefix] = { desc = get_icon("Git", 1, true) .. "Gitsigns" }
        end

        maps.n[prefix .. "."] = { ":Gitsigns", desc = ":Gitsigns" }
        maps.n[prefix .. "l"] = {
          "<cmd>Gitsigns setloclist<cr>",
          desc = "Put hunks in location list",
        }
        maps.n[prefix .. "b"] =
          { function() require("gitsigns").toggle_current_line_blame() end, desc = "View Git blame" }
        maps.n[prefix .. "B"] =
          { function() require("gitsigns").blame_line({ full = true }) end, desc = "View full Git blame" }
        maps.n[prefix .. "p"] = { function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Git hunk" }
        maps.n[prefix .. "r"] = { function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" }
        maps.v[prefix .. "r"] = {
          function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          desc = "Reset Git hunk",
        }
        maps.n[prefix .. "R"] = { function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" }
        maps.n[prefix .. "s"] = { function() require("gitsigns").stage_hunk() end, desc = "Stage Git hunk" }
        maps.v[prefix .. "s"] = {
          function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
          desc = "Stage Git hunk",
        }
        -- maps.n[prefix .. "a"] = { function() require("gitsigns").stage_buffer() end, desc = "Stage Git buffer" }
        maps.n[prefix .. "u"] = { function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage Git hunk" }
        maps.n[prefix .. "d"] = { function() require("gitsigns").diffthis() end, desc = "View Git diff" }

        maps.n["gh<"] = {
          function()
            local gs = require("gitsigns")
            vim.schedule(function() gs.nav_hunk("first") end)
          end,
          desc = "First hunk",
        }
        maps.n["gh>"] = {
          function()
            local gs = require("gitsigns")
            vim.schedule(function() gs.nav_hunk("last") end)
          end,
          desc = "Last hunk",
        }
        maps.n["gh]"] = { function() require("gitsigns").next_hunk() end, desc = "Next Git hunk" }
        maps.n["gh["] = { function() require("gitsigns").prev_hunk() end, desc = "Previous Git hunk" }
        for _, mode in ipairs({ "o", "x" }) do
          maps[mode]["ig"] = { ":<C-U>Gitsigns select_hunk<CR>", desc = "inside Git hunk" }
        end

        astrocore.set_mappings(maps, { buffer = bufnr })
      end,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    optional = true,
    dependencies = {
      V.astro_extend_core({
        mappings = {
          n = {
            ["<leader>gt"] = {
              "<cmd>lua require('plugins.git._tig').toggle_tig()<cr>",
              desc = "Toggle tig",
            },
            ["<leader>gx"] = {
              "<cmd>lua require('plugins.git._git-fixup').fixup()<cr>",
              desc = "Fixup current staged",
            },
          },
        },
        commands = {
          TigFile = {
            function() require("plugins.git._tig").toggle_tig_file_history() end,
            desc = "Tig current file",
          },
        },
      }),
    },
  },
}
