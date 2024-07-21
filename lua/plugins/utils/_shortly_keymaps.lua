local M = {}

M.shortly_prefix = "<leader>z+"

M.maps = {}

M.get_maps = function() return vim.tbl_deep_extend("force", {}, M.maps) end

---@param fn function(key:string, cmd:string|func, opts:table)
M.open = function(fn)
  local buf = vim.api.nvim_get_current_buf()
  M.maps = {}
  local set = function(key, cmd, opts_)
    local opts = vim.tbl_deep_extend("force", {
      remap = false,
      nowait = true,
      buffer = buf,
    }, opts_)
    M.maps[#M.maps + 1] = {
      key,
      cmd,
      desc = opts.desc,
      buffer = opts.buffer,
      nowait = true,
      noremap = true,
      mode = "n",
    }
  end
  --- actually this is not neccessary
  local unset = function() M.maps = {} end

  fn(set, unset)

  require("which-key").add({
    "<leader>z+",
    group = "Temporary once purpuse keymaps",
    expand = function() return M.get_maps() end,
  })

  vim.schedule(function() M.show_on_keys(M.shortly_prefix) end)
end

M.show_on_keys = function(keys)
  vim.defer_fn(
    function() vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), "mit", false) end,
    1
  )
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
