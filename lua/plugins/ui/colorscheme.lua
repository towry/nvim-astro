vim.g.colorscheme = "kanagawa"
return {
  {
    "AstroNvim/astroui",
    opts = {
      colorscheme = vim.g.colorscheme,
    },
    dependencies = {
      {
        "rebelot/kanagawa.nvim",
        priority = 1000,
        event = "VeryLazy",
        cond = vim.g.colorscheme == "kanagawa",
        opts = {
          compile = true,
          undercurl = true, -- enable undercurls
          commentStyle = { italic = true },
          functionStyle = { bold = true },
          keywordStyle = { italic = true },
          statementStyle = { bold = true },
          typeStyle = { bold = true },
          variablebuiltinStyle = { italic = true },
          globalStatus = true,
          overrides = function(colors) -- add/modify highlights
            -- do not foget to run ':KanagawaCompile'
            return {
              -- flash
              FlashCursor = { fg = colors.theme.ui.fg, bg = colors.palette.waveBlue1 },
              WinSeparator = { fg = colors.palette.dragonPink, bg = "NONE" },
            }
          end,
          colors = {
            palette = {
              -- + green
              -- lotusWhite0 = '#B9C8B7',
              -- lotusWhite1 = '#C2CDBE',
              -- lotusWhite2 = '#CAD2C5',
              -- lotusWhite3 = '#E9EDE6',
              -- lotusWhite4 = '#F3F5F1',
              -- lotusWhite5 = '#ffffff',

              --- + solarized
              lotusWhite0 = "#ECE8D8",
              lotusWhite1 = "#F5DEAC",
              lotusWhite2 = "#F3EEDD",
              --- main bg
              lotusWhite3 = "#F6EED9",
              --- tabline etc
              lotusWhite4 = "#C5C0AF",
              lotusWhite5 = "#eee8d5",
            },
            theme = {
              all = {
                ui = {
                  bg_gutter = "none",
                },
              },
              lotus = {
                ui = {
                  bg_p1 = "#DCD7BA",
                  -- bg_m3 = '#586e75',
                },
              },
              dragon = {
                ui = {},
              },
            },
          },
          background = {
            -- dark = "wave",
            dark = "dragon",
            light = "lotus",
          },
        },
      },

      {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        event = "VeryLazy",
        cond = (vim.g.colorscheme):match(".*fox") ~= nil,
        opts = {
          options = {
            transparent = false,
            styles = {
              keywords = "italic",
              types = "italic,bold",
            },
          },
          palettes = {
            -- adapt to solarized light palette
            dayfox = {
              black = "#002b36",
              red = "#dc322f",
              green = "#859900",
              yellow = "#b58900",
              blue = "#268bd2",
              magenta = "#d33682",
              cyan = "#2aa198",
              white = "#eee8d5",
              orange = "#cb4b16",
              pink = "#6c71c4",

              comment = "#909995",

              bg0 = "#eee8d5", -- Dark bg (status line and float)
              bg1 = "#F6EED9", -- Default bg
              bg2 = "#ECE8D8", -- Lighter bg (colorcolm folds)
              -- bg3 = "#ece3cc", -- Lighter bg (cursor line)
              -- bg4 = "#909995", -- Conceal, border fg
              --
              fg0 = "#93a1a1", -- Lighter fg
              fg1 = "#53676d", -- Default fg
              -- fg2 = "#3a4d53", -- Darker fg (status line)
              -- fg3 = "#53676d", -- Darker fg (line numbers, fold colums)
              --
              sel0 = "#ece3cc", -- Popup bg, visual selection bg
              sel1 = "#c6c9c5", -- Popup sel bg, search bg
            },
          },
          groups = {
            dayfox = {
              CursorLine = {
                bg = "#ece3cc",
              },
            },
            all = {
              WidgetTextHighlight = {
                fg = "palette.blue",
                bg = "palette.bg0",
              },
              WinSeparator = {
                fg = "palette.blue",
              },
              FloatBorder = { link = "NormalFloat" },
              FzfLuaNormal = { link = "NormalFloat" },
              FzfLuaBorder = { link = "FloatBorder" },
            },
            -- https://github.com/EdenEast/nightfox.nvim/blob/main/usage.md#palette
            nordfox = {},
          },
        },
      },
      {
        "miikanissi/modus-themes.nvim",
        lazy = (vim.g.colorscheme):match("modus") == nil,
        opts = {
          style = "auto",
          ---@type 'default'|'tinted'|'deuteranopia'|'tritanopia'
          variant = "default",
          dim_inactive = false,
          styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
          },
          on_colors = function(colors) end,
          on_highlights = function(H, C)
            local dark = vim.o.background == "dark"
            if dark then H.IblIndent = {
              fg = "#333333",
              nocombine = true,
            } end
            H.FloatBorder = { link = "NormalFloat" }
          end,
        },
      },
    },
  },
  -- require("plugins.ui.catppucin"),
  -- require("plugins.ui.gruvbox"),
}
