local status = require("astroui.status")
local component_loader = require("plugins.ui.heirline.component_")

local Codeium = status.component.builder({
  condition = function()
    if vim.bo.buftype ~= "" then return false end
    return vim.g.loaded_codeium == 1 and vim.fn.exists("*codeium#GetStatusString") == 1
  end,
  {
    provider = function()
      local str = vim.api.nvim_call_function("codeium#GetStatusString", {})
      str = vim.trim(str)
      if str == "" or str == "0" then str = "ON" end
      if str == "" and vim.g.codeium_enabled == 1 then
        str = "ON"
      elseif vim.g.codeium_enabled == 0 then
        str = "OFF"
      end
      return "[AI:" .. str .. "]"
    end,
  },
  padding = { right = 1 },
})

return { -- bufferline
  { -- automatic sidebar padding
    condition = function(self)
      self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
      self.winwidth = vim.api.nvim_win_get_width(self.winid)
      return self.winwidth ~= vim.o.columns -- only apply to sidebars
        and not require("astrocore.buffer").is_valid(vim.api.nvim_win_get_buf(self.winid)) -- if buffer is not in tabline
    end,
    provider = function(self) return (" "):rep(self.winwidth + 1) end,
    hl = { bg = "tabline_bg" },
  },

  {
    -- define a simple component where the provider is just a folder icon
    status.component.builder({
      -- astronvim.get_icon gets the user interface icon for a closed folder with a space after it
      { provider = " " .. require("astroui").get_icon("FolderClosed") },
      padding = { right = 1 },
      hl = { bg = "folder_icon_bg", fg = "bg" },
    }),
    -- add a file information component and only show the current working directory name
    status.component.file_info({
      -- we only want filename to be used and we can change the fname
      -- function to get the current working directory name
      filename = {
        fname = function(nr) return vim.fn.getcwd(nr) end,
        padding = { left = 1, right = 1 },
      },
      -- disable all other elements of the file_info component
      filetype = false,
      file_icon = false,
      file_modified = false,
      file_read_only = false,
      -- use no separator for this part but define a background color
      surround = {
        separator = "none",
        color = "file_info_bg",
        condition = false,
      },
    }),
  },

  -- add a component for the current git branch if it exists and use no separator for the sections
  status.component.git_branch({
    git_branch = { padding = { left = 1 } },
    surround = { separator = "none" },
  }),

  -- add a component for the current git diff if it exists and use no separator for the sections
  status.component.git_diff({
    padding = { left = 1 },
    surround = { separator = "none" },
  }),

  component_loader.overseer({
    padding = { left = 1 },
  }),

  ----------------------------------
  status.component.fill({ hl = { bg = "tabline_bg" } }), -- fill the rest of the tabline with background color
  Codeium,
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
