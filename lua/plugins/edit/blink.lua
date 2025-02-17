return {
  "Saghen/blink.cmp",
  version = false,
  optional = true,
  build = "nix run --accept-flake-config .#build-plugin",
  opts = function(_, opts)
    opts.completion = vim.tbl_deep_extend("force", opts.completion or {}, {
      menu = vim.tbl_deep_extend("force", opts.completion and opts.completion.menu or {}, {
        border = "single",
      }),
    })
  end,
}
