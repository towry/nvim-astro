local disabled = {
  "max397574/better-escape.nvim",
  "kevinhwang91/nvim-ufo",
  "vuki656/package-info.nvim",
}

return vim.tbl_map(function(plugin)
  return {
    plugin,
    enabled = false,
  }
end, disabled)
