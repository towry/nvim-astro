local V = require("v")

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      -- add more arguments for adding more treesitter parsers
    },
  },
  dependencies = {
    V.astro_extend_core({
      options = {
        opt = {
          foldmethod = "expr",
          foldexpr = "v:lua.vim.treesitter.foldexpr()",
          foldenable = false,
        },
      },
    }),
  },
}
