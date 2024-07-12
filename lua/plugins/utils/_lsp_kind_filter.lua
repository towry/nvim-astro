local M = {
  by_filetype = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
}

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if M.by_filetype == false then return end
  if M.by_filetype[ft] == false then return end
  if type(M.by_filetype[ft]) == "table" then return M.by_filetype[ft] end
  ---@diagnostic disable-next-line: return-type-mismatch
  return type(M.by_filetype) == "table" and type(M.by_filetype.default) == "table" and M.by_filetype.default or nil
end

return M
