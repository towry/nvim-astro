return {
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      local core = require("astrocore")
      opts.adapters = core.list_insert_unique(opts.adapters, {
        require("neotest-jest")({
          jestCommand = "pnpm run test --bail --ci",
          cwd = function(path) return V.nvim_root() end,
        }),
      })
    end,
    dependencies = {
      "haydenmeade/neotest-jest",
    },
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      opts.sources = require("astrocore").list_insert_unique(opts.sources, {
        require("none-ls.code_actions.eslint"),
        require("none-ls.diagnostics.eslint"),
      })
    end,
  },
}
