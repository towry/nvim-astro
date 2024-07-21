local V = require("v")

return {
  "stevearc/oil.nvim",
  lazy = (V.nvim_empty_argc() and not vim.env.NVIM),
  event = { "TabEnter", "TermOpen" },
  cmd = "Oil",
  opts = function(_, opts)
    return vim.tbl_deep_extend("force", opts, {
      --- fix issue when opening nvim inside terminal
      default_file_explorer = not vim.env.NVIM,
      columns = {
        "icon",
      },
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = {
          callback = function() require("oil").select({ horizontal = true }) end,
          desc = "Open the entry under the cursor in a horizontal split",
          nowait = true,
        },
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        -- TODO: move to mini.visits
        ["mv"] = function() require("userlib.mini.visits").list_oil_folders_in_cwd(vim.cfg.runtime__starts_cwd) end,
        ["md"] = function()
          -- remove all oil visited paths
          local visits = require("mini.visits")
          visits.remove_label("oil-folder-visited", nil, vim.cfg.runtime__starts_cwd)
          visits.write_index()
        end,
        ["mm"] = function()
          local oil = require("oil")
          local lcwd = oil.get_current_dir()
          local visits = require("mini.visits")
          visits.add_label("oil-folder-visited", lcwd, vim.cfg.runtime__starts_cwd)
          visits.write_index()
        end,
        ["M"] = function()
          local oil = require("oil")
          -- type: file|directory
          local current = require("oil").get_cursor_entry()
          if not current then return end
          local lcwd = oil.get_current_dir()
          local file, folder = nil, nil
          if not current or current.type == "directory" then
            file = nil
            folder = lcwd .. current.name
          elseif current.type == "file" then
            folder = nil
            file = lcwd .. current.name
          end

          if folder then
            require("plugins.utils._folder-action").open(folder)
          else
            -- require("userlib.hydra.file-action").open(file, 0)
          end
        end,
        ["Y"] = "actions.copy_entry_path",
        ["-"] = "actions.parent",
        ["_"] = function()
          if vim.w.oil_lcwd ~= nil then
            require("oil").open(vim.w.oil_lcwd)
            vim.w.oil_lcwd = nil
          else
            vim.w.oil_lcwd = require("oil").get_current_dir()
            --- toggle with current and project root.
            require("oil").open(vim.fn.getcwd(-1, 0))
          end
        end,
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["g."] = "actions.toggle_hidden",
      },
      use_default_keymaps = false,
      skip_confirm_for_simple_edits = true,
      delete_to_trash = false,
      view_options = {},
      lsp_file_methods = {
        autosave_changes = "unmodified",
      },
      float = {
        padding = 4,
        border = "single",
        win_options = {
          winblend = 0,
          -- statuscolumn = '',
          colorcolumn = "",
        },
      },
    })
  end,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<leader>f|"] = { [[:pclose | vert Oil<cr>]], desc = "Open oil in vertical split" },
            ["<leader>f-"] = {
              function()
                if vim.bo.buftype ~= "" then return end
                -- otherwise error: A preview window already opened
                vim.cmd("pclose")
                require("oil").open()
              end,
              desc = "Open oil file browser(buf) relative to current buffer",
            },
          },
        },
        autocmds = {
          oil_settings = {
            {
              event = "FileType",
              desc = "Disable view saving for oil buffers",
              pattern = "oil",
              callback = function(args) vim.b[args.buf].view_activated = false end,
            },
            {
              event = "User",
              pattern = "OilActionsPost",
              desc = "Close buffers when files are deleted in Oil",
              callback = function(args)
                if args.data.err then return end
                for _, action in ipairs(args.data.actions) do
                  if action.type == "delete" then
                    local _, path = require("oil.util").parse_url(action.url)
                    local bufnr = vim.fn.bufnr(path)
                    if bufnr ~= -1 then require("astrocore.buffer").wipe(bufnr, true) end
                  end
                end
              end,
            },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      optional = true,
      dependencies = { "AstroNvim/astroui", opts = { status = { winbar = { enabled = { filetype = { "^oil$" } } } } } },
      opts = function(_, opts)
        if opts.winbar then
          local status = require("astroui.status")
          table.insert(opts.winbar, 1, {
            condition = function(self) return status.condition.buffer_matches({ filetype = "^oil$" }, self.bufnr) end,
            status.component.separated_path({
              padding = { left = 2 },
              max_depth = false,
              suffix = false,
              path_func = function(self) return require("oil").get_current_dir(self.bufnr) end,
            }),
          })
        end
      end,
    },
  },
}
