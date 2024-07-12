local M = {}

function M.symbols_filter(entry, ctx)
  if ctx.symbols_filter == nil then
    ctx.symbols_filter = require("plugins.utils._lsp_kind_filter").get_kind_filter(ctx.bufnr) or false
  end
  if ctx.symbols_filter == false then return true end
  return vim.tbl_contains(ctx.symbols_filter, entry.kind)
end

return M
