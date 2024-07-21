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
        event = "neo_tree_buffer_enter",
        handler = function() vim.cmd([[setlocal relativenumber]]) end,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = function() vim.cmd([[setlocal norelativenumber]]) end,
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
      go_to_root = function()
        require("neo-tree.command").execute({
          dir = vim.uv.cwd(),
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

        require("userlib.mini.clue.folder-action").open(cwd)
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
          jump = {
            jumplist = false,
          },
          label = {
            after = { 0, 0 },
            style = "overlay",
            reuse = "all",
            min_pattern_length = 1,
          },
          pattern = "^",
          highlight = {
            backdrop = false,
            matches = false,
            groups = {
              match = "Search",
              current = "Search",
              label = "Search",
            },
          },
        })
      end,
    },

    buffers = {
      window = {
        mappings = {
          ["<esc>"] = false,
          ["s"] = "flash_jump",
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
            ["<Leader>ee"] = { "<Cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
            ["<Leader>e."] = {
              function()
                if vim.bo.filetype == "neo-tree" then
                  vim.cmd.wincmd("p")
                else
                  vim.cmd.Neotree("focus")
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
