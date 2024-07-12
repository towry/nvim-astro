return {
  "AstroNvim/astroui",
  dependencies = {
    {
      "EdenEast/nightfox.nvim",
      priority = 1000,
      event = "VeryLazy",
      opts = {
        options = {
          transparent = false,
          styles = {
            keywords = "italic",
            types = "italic,bold",
          },
        },
        groups = {
          all = {
            WidgetTextHighlight = {
              fg = "palette.blue",
              bg = "palette.bg0",
            },
            FloatBorder = { link = "NormalFloat" },
            NormalA = { fg = "palette.bg0", bg = "palette.blue" },
            InsertA = { fg = "palette.bg0", bg = "palette.green" },
            VisualA = { fg = "palette.bg0", bg = "palette.magenta" },
            CommandA = { fg = "palette.bg0", bg = "palette.yellow" },
            TermA = { fg = "palette.bg0", bg = "palette.orange" },
            MotionA = { fg = "palette.bg0", bg = "palette.red" },
            TabLineSel = { fg = "palette.blue", bg = "palette.bg3" },
            TreesitterContext = { bg = "palette.bg2" },
            TreesitterContextLineNumber = { link = "TreesitterContext" },
            FzfLuaNormal = { link = "NormalFloat" },
            FzfLuaBorder = { link = "FloatBorder" },
          },
          -- https://github.com/EdenEast/nightfox.nvim/blob/main/usage.md#palette
          nordfox = {},
        },
      },
    },
  },
}
