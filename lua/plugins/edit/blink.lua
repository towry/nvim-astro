return {
  "Saghen/blink.cmp",
  optional = true,
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = vim.tbl_deep_extend("force", opts.completion and opts.completion.menu or {}, {
        border = "single",
      }),
    })
  end,
}
