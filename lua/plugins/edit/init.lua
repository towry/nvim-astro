return {
  { import = "plugins.edit.treesitter" },
  { import = "plugins.edit.surround" },
  { import = "plugins.edit.flash" },
  { import = "plugins.edit.text-case" },
  -- { import = "plugins.edit.blink" },
  { "HawkinsT/pathfinder.nvim", event = "User AstroFile" },
  {
    "luiscassih/AniKakoune",
    event = "VeryLazy",
    enabled = false,
    config = function()
      require("AniMotion").setup({
        mode = "animotion",
        clear_keys = { "<C-c>" },
        color = "Visual",
      })
    end,
  },

  {
    --- Readline keybindings,
    --- C-e, C-f, etc.
    "tpope/vim-rsi",
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
    init = function() vim.g.rsi_no_meta = true end,
  },

  { import = "plugins.edit.mappings" },
  { import = "plugins.edit.boole" },
  {
    "norcalli/nvim-colorizer.lua",
    optional = true,
    opts = {
      exclusions = {
        "neo-tree",
        "fzf-lua",
      },
    },
  },
}
