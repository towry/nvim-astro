return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = {
    highlight_overrides = {
      all = function(colors)
        local overrides = {
          Headline = { style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "blue", "mauve", "teal", "green", "peach", "flamingo" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
      macchiato = function(colors)
        local overrides = {
          CurSearch = { bg = colors.peach },
          CursorLineNr = { fg = colors.blue, style = { "bold" } },
          FloatTitle = { fg = colors.mauve },
          Headline = { style = { "bold" } },
          IncSearch = { bg = colors.peach },
          MsgArea = { fg = colors.overlay1 },
          Search = { bg = colors.mauve, fg = colors.base },
          TreesitterContextBottom = { sp = colors.overlay1, style = { "underline" } },
          WinSeparator = { fg = colors.surface1, style = { "bold" } },

          -- Mini customizations
          MiniClueDescGroup = { fg = colors.pink },
          MiniClueDescSingle = { fg = colors.sapphire },
          MiniClueNextKey = { fg = colors.text, style = { "bold" } },

          MiniFilesCursorLine = { fg = colors.text, bg = "#171721", style = { "bold" } },
          MiniFilesFile = { fg = colors.overlay2 },
          MiniFilesTitleFocused = { fg = colors.peach, style = { "bold" } },

          MiniIndentscopeSymbol = { fg = colors.sapphire },

          MiniJump2dSpot = { fg = colors.peach },
          MiniJump2dSpotAhead = { fg = colors.mauve },
          MiniJump2dSpotUnique = { fg = colors.peach },

          MiniMapNormal = { fg = colors.overlay2, bg = colors.mantle },

          MiniPickBorderText = { fg = colors.blue },
          MiniPickMatchCurrent = { fg = colors.text, bg = "#171721", style = { "bold" } },
          MiniPickMatchRanges = { fg = colors.text, style = { "bold" } },
          MiniPickNormal = { fg = colors.overlay2 },
          MiniPickPrompt = { fg = colors.mauve },

          MiniStarterInactive = { fg = colors.overlay0, style = {} },
          MiniStarterItem = { fg = colors.overlay2, bg = nil },
          MiniStarterItemBullet = { fg = colors.surface2 },
          MiniStarterItemPrefix = { fg = colors.text },
          MiniStarterQuery = { fg = colors.text, style = { "bold" } },
          MiniStarterSection = { fg = colors.mauve, style = { "bold" } },

          MiniStatuslineDirectory = { fg = colors.overlay1, bg = colors.surface0 },
          MiniStatuslineFilename = { fg = colors.text, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineFilenameModified = { fg = colors.blue, bg = colors.surface0, style = { "bold" } },
          MiniStatuslineInactive = { fg = colors.overlay1, bg = colors.surface0 },

          MiniSurround = { fg = nil, bg = colors.yellow },

          MiniTablineCurrent = { fg = colors.blue, bg = colors.base, style = { "bold" } },
          MiniTablineFill = { bg = colors.mantle },
          MiniTablineHidden = { fg = colors.overlay1, bg = colors.surface0 },
          MiniTablineModifiedCurrent = { fg = colors.base, bg = colors.blue, style = { "bold" } },
          MiniTablineModifiedHidden = { fg = colors.base, bg = colors.subtext0 },
          MiniTablineModifiedVisible = { fg = colors.base, bg = colors.subtext0, style = { "bold" } },
          MiniTablineTabpagesection = { fg = colors.base, bg = colors.mauve, style = { "bold" } },
          MiniTablineVisible = { fg = colors.overlay1, bg = colors.surface0, style = { "bold" } },
        }
        for _, hl in ipairs({ "Headline", "rainbow" }) do
          for i, c in ipairs({ "blue", "pink", "lavender", "green", "peach", "flamingo" }) do
            overrides[hl .. i] = { fg = colors[c], style = { "bold" } }
          end
        end
        return overrides
      end,
    },
    color_overrides = {
      --- ayu
      macchiato = {
        rosewater = "#F5B8AB",
        flamingo = "#F29D9D",
        pink = "#AD6FF7",
        mauve = "#FF8F40",
        red = "#E66767",
        maroon = "#EB788B",
        peach = "#FAB770",
        yellow = "#FACA64",
        green = "#70CF67",
        teal = "#4CD4BD",
        sky = "#61BDFF",
        sapphire = "#4BA8FA",
        blue = "#00BFFF",
        lavender = "#00BBCC",
        text = "#C1C9E6",
        subtext1 = "#A3AAC2",
        subtext0 = "#8E94AB",
        overlay2 = "#7D8296",
        overlay1 = "#676B80",
        overlay0 = "#464957",
        surface2 = "#3A3D4A",
        surface1 = "#2F313D",
        surface0 = "#1D1E29",
        base = "#0b0b12",
        mantle = "#11111a",
        crust = "#191926",
      },
    },
  },
}
