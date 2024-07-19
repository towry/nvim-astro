return {
  "sainnhe/gruvbox-material",
  cond = vim.g.colorscheme == "gruvbox-material",
  config = function()
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_background = "medium"
    vim.g.gruvbox_material_better_performance = 0
  end,
}
