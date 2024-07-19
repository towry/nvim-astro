local M = {}

M.shortly_prefix = "<leader>z+"

---@param fn function
M.open = function(fn)
  local buf = vim.api.nvim_get_current_buf()
  local set = function(key, cmd, opts_)
    local mode = "n"
    local keys = M.shortly_prefix .. key
    local command = function()
      if type(cmd) == "string" then
        vim.cmd(cmd)
      elseif type(cmd) == "function" then
        cmd()
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) and V.nvim_has_keymap("n", keys) then
          pcall(
            function()
              vim.keymap.del("n", keys, {
                buffer = buf,
              })
            end
          )
        end
      end)
    end
    local opts = vim.tbl_deep_extend("force", {
      remap = false,
      nowait = true,
      buffer = buf,
    }, opts_)
    vim.keymap.set(mode, keys, command, opts)
  end
  --- actually this is not neccessary
  local unset = function() end

  fn(set, unset)

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
