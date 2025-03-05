local V = require("v")

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "elixir",
      -- add more arguments for adding more treesitter parsers
    },
  },
}
