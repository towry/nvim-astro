-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

local V = require("v")

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
    rooter = {
      autochdir = true,
      scope = vim.g.internal_rooter_scope or "tab",
      notify = true,
      detector = {
        "lsp", -- highest priority is getting workspace from running language servers
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json" }, -- lastly check for known project root files
      },
      ignore = {
        servers = {
          "null-ls",
          "efm",
          "tailwindcss",
        },
        dirs = {
          "~/.cargo/*",
        },
      },
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = {
        virt_text_pos = "eol",
        spacing = 1,
        hl_mode = "blend",
      },
      underline = true,
      float = {
        border = "single",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        background = "dark",
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        timeoutlen = 400, -- which-key delay
        cmdheight = 1,
        fillchars = {
          stl = " ",
          stlnc = " ",
          eob = " ",
          fold = "·",
          foldsep = "│",
          foldopen = "-",
          foldclose = "+",
          -- deleted lines of the diff option
          diff = " ",
        },
      },
      g = { -- vim.g.<key>
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
      },
    },
    commands = {
      PcloseNextEsc = {
        function() vim.g.escape_cmd = "pclose" end,
        nargs = 0,
        bar = true,
        desc = "Close popup and quickfix, used in keymap",
      },
      QfCloseNextEsc = {
        function() vim.g.escape_cmd = "cclose" end,
        nargs = 0,
        bar = true,
      },
      Diffbufnr = {
        function(params) vim.cmd(([[tab exec "diffsplit" bufname(%s)]]):format(params.args)) end,
        desc = "Git diff with bufnr",
      },
    },

    autocmds = {
      resession_auto_save = false,
    },
  },
}
