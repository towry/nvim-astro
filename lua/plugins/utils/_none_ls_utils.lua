local M = {}

function M.get_available_formatters(ft)
  local sources = require("null-ls.sources")
  local available = sources.get_available(ft, "NULL_LS_FORMATTING")
  return available
end

function M.has_formatter(ft, available_formatters)
  local available = available_formatters or M.get_available_formatters(ft)
  return #available > 0
end

function M.is_null_ls_formatter_avalable(filetype)
  if not package.loaded["null-ls"] then return false end

  local formatters = M.get_available_formatters(filetype)
  if M.has_formatter(filetype, formatters) then return true end
end

return M
