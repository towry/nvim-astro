-- doc: https://docs.astronvim.com/recipes/status/
local component_loader = require("plugins.ui.heirline.component_")

return {
  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      -- add new user interface icon
      icons = {
        VimIcon = "",
        ScrollText = "",
        GitBranch = "",
        GitAdd = "",
        GitChange = "",
        GitDelete = "",
      },
      -- modify variables used by heirline but not defined in the setup call directly
      status = {
        -- define the separators between each section
        separators = {
          left = { " ", " " },
          right = { " ", " " }, -- separator for the right side of the statusline
          tab = { " ", " " },
        },
        attributes = {
          mode = { bold = true },
        },
        icon_highlights = {
          file_icon = {
            statusline = false,
          },
        },
      },
    },
  },
  {
    "rebelot/heirline.nvim",
    specs = {
      {
        "AstroNvim/astrocore",
        ---@param opts AstroCoreOpts
        opts = function(_, opts)
          opts.autocmds.heirline_colors = {
            {
              event = "User",
              pattern = "AstroColorScheme",
              desc = "Refresh heirline colors",
              callback = function()
                if package.loaded["heirline"] then require("astroui.status.heirline").refresh_colors() end
              end,
            },
          }
        end,
      },
    },
    opts = function(_, opts)
      local status = require("astroui.status")
      opts.statuscolumn = { -- statuscolumn
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        status.component.signcolumn(),
        status.component.numbercolumn(),
        status.component.foldcolumn(),
      }
      opts.tabline = nil
      opts.winbar = require("plugins.ui.heirline.winbar")
      opts.statusline = {
        -- default highlight for the entire statusline
        hl = { fg = "fg", bg = "bg" },
        -- each element following is a component in astroui.status module

        -- add the vim mode component
        status.component.mode({
          condition = status.condition.is_active,
        }),
        -- add a section for the currently opened file information
        status.component.file_info({
          condition = function() return vim.bo.buftype ~= "" end,
          unique_path = {},
          -- enable the file_icon and disable the highlighting based on filetype
          filename = { fallback = "Empty", modify = ":p:." },
          -- disable some of the info
          -- add padding
          padding = { right = 1 },
          -- define the section separator
          surround = { separator = "left", condition = false },
        }),
        -- add a component for the current diagnostics if it exists and use the right separator for the section
        status.component.diagnostics({ surround = { separator = "right" }, padding = { right = 1 } }),
        -- add a component for the current git diff if it exists and use no separator for the sections
        status.component.git_diff({
          padding = { left = 1 },
          surround = { separator = "none" },
        }),

        component_loader.overseer({
          padding = { left = 1 },
        }),
        -- fill the rest of the statusline
        -- the elements after this will appear in the middle of the statusline
        status.component.fill(),

        status.component.git_branch({
          git_branch = { padding = { left = 1 }, hl = { fg = "fg" } },
        }),

        {
          status.component.nav({
            -- add some padding for the percentage provider
            percentage = false,
            -- disable all other providers
            ruler = {},
            scrollbar = false,
            -- use no separator and define the background color
            surround = { separator = "right" },
          }),
        },

        { -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist({ -- component for each tab
            provider = status.provider.tabnr(),
            hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
          }),
          { -- close button for current tab
            provider = status.provider.close_button({ kind = "TabClose", padding = { left = 1, right = 1 } }),
            hl = status.hl.get_attributes("tab_close", true),
            on_click = {
              callback = function() require("astrocore.buffer").close_tab() end,
              name = "heirline_tabline_close_tab_callback",
            },
          },
        },
      }
    end,
  },
}
