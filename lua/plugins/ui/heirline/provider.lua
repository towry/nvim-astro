local V = require("v")

-- https://github.dev/LazyVim/LazyVim/blob/706ec4b6b6be4265cbcfd326d3216f2a29952b55/lua/lazyvim/util/lualine.lua#L47

local M = {}

---@param component any
---@param text string
---@param hl_group? string
---@return string
function M.format(component, text, hl_group)
  text = text:gsub("%%", "%%%%")
  if not hl_group or hl_group == "" then return {
    provider = text,
  } end
  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    lualine_hl_group = {
      fg = "fg",
      bold = true,
    }
    component.hl_cache[hl_group] = lualine_hl_group
  end

  return {
    {
      hl = lualine_hl_group,
      provider = text,
    },
    {
      hl = {
        fg = "fg",
        bg = "bg",
      },
    },
  }
  -- return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

---@param opts? {relative: "cwd"|"root", modified_hl: string?, directory_hl: string?, filename_hl: string?, modified_sign: string?, readonly_icon: string?, length: number?}
function M.pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then return "" end

    local root = V.nvim_tab_root()
    local cwd = V.nvim_workspaces_root()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if opts.length == 0 then
      parts = parts
    elseif #parts > opts.length then
      parts = { parts[1], "…", table.concat({ unpack(parts, #parts - opts.length + 2, #parts) }, sep) }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = M.format(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = M.format(self, parts[#parts], opts.filename_hl)
    end

    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = M.format(self, dir .. sep, opts.directory_hl)
    end

    local readonly = ""
    if vim.bo.readonly then readonly = M.format(self, opts.readonly_icon, opts.modified_hl) end
    return dir .. parts[#parts] .. readonly
  end
end

return M
