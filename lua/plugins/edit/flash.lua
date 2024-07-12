return {
  "folke/flash.nvim",
  lazy = true,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          x = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          o = {
            ["r"] = {
              function() require("flash").remote() end,
              desc = "Remote Flash",
            },
            ["R"] = {
              function() require("flash").treesitter_search() end,
              desc = "Treesitter Search",
            },
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["S"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
          n = {
            ["s"] = {
              function() require("flash").jump() end,
              desc = "Flash",
            },
            ["gs"] = {
              function() require("flash").treesitter() end,
              desc = "Flash Treesitter",
            },
          },
        },
      },
    },
  },
  opts = {},
}
