-- Customize Treesitter

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
    require("v").astro_extend_core {
      autocmds = {
        setup_fold_expr_treesitter = {
          {
            event = "User",
            pattern = "AstroFile",
            desc = "Use nvim-treesitter as folderexpr",
            command = "setlocal foldexpr=nvim_treesitter#foldexpr() | setlocal foldmethod=expr",
          },
        },
      },
    },
  },
}
