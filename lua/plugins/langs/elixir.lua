return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "elixir" })
      end
    end,
  },
  {
    "AstroNvim/astrolsp",
    optional = true,
    opts = {
      servers = {
        "elixirls",
      },
      config = {
        elixirls = {
          cmd = { "elixir-ls" },
          -- init_options = {
          -- },
          settings = {
            elixirLS = {
              --- https://github.com/elixir-lsp/elixir-ls?tab=readme-ov-file#dialyzer-integration
              dialyzerEnabled = true,
              fetchDeps = true,
            },
          },
        },
      },
    },
  },
}
