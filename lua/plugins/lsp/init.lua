if vim.g.vscode then return {} end

return {
  { import = "plugins.lsp.astrolsp" },
  { import = "plugins.lsp.mason" },
  { import = "plugins.lsp.conform" },
  { import = "plugins.lsp.nvim-lint" },
}
