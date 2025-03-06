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
          left = { "", "█" },
          right = { "", "" }, -- separator for the right side of the statusline
          tab = { "", "" },
        },
        -- add new colors that can be used by heirline
        colors = function(hl)
          local get_hlgroup = require("astroui").get_hlgroup
          -- use helper function to get highlight group properties
          local comment_fg = get_hlgroup("Comment").fg
          hl.git_branch_fg = comment_fg
          hl.git_added = comment_fg
          hl.git_changed = comment_fg
          hl.git_removed = comment_fg
          hl.blank_bg = get_hlgroup("Folded").fg
          hl.file_info_bg = get_hlgroup("Visual").bg
          hl.nav_icon_bg = get_hlgroup("String").fg
          hl.nav_fg = hl.nav_icon_bg
          hl.folder_icon_bg = get_hlgroup("Error").fg
          return hl
        end,
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
          -- enable mode text with padding as well as an icon before it
          mode_text = {
            icon = { kind = "VimIcon", padding = { right = 1, left = 1 } },
          },
          -- surround the component with a separators
          surround = {
            -- it's a left element, so use the left separator
            separator = "left",
            -- set the color of the surrounding based on the current mode using astronvim.utils.status module
            color = function() return { main = status.hl.mode_bg(), right = "blank_bg" } end,
          },
        }),
        -- we want an empty space here so we can use the component builder to make a new section with just an empty string
        status.component.builder({
          { provider = "" },
          -- define the surrounding separator and colors to be used inside of the component
          -- and the color to the right of the separated out section
          surround = {
            separator = "left",
            color = { main = "blank_bg", right = "file_info_bg" },
          },
        }),
        -- add a section for the currently opened file information
        status.component.file_info({
          condition = function() return vim.bo.buftype ~= "" end,
          unique_path = {},
          -- enable the file_icon and disable the highlighting based on filetype
          filename = { fallback = "Empty", modify = ":p:." },
          -- disable some of the info
          filetype = false,
          file_read_only = false,
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

        -- add a component to display LSP clients, disable showing LSP progress, and use the right separator
        status.component.lsp({
          condition = status.condition.is_active,
          lsp_progress = false,
          surround = { separator = "right" },
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

        {                                                                       -- tab list
          condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
          status.heirline.make_tablist({                                        -- component for each tab
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
