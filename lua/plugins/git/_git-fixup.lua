local M = {}

local function check_requirements()
  if vim.fn.executable("git-smash") == 0 or vim.fn.executable("fzf") == 0 then return false end
  return true
end

M.fixup = function()
  local Terminal = require("toggleterm.terminal").Terminal
  local git_dir = vim.fs.root(0, ".git")

  if not check_requirements() then
    vim.notify("git-smash or fzf is required, please make sure they are installed.", vim.log.levels.ERROR)
    return
  end

  local git = Terminal:new({
    -- Just create fixup commits from the picks.
    cmd = "git-smash --no-rebase --recent 3",
    dir = git_dir,
    direction = "float",
    close_on_exit = true,
    hidden = true,
    float_opts = {
      border = "none",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    end,
    on_exit = function(_t, _job, exit_code)
      if exit_code == 0 then
        vim.notify("git fixup commit created", vim.log.levels.INFO)
      else
        vim.notify("failed to create fixup commit", vim.log.levels.ERROR)
      end
    end,
    -- function to run on closing the terminal
    on_close = function(term) vim.cmd("startinsert!") end,
  })

  git:toggle()
end

return M
