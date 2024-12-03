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
}
