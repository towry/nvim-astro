--- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua
------------------
---===
local cache = {} ---@type table<(fun()), table<string, any>>
---@generic T: fun()
---@param fn T
---@return T
local function util_memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then cache[fn][key] = fn(...) end
    return cache[fn][key]
  end
end

local function nvim_empty_argc() return vim.fn.argc(-1) == 0 end

--- @class CommandArgs
--- @field args string
--- @field fargs table
--- @field bang boolean,

---Create an nvim command
---@param name string
---@param rhs string | fun(args: CommandArgs)
---@param opts table?
local function nvim_command(name, rhs, opts)
  opts = opts or {}
  vim.api.nvim_create_user_command(name, rhs, opts)
end

local function nvim_smart_split()
  local cols = vim.o.columns
  local lns = vim.o.lines

  local cmd = "split"
  local dir = "botright"
  if math.floor(cols / lns) > 1.3 then cmd = "vsplit" end

  return {
    cmd = cmd,
    modifier = dir,
  }
end

local function nvim_has_keymap(key, mode) return vim.fn.hasmapto(key, mode) == 1 end

local CREATE_UNDO = vim.api.nvim_replace_termcodes("<c-G>u", true, true, true)
local function nvim_create_undo()
  if vim.api.nvim_get_mode().mode == "i" then vim.api.nvim_feedkeys(CREATE_UNDO, "n", false) end
end

local _cwd = vim.fn.getcwd(-1, -1)
--- Cwd for workspaces root, not the per project workspace root.
local function nvim_workspaces_root_()
  --- NOTE: need better implementation.
  return _cwd
end

--- Return the cwd related to tab.
local function nvim_tab_root() return vim.fn.getcwd(-1, 0) end
--- Return the lsp or pattern root
local function nvim_root()
  local fallback = nvim_workspaces_root_()
  if not package.loaded["astrocore"] then return fallback end
  local ret = require("astrocore.rooter").detect()
  if not ret or #ret <= 0 then return fallback end
  local paths = ret[1].paths or {}
  if #paths <= 0 then return fallback end
  return paths[1]
end

---@param bufnr number
---@param winid number
local function nvim_smart_close(bufnr, winid)
  bufnr = bufnr or 0
  winid = winid or 0

  if vim.wo[winid].previewwindow then
    vim.cmd.pclose()
    return
  elseif vim.api.nvim_win_get_config(0).relative ~= "" then
    vim.cmd.fclose()
    return
    -- for now, do not use bd to delete the buffer to close,
    -- because some buffer owned by overseer's task, if we delete it,
    -- we may not be able to see it again.
  else
    vim.cmd("silent! hide")
  end
end

---@private
local _autocmd_keys = { "event", "buffer", "pattern", "desc", "command", "group", "once", "nested" }
--- Validate the keys passed to as.augroup are valid
---@param name string
---@param command Autocommand
local function validate_autocmd(name, command)
  local incorrect = vim.iter(command):map(function(key, _)
    if not vim.tbl_contains(_autocmd_keys, key) then return key end
  end)
  if #incorrect > 0 then
    vim.schedule(function()
      local msg = ("Incorrect keys: %s"):format(table.concat(incorrect, ", "))
      vim.notify(msg, vim.log.levels.ERROR, { title = ("Autocmd: %s"):format(name) })
    end)
  end
end

---@class AutocmdArgs
---@field id number autocmd ID
---@field event string
---@field group string?
---@field buf number
---@field file string
---@field match string | number
---@field data any

---@class Autocommand
---@field desc string?
---@field event  (string | string[])? list of autocommand events
---@field pattern (string | string[])? list of autocommand patterns
---@field command string | fun(args: AutocmdArgs): boolean?
---@field nested  boolean?
---@field once    boolean?
---@field buffer  number?

---Create an autocommand
---returns the group ID so that it can be cleared or manipulated.
---@param name string The name of the autocommand group
---@param ... Autocommand A list of autocommands to create
---@return number
local function nvim_augroup(name, ...)
  local commands = { ... }
  assert(name ~= "User", "The name of an augroup CANNOT be User")
  assert(#commands > 0, string.format("You must specify at least one autocommand for %s", name))
  local id = vim.api.nvim_create_augroup(name, { clear = true })
  for _, autocmd in ipairs(commands) do
    validate_autocmd(name, autocmd)
    local is_callback = type(autocmd.command) == "function"
    vim.api.nvim_create_autocmd(autocmd.event, {
      group = name,
      pattern = autocmd.pattern,
      desc = autocmd.desc,
      callback = is_callback and autocmd.command or nil,
      ---@diagnostic disable-next-line: assign-type-mismatch
      command = not is_callback and autocmd.command or nil,
      once = autocmd.once,
      nested = autocmd.nested,
      buffer = autocmd.buffer,
    })
  end
  return id
end

local git_is_perform_merge_in_nvim = function()
  if vim.g.nvim_is_start_as_merge_tool == 1 then return true end
  local tail = vim.fn.expand("%:t")
  local args = { "MERGE_MSG", "COMMIT_EDITMSG" }
  if vim.tbl_contains(args, tail) then
    vim.g.nvim_is_start_as_merge_tool = 1
    return true
  end
  return false
end
local git_start_nvim = function()
  if nvim_empty_argc() then return false end
  local argv = vim.v.argv
  local args = { { "-d" }, { "-c", "DiffConflicts" } }
  -- each table in args is pairs of args that may exists in argv to determin the
  -- return value is true or false.
  for _, arg in ipairs(args) do
    local is_match = true
    for _, v in ipairs(arg) do
      if not vim.tbl_contains(argv, v) then is_match = false end
    end
    if is_match then return true end
  end

  return git_is_perform_merge_in_nvim()
end

local function register_global(name, value) _G[name] = value end

local function buffer_is_empty(bufnr)
  bufnr = bufnr or 0
  if not vim.api.nvim_buf_is_valid(bufnr) then return true end
  local buftype = vim.api.nvim_get_option_value("buftype", {
    buf = bufnr,
  })
  if buftype == "nofile" then return true end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  return filename == ""
end

--- Get the window in current tab that showing this buffer.
--- @param bufnr number
local function buffer_get_tabwin(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then return end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_buf(win) == bufnr then return win end
  end
end

--- Set multiple options on a buffer
--- @param buf number
--- @param opts {[string]: any}
local function buffer_set_options(buf, opts)
  for k, v in pairs(opts) do
    vim.api.nvim_set_option_value(k, v, {
      buf = buf,
    })
  end
end
--- Focus the buffer or set it as current buffer.
--- @param bufnr number
--- @param tabonly? boolean Only check windows in current tab.
local function buffer_focus_or_current(bufnr, tabonly)
  if tabonly == nil then tabonly = true end

  if not tabonly then
    local buf_win_id = unpack(vim.fn.win_findbuf(bufnr))
    if buf_win_id ~= nil then
      vim.api.nvim_set_current_win(buf_win_id)
      return
    end
  else
    local w = buffer_get_tabwin(bufnr)
    if w then vim.api.nvim_set_current_win(w) end
  end

  vim.api.nvim_set_current_buf(bufnr)
end

--- Retrieve the focusable alternative buffer.
--- @return number|nil
local function buffer_alt_focusable_bufnr()
  local altnr = vim.fn.bufnr("#")
  if not altnr or altnr < 1 then return end
  -- if the buffer keep delete by other plugin wrongly, this will be a problem.
  -- plugin must be fixed.
  if not vim.api.nvim_buf_is_loaded(altnr) then
    -- buf is deleted but not wipped out
    return
  end
  if not altnr then return end
  return altnr
end

---Get current tab's win count
---@return number
local function tab_win_count()
  local tab_wins = vim.api.nvim_tabpage_list_wins(0)
  local count = 0
  for _, win in ipairs(tab_wins) do
    if vim.api.nvim_win_get_config(win).relative == "" then count = count + 1 end
  end
  return count
end

local function keymap_cmd(cmd) return string.format("<cmd>%s<cr>", cmd) end
---@return function
local function keymap_buf_set(bufnr, opts)
  opts = opts or {}
  opts.buffer = bufnr
  return function(mode, lhs, rhs, opts_local)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", opts_local or {}, opts))
  end
end
local function keymap_super(c)
  if not vim.env.TMUX or not vim.env.MIMIC_SUPER then
    if c == ";" then return [[<C-;>]] end
    return string.format("<D-%s>", c)
  end
  return string.format("<Char-0xAE>%s", c)
end

--- Get visual selected word
local function nvim_visual_text()
  if vim.fn.exists("*getregion()") == 1 then
    local list = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
    return #list > 0 and list[1] or ""
  end
  return ""
end

local function nvim_get_range()
  if vim.fn.mode() == "n" then
    local pos = vim.api.nvim_win_get_cursor(0)
    return {
      pos[1],
      pos[1],
    }
  end

  return {
    vim.fn.getpos("v")[2],
    vim.fn.getpos(".")[2],
  }
end

local util_toggle_dark = function(mode)
  if vim.o.background == mode then return end

  if vim.o.background == "light" then
    vim.o.background = "dark"
    vim.notify("Light out 🌛 ", vim.log.levels.INFO)
  else
    vim.o.background = "light"
    vim.notify("Light on 🌞 ", vim.log.levels.INFO)
  end
end

--- Find python exec in vim.env.PATH if pyenv shims exists
local util_locate_python_exec_path = function()
  local python_in_pyenv_shims = vim.env.PYENV_ROOT .. "/shims/python"
  if vim.fn.executable(python_in_pyenv_shims) == 1 then return python_in_pyenv_shims end
end

--- @param option_to_toggle string hidden=true or --no-hidden
--- @param insert_at_end? boolean
local util_toggle_cmd_option = function(cmd_string_or_table, option_to_toggle, insert_at_end)
  local cmd_is_table = true
  if type(cmd_string_or_table) == "string" then
    cmd_is_table = false
    -- split string to table by white space
    cmd_string_or_table = vim.split(cmd_string_or_table, "%s+")
  end

  -- if option_to_toggle in table, remove it, or add to it.
  local is_in_table = false
  for i, v in ipairs(cmd_string_or_table) do
    if v == option_to_toggle then
      table.remove(cmd_string_or_table, i)
      is_in_table = true
      break
    end
  end
  if not is_in_table then
    if insert_at_end then
      table.insert(cmd_string_or_table, option_to_toggle)
    else
      -- insert at start
      table.insert(cmd_string_or_table, 2, option_to_toggle)
    end
  end

  if cmd_is_table then
    return cmd_string_or_table
  else
    return table.concat(cmd_string_or_table, " ")
  end
end

--- Returns a table that when accessed by key, match with pattern from
--- key in the tbl
--- @deprecated not working
--- @param tbl table
--- @return table
local util_mk_pattern_table = function(tbl)
  return setmetatable({}, {
    __index = function(_, key)
      if not key then return end
      for k, v in pairs(tbl) do
        if k:match(key) then return v end
      end
    end,
  })
end
local util_falsy = function(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == "boolean" then return not item end
  if item_type == "string" then return item == "" end
  if item_type == "number" then return item <= 0 end
  if item_type == "table" then return vim.tbl_isempty(item) end
  return item ~= nil
end

local plugin_has_ai_suggestions = function()
  return (vim.b._copilot and vim.b._copilot.suggestions ~= nil)
      or (vim.b._codeium_completions and vim.b._codeium_completions.items ~= nil)
end
local plugin_has_ai_suggestion_text = function()
  if vim.b._copilot and vim.b._copilot.suggestions ~= nil then
    local suggestion = vim.b._copilot.suggestions[1]
    if suggestion ~= nil then suggestion = suggestion.displayText end
    return suggestion ~= nil
  end

  if vim.b._codeium_completions and vim.b._codeium_completions.items then
    local index = vim.b._codeium_completions.index or 0
    local suggestion = vim.b._codeium_completions.items[index + 1] or {}
    local parts = suggestion.completionParts or {}
    if type(parts) ~= "table" then return false end
    return #parts >= 1
  end

  return false
end
---
local is_windows = vim.uv.os_uname().version:match("Windows")
local path_separator = is_windows and "\\" or "/"
---@param path string
local path_remove_last_separator = function(path)
  if not path then return "" end
  if path:sub(#path) == path_separator then return path:sub(1, #path - 1) end
  return path
end

---@param opts AstroCoreOpts | fun(plugin: LazyPlugin, opts: AstroCoreOpts):AstroCoreOpts
local astro_extend_core = function(opts)
  return {
    "AstroNvim/astrocore",
    opts = opts or {},
  }
end

local path_is_fs_root = function(path)
  if is_windows then
    return path:match("^%a:$")
  else
    return path == "/"
  end
end

-- Iterate the path until we find the rootdir.
local path_iterate_parents = function(path)
  local PlenaryPath = require("plenary.path")
  local function it(_, v)
    if v and not path_is_fs_root(v) then
      v = PlenaryPath:new(v).parent()
    else
      return
    end
    if v and vim.uv.fs_realpath(v) then
      return v, path
    else
      return
    end
  end

  return it, path, path
end

local function path_search_ancestors_callback(startpath, func)
  vim.validate({ func = { func, "f" } })
  if func(startpath) then return startpath end
  local guard = 100
  for path in path_iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then return end

    if func(path) then return path end
  end
end

local function path_is_homedir(path)
  local homeDir = vim.uv.os_homedir() or ""
  homeDir = homeDir:gsub("[\\/]+$", "") -- Remove trailing path separators
  path = path:gsub("[\\/]+$", "")       -- Remove trailing path separators
  return path == homeDir
end

local lsp_get_autocmd_arg_client = function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  return client
end

do
  vim.g.very_lazy_loaded = 0
  nvim_augroup("SetupVeryLazyVar", {
    event = "User",
    once = true,
    pattern = "VeryLazy",
    command = function() vim.g.very_lazy_loaded = 1 end,
  })
end
local lazy_call = function(method, ...)
  local up = table.unpack or unpack
  local args = { ... }
  if vim.g.very_lazy_loaded == 1 then
    method(up(args))
    return
  end
  nvim_augroup("lazy_call", {
    event = "User",
    pattern = "VeryLazy",
    command = function() method(up(args)) end,
  })
end

---@param name string
local function lazy_get_plugin(name) return require("lazy.core.config").spec.plugins[name] end

---@param name string
local function lazy_get_plugin_opts(name)
  local plugin = lazy_get_plugin(name)
  if not plugin then return {} end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return {
  lazy_get_plugin = lazy_get_plugin,
  lazy_get_plugin_opts = lazy_get_plugin_opts,
  register_global = register_global,
  nvim_command = nvim_command,
  nvim_smart_split = nvim_smart_split,
  nvim_augroup = nvim_augroup,
  nvim_has_keymap = nvim_has_keymap,
  nvim_get_range = nvim_get_range,
  nvim_create_undo = nvim_create_undo,
  nvim_empty_argc = nvim_empty_argc,
  nvim_workspaces_root = util_memoize(nvim_workspaces_root_),
  nvim_root = nvim_root,
  nvim_tab_root = nvim_tab_root,
  nvim_smart_close = nvim_smart_close,
  nvim_visual_text = nvim_visual_text,
  git_start_nvim = util_memoize(git_start_nvim),
  buffer_is_empty = buffer_is_empty,
  buffer_set_options = buffer_set_options,
  buffer_focus_or_current = buffer_focus_or_current,
  buffer_alt_focusable_bufnr = buffer_alt_focusable_bufnr,
  tab_win_count = tab_win_count,
  keymap_cmd = keymap_cmd,
  keymap_buf_set = keymap_buf_set,
  keymap_super = keymap_super,
  util_toggle_cmd_option = util_toggle_cmd_option,
  util_mk_pattern_table = util_mk_pattern_table,
  util_falsy = util_falsy,
  util_memoize = util_memoize,
  util_toggle_dark = util_toggle_dark,
  util_locate_python_exec_path = util_locate_python_exec_path,
  path_remove_last_separator = path_remove_last_separator,
  astro_extend_core = astro_extend_core,
  path_iterate_parents = path_iterate_parents,
  path_search_ancestors_callback = path_search_ancestors_callback,
  path_is_homedir = path_is_homedir,
  lsp_get_autocmd_arg_client = lsp_get_autocmd_arg_client,
  lazy_call = lazy_call,
  plugin_has_ai_suggestions = plugin_has_ai_suggestions,
  plugin_has_ai_suggestion_text = plugin_has_ai_suggestion_text,
}
