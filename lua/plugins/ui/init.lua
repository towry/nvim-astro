return {
  { import = "plugins.ui.colorscheme" },
  { import = "plugins.ui.fidget" },
  { import = "plugins.ui.heirline.heirline" },
  {
    "stevearc/dressing.nvim",
    optional = true,
    opts = {
      input = {
        border = "single",
        relative = "editor",
      },
    },
  },
}
