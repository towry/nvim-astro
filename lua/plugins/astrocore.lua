-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 2, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = false, -- enable notifications at start
    },
    root = {
      autodir = true,
      scope = "tab",
      notify = true,
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      i = {
        ["jj"] = { "<ESC>", nowait = true, noremap = true },
      },
      -- first key is the mode
      n = {

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        ["<C-c><C-k>"] = {
          function()
            local tabs_count = vim.fn.tabpagenr "$"
            if tabs_count <= 1 then
              vim.cmd 'silent! hide | echo "hide current window"'
              return
            end
            --- get current tab's window count
            local win_count = require("v").tab_win_count()
            if win_count <= 1 then
              local choice = vim.fn.confirm("Close last window in tab?", "&Yes\n&No", 2)
              if choice == 2 then return end
              return
            end
            vim.cmd 'silent! hide | echo "hide current window"'
          end,
          desc = "Kill current window",
        },
        ["<C-c><C-d>"] = {
          function()
            if vim.fn.exists "&winfixbuf" == 1 and vim.api.nvim_get_option_value("winfixbuf", { win = 0 }) then
              vim.cmd "hide"
              return
            end
            require("astrocore.buffer").close(0)
          end,
          desc = "Delete current buffer",
        },
        ["A-q"] = {
          function()
            local current_win_is_qf = vim.bo.filetype == "qf"
            if current_win_is_qf then
              vim.cmd "wincmd p"
            else
              -- focus on qf window
              vim.cmd "copen"
            end
          end,
          desc = "Switch between quickfix window and previous window",
        },
        ["<leader>np"] = {
          function()
            local reg = vim.v.register or '"'
            vim.cmd(":put " .. reg)
            vim.cmd [[normal! `[v`]=]]
          end,
          expr = false,
          noremap = true,
          silent = false,
          desc = "Paste in next line and format",
        },
        ["<leader>nP"] = {
          function()
            local reg = vim.v.register or '"'
            vim.cmd(":put! " .. reg)
            vim.cmd [[normal! `[v`]=]]
          end,
          expr = false,
          noremap = true,
          silent = false,
          desc = "Paste in above line and format",
        },

        ---- git
        ["<localleader>w"] = vim.g.cfg_inside.git and {
          ":w|cq",
          nowait = true,
          noremap = true,
          desc = "Git mergetool: prepare write and exit safe",
        } or nil,
        ["<localleader>c"] = vim.g.cfg_inside.git and {
          ":cq 1",
          desc = "Git mergetool: Prepare to abort",
          nowait = true,
          noremap = true,
        } or nil,
      },
      v = {
        ["dp"] = {
          [[:<C-u>'<,'>diffput<cr>]],
          desc = "Diffput in visual",
          silent = true,
        },
        ["do"] = {
          [[:<C-u>'<,'>diffget<cr>]],
          desc = "Diffget in visual",
          silent = true,
        },
      },
    },
  },
}
