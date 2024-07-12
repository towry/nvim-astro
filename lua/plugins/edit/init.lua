return {
  { import = "plugins.edit.treesitter" },
  { import = "plugins.edit.surround" },
  { import = "plugins.edit.flash" },
  { import = "plugins.edit.text-case" },

  {
    --- Readline keybindings,
    --- C-e, C-f, etc.
    "tpope/vim-rsi",
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },
  },

  { import = "plugins.edit.mappings" },
  { import = "plugins.edit.boole" },
}
