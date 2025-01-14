return {
  cmd = { "elixir-ls" },
  filetypes = { "elixir" },
  root_markers = { "mix.lock" },
  settings = {
    elixirLS = {
      --- https://github.com/elixir-lsp/elixir-ls?tab=readme-ov-file#dialyzer-integration
      dialyzerEnabled = true,
      fetchDeps = true,
    },
  },
}
