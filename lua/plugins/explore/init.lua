if vim.g.vscode then return {} end

return {
  { import = "plugins.explore.oil-nvim" },
  { import = "plugins.explore.harpoon" },
  { import = "plugins.explore.neo-tree" },
}
