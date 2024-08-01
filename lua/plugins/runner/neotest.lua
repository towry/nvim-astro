local prefix = "<localleader>t"
return {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            [prefix] = { desc = "󰗇 Tests" },
            [prefix .. "t"] = { function() require("neotest").run.run() end, desc = "Run test" },
            [prefix .. "d"] = { function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug test" },
            [prefix .. "f"] = {
              function() require("neotest").run.run(vim.fn.expand("%")) end,
              desc = "Run all tests in file",
            },
            [prefix .. "p"] = {
              function() require("neotest").run.run(vim.fn.getcwd()) end,
              desc = "Run all tests in project",
            },
            [prefix .. "<CR>"] = { function() require("neotest").summary.toggle() end, desc = "Test Summary" },
            [prefix .. "o"] = { function() require("neotest").output.open({ enter = true }) end, desc = "Output hover" },
            [prefix .. "O"] = { function() require("neotest").output_panel.toggle() end, desc = "Output window" },
            ["]T"] = { function() require("neotest").jump.next() end, desc = "Next test" },
            ["[T"] = { function() require("neotest").jump.prev() end, desc = "previous test" },
          },
        },
      },
    },
    {
      "folke/lazydev.nvim",
      optional = true,
      opts = function(_, opts)
        opts.library = opts.library or {}
        opts.library =
          require("astrocore").list_insert_unique(opts.library, { path = "neotest", words = { "neotest" } })
      end,
    },
  },
  specs = {},
  opts = {
    floating = {
      border = "single",
      max_height = 0.9,
      max_width = 0.9,
    },
    status = {
      enabled = true,
    },
    strategies = {
      integrated = {
        height = 40,
        width = 120,
      },
    },
  },
  config = function(_, opts)
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, vim.api.nvim_create_namespace("neotest"))
    require("neotest").setup(opts)
  end,
}
