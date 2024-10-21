require("lazy").setup({
  {
    "AstroNvim/AstroNvim",
    name = "AstroNvim",
    -- dir = vim.fn.stdpath("config") .. "/vendor/astronvim",
    version = "^4", -- Remove version tracking to elect for nighly AstroNvim
    import = "vendor.astronvim-plugins",
    -- import = "astronvim.plugins",
    opts = { -- AstroNvim options must be set here with the `import` key
      mapleader = " ", -- This ensures the leader key must be configured before Lazy is set up
      maplocalleader = ",", -- This ensures the localleader key must be configured before Lazy is set up
      icons_enabled = true, -- Set to false to disable icons (if no Nerd Font is available)
      update_notifications = true, -- Enable/disable notification about running `:Lazy update` twice to update pinned plugins
    },
  },
  { import = "vendor.community" },
  { import = "plugins" },
  { import = "plugins.core.vscode" },
} --[[@as LazySpec]], {
  -- Configure any other `lazy.nvim` configuration options here
  install = { colorscheme = { "default" } },
  defaults = {
    lazy = not vim.g.vscode,
  },
  dev = { patterns = {}, path = "~/workspace/git-repos" },

  ui = { backdrop = 40 },
  performance = {
    rtp = {
      -- disable some rtp plugins, add more to your liking
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
      },
    },
  },
} --[[@as LazyConfig]])
