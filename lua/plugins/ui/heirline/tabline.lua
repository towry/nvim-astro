local status = require("astroui.status")

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
  status.heirline.make_buflist(status.component.tabline_file_info()), -- component for each buffer tab
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
