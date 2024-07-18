local M = {}
local windows = {}
local count_windows = 0
---@type number?
local last_window

local get_size = function() return vim.o.lines * 0.7 end

local augroup = vim.api.nvim_create_augroup("overseer_user_open_on_start", {})

M.resize_windows_on_stack = function()
  local each_height = math.floor(vim.o.lines / count_windows)
  for _, window in pairs(windows) do
    vim.api.nvim_win_set_height(window, each_height)
  end
end

M.add_window_to_stack = function(bufnr)
  if not last_window or not vim.api.nvim_win_is_valid(last_window) then
    M.create_window(bufnr, "botright", get_size)
    return
  end
  vim.api.nvim_set_current_win(last_window)
  M.create_window(bufnr, "botright")
  M.resize_windows_on_stack()
end

M.create_window = function(bufnr, modifier, size)
  if size == nil then
    size = ""
  elseif type(size) == "function" then
    size = size()
  end

  local smart_split = V.nvim_smart_split()
  local cmd = smart_split.cmd
  if modifier ~= "" then cmd = modifier .. " " .. cmd end
  vim.cmd(cmd)

  local winid = vim.api.nvim_get_current_win()
  if not bufnr then
    vim.notify("buf is nil", vim.log.levels.ERROR)
    return
  end
  windows[bufnr] = winid
  last_window = winid
  count_windows = count_windows + 1
  vim.wo[winid].winfixwidth = true
  vim.wo[winid].winfixheight = true
  vim.wo[winid].wrap = true

  vim.keymap.set("n", "q", "<cmd>hide<cr>", { buffer = bufnr, desc = "quit" })

  vim.api.nvim_create_autocmd("WinClosed", {
    group = augroup,
    pattern = tostring(winid),
    callback = function()
      windows[bufnr] = nil
      return true
    end,
  })
end

M.close_window = function(bufnr)
  local winid = windows[bufnr]
  windows[bufnr] = nil
  if not winid then return false end

  if not vim.api.nvim_win_is_valid(winid) then return false end

  vim.api.nvim_win_close(winid, false)
end

function M.get_last_task()
  local overseer = require("overseer")
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    return nil
  else
    return tasks[1]
  end
end

--- https://github.com/pianocomposer321/dotfiles-yadm/blob/d8f7da6c19095353eb43c5fa8023148cff4440f4/.config/nvim/lua/user/overseer_util.lua
--- @param task_ overseer.Task?
function M.open_vsplit_last(task_)
  local task = task_ or M.get_last_task()
  if task then
    local bufnr = task:get_bufnr()
    if not bufnr then
      vim.notify("No task buf found", vim.log.levels.ERROR)
      return
    end
    M.add_window_to_stack(bufnr)
    vim.api.nvim_win_set_buf(0, bufnr)
  end
end

---@param opts overseer.Param?
function M.start_template_and_open(opts)
  local ov = require("overseer")
  ov.run_template(opts, function(task)
    if not task then
      vim.notify("No task found", vim.log.levels.INFO)
      return
    end
    M.open_vsplit_last(task)
  end)
end

function M.start_template_by_tags(tags)
  local ov = require("overseer")
  ov.run_template({
    tags = tags,
  }, function(task)
    if not task then
      vim.notify("No task found", vim.log.levels.INFO)
      return
    end
    ov.run_action(task, "open hsplit")
  end)
end

--- If no template task run before, there will be no tasks.
function M.run_action_on_tasks(opts)
  local ov = require("overseer")
  local tasks = ov.list_tasks(opts)
  local action_util = require("overseer.action_util")

  if #tasks == 0 then
    vim.notify("No tasks available", vim.log.levels.WARN)
    return
  elseif #tasks == 1 then
    action_util.run_task_action(tasks[1])
    return
  end

  local task_summaries = vim.tbl_map(function(task) return { name = task.name, id = task.id } end, tasks)

  vim.ui.select(task_summaries, {
    prompt = "Select task",
    kind = "overseer_task",
    format_item = function(task) return task.name end,
  }, function(task_summary)
    if task_summary then
      local task = assert(task_list.get(task_summary.id))
      action_util.run_task_action(task)
    end
  end)
end

return M
