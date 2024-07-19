return {
  "mrcjkb/rustaceanvim",
  optional = true,
  opts = function(_, opts)
    opts.server.default_settings = opts.server.default_settings or {}
    opts.server.default_settings["rust-analyzer"] = opts.server.default_settings["rust-analyzer"] or {}
    opts.server.default_settings["rust-analyzer"].files = {
      excludeDirs = {
        ".direnv",
        "target",
        "js",
        "node_modules",
        "assets",
        "ci",
        "data",
        "docs",
        "store-metadata",
        ".gitlab",
        ".vscode",
        ".git",
        ".repro",
      },
    }
  end,
}
