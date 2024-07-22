return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true,
  opts = {
    sources = { "filesystem", "buffers" },
    source_selector = {
      sources = {
        { source = "filesystem", display_name = " File" },
        { source = "buffers", display_name = " Buffers" },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          vim.cmd([[setlocal relativenumber]])
          if args.source == "buffers" then
            vim.cmd([[hi link NeoTreeDirectoryName NeoTreeDimText]])
            vim.cmd([[hi link NeoTreeDirectoryIcon NeoTreeDimText]])
          else
            vim.cmd([[hi clear NeoTreeDirectoryName]])
            vim.cmd([[hi clear NeoTreeDirectoryIcon]])
          end
        end,
      },
      {
        event = "neo_tree_window_before_close",
        handler = function() vim.cmd([[setlocal norelativenumber]]) end,
      },
    },

    window = {
      popup = { -- settings that apply to float position only
        size = {
          height = "60%",
          width = "70%",
        },
        position = "50%", -- 50% means center it
        -- you can also specify border here, if you want a different setting from
        -- the global popup_border_style.
      },
    },

    commands = {
      system_open = function(state) (vim.ui.open)(state.tree:get_node():get_id()) end,
      reveal_last_buf = function()
        if not vim.t.neotree_last_buf or not vim.api.nvim_buf_is_valid(vim.t.neotree_last_buf) then
          vim.notify("no active buffer to reveal", vim.log.levels.INFO)
          return
        end
        local reveal_file = vim.api.nvim_buf_get_name(vim.t.neotree_last_buf)
        if reveal_file == "" then
          vim.notify("no last buffer", vim.log.levels.INFO)
          return
        else
          local f = io.open(reveal_file, "r")
          if f then
            f.close(f)
          else
            return
          end
        end

        require("neo-tree.command").execute({
          dir = vim.uv.cwd(),
          source = "filesystem", -- OPTIONAL, this is the default value
          reveal_file = reveal_file, -- path to file or folder to reveal
          reveal_force_cwd = true, -- change cwd without asking if needed
        })
      end,
      reveal_node_in_tree = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then return end

        require("neo-tree.command").execute({
          source = "filesystem",
          position = state.current_position,
          action = "focus",
          reveal_file = node.path,
        })
      end,
      go_to_root = function()
        require("neo-tree.command").execute({
          dir = V.nvim_workspaces_root(),
          action = "focus",
          source = "filesystem", -- OPTIONAL, this is the default value
          reveal_force_cwd = true, -- change cwd without asking if needed
        })
      end,
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          -- state.commands.open(state)
        end
      end,
      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
        local modify = vim.fn.fnamemodify

        local vals = {
          ["BASENAME"] = modify(filename, ":r"),
          ["EXTENSION"] = modify(filename, ":e"),
          ["FILENAME"] = filename,
          ["PATH (CWD)"] = modify(filepath, ":."),
          ["PATH (HOME)"] = modify(filepath, ":~"),
          ["PATH"] = filepath,
          ["URI"] = vim.uri_from_fname(filepath),
        }

        local options = vim.iter(vim.tbl_keys(vals)):filter(function(val) return vals[val] ~= "" end)

        if vim.tbl_isempty(options) then
          vim.notify("No values to copy", vim.log.levels.WARN)
          return
        end
        table.sort(options)
        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item) return ("%s: %s"):format(item, vals[item]) end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
      end,
      -- run action on folder
      action_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local cwd = node.type == "directory" and path or vim.fn.fnamemodify(path, ":h")

        require("plugins.utils._folder-action").open(cwd)
      end,
      fuzzy_search_dir = function(state)
        require("plugins.finder.fzf-lua._pickers").folders({
          on_select = function(path)
            require("neo-tree.command").execute({
              source = "filesystem",
              position = state.current_position,
              action = "focus",
              reveal_file = path,
            })
          end,
        })
      end,
      unfocus = function() vim.cmd("wincmd p") end,
      flash_jump = function()
        require("flash").jump({
          search = {
            mode = "search",
            max_length = 0,
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" end,
            },
          },
          label = {
            after = { 0, 1 },
            before = false,
            style = "overlay",
            reuse = "all",
          },
          pattern = "\\.[a-z0-9]\\+\\s#\\d\\+\\s",
          action = function(match, state)
            vim.api.nvim_win_call(match.win, function() vim.api.nvim_win_set_cursor(match.win, { match.pos[1], 0 }) end)
            state:restore()
          end,
          highlight = {
            backdrop = false,
            matches = false,
            groups = {
              match = "DiffAdd",
              current = "DiffAdd",
              label = "DiffAdd",
            },
          },
        })
      end,
      flash_jump_open = function(tree_state)
        require("flash").jump({
          labels = "asdfghjklwertyuiopzxcvbnm1234567890",
          search = {
            mode = "search",
            max_length = 0,
            exclude = {
              function(win) return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "neo-tree" end,
            },
          },
          label = {
            after = { 0, 1 },
            before = false,
            -- before = { 0, 0 },
            style = "overlay",
            reuse = "lowercase",
          },
          action = function(match, state)
            state:restore()
            vim.schedule(function()
              if not vim.api.nvim_win_is_valid(match.win) then return end
              vim.api.nvim_win_call(match.win, function()
                vim.api.nvim_win_set_cursor(match.win, { match.pos[1], 0 })
                ---@diagnostic disable-next-line: missing-parameter
                require("neo-tree.sources.common.commands").open(tree_state)
              end)
            end)
          end,
          pattern = "\\.[a-z0-9]\\+\\s#\\d\\+\\s",
          highlight = {
            backdrop = false,
            matches = false,
            groups = {
              match = "DiffDelete",
              current = "DiffDelete",
              label = "DiffDelete",
            },
          },
        })
      end,
    },

    filesystem = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --               -- the current file is changed while the tree is open.
        leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      window = {
        mappings = {
          ["V"] = "open_vsplit",
          ["<leader>fo"] = "fuzzy_search_dir",
          ["/"] = false,
          ["M"] = "action_in_dir",
        },
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true, -- This will find and focus the file in the active buffer every time
        --              -- the current file is changed while the tree is open.
        leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
      },
      group_empty_dirs = true, -- when true, empty directories will be grouped together

      window = {
        mappings = {
          ["<esc>"] = false,
          ["s"] = "flash_jump",
          ["-"] = "flash_jump_open",
          ["M"] = "action_in_dir",
          ["V"] = "open_vsplit",
          ["e"] = { "reveal_node_in_tree", desc = "Reveal node in tree", nowait = true },
        },
      },
    },
  },

  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["-"] = {
              "<cmd>Neotree source=buffers float reveal action=focus<cr>",
              desc = "Open buffers",
            },
            ["_"] = {
              "<cmd>Neotree source=filesystem float reveal action=focus<cr>",
              desc = "Open file tree",
            },
            ["<Leader>ee"] = {
              function()
                if vim.bo.filetype == "neo-tree" then
                  vim.cmd.wincmd("p")
                else
                  vim.cmd("Neotree focus position=left reveal=true")
                end
              end,
              desc = "Toggle Explorer Focus",
            },
          },
        },
      },
    },
  },
}
