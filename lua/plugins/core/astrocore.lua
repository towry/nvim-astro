-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---- experimental: disable hit-enter-prompt
---- require https://github.com/neovim/neovim/pull/27855
pcall(function()
  -- if vim.g.vscode then return end
  -- vim.schedule(function()
  --   require("vim._extui").enable({
  --     enable = true,
  --     messages = {
  --       pos = "box",
  --     },
  --   })
  --
  --   --- temp fix strange issue with this new api.
  --   vim.cmd('echo "Hi towry"')
  -- end)
end)

---@type LazySpec
return {
  "AstroNvim/astrocore",
  branch = "v2",
  version = false,
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 2, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = false, -- highlight URLs at start
      notifications = false, -- enable notifications at start
    },
    rooter = {
      autochdir = false,
      scope = vim.g.internal_rooter_scope or "tab",
      notify = true,
      detector = {
        "lsp", -- highest priority is getting workspace from running language servers
        { ".git", "_darcs", ".hg", ".bzr", ".svn" }, -- next check for a version controlled parent directory
        { "lua", "MakeFile", "package.json", "mix.lock" }, -- lastly check for known project root files
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
        border = "none",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        laststatus = 3,
        showtabline = 0,
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
        timeoutlen = 400, -- which-key delay
        completeopt = "menu,menuone,noselect,fuzzy",
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
      CopyFilepath = {
        -- copy relative file path
        function() vim.fn.setreg("+", vim.fn.expand("%:p:.")) end,
        desc = "Copy current file path to clipboard",
      },
    },

    autocmds = {
      resession_auto_save = false,
    },
  },
}
