local status = require("astroui.status")

return {
  init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
  fallthrough = false,

  ---
  --- Inactive winbar
  {
    status.component.file_info({
      file_icon = { padding = { left = 1, right = 0 } },
      filename = { modify = ":.", fallback = "Empty", padding = { left = 1 } },
      filetype = false,
      file_read_only = {},
      file_modified = {},
      -- add padding
      padding = { right = 1 },
      surround = {
        separator = "none",
      },
    }),
  },
}
