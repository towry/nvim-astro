local M = {}

M.shortly_prefix = "<leader>z+"

---@param fn function
M.open = function(fn)
  local buf = vim.api.nvim_get_current_buf()

  local set = function(...)
    local args = { ... }
    local mode = args[1]
    local key = args[2]
    local command = args[3]
    local opts = args[4] or {}
    if type(mode == "string") then mode = { mode } end
    local keys = M.shortly_prefix .. key
    vim.keymap.set(
      mode,
      keys,
      command,
      vim.tbl_deep_extend("force", opts, {
        buffer = buf,
      })
    )
  end
  local is_unset = false
  --- actually this is not neccessary
  local unset = function()
    if is_unset then return end
    is_unset = true
    if not vim.api.nvim_buf_is_loaded(buf) then return end
  end

  fn(set, unset, buf)

  vim.schedule(function() M.show_on_keys(M.shortly_prefix) end)
end

M.show_on_keys = function(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "mit", false)
end

--- @param helps {mode:string,lhs:string,desc:string}[]
M.show_buf_local_help = function(helps)
  if not helps or #helps == 0 then return end
  M.shortly_open(function(set)
    for _, help in ipairs(helps) do
      set(help.mode, help.lhs, function() vim.notify(help.desc, vim.log.levels.INFO) end, { desc = help.desc })
    end
  end)
end

M.extend_clues = function(clues)
  -- vim.print(clues)
  -- vim.b.miniclue_config = vim.b.miniclue_config or {}
  -- vim.b.miniclue_config['clues'] = vim.b.miniclue_config['clues'] or {}
  -- vim.list_extend(vim.b.miniclue_config['clues'], clues)
end

return M
