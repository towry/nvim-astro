-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

local v = require("v")
do -- smart close
  local smart_close_ft = {
    "PlenaryTestPopup",
    "help",
    "qf",
    "log",
    "query",
    "dbui",
    "lspinfo",
    "checkhealth",
    "git",
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    "fugitive",
    "dbout",
    "startuptime",
  }
  v.nvim_augroup("SmartWinClose", {
    event = "FileType",
    pattern = smart_close_ft,
    command = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end,
  }, {
    event = { "BufEnter" },
    command = function()
      if vim.fn.winnr("$") == 1 and vim.bo.buftype == "quickfix" then vim.api.nvim_buf_delete(0, { force = true }) end
    end,
    desc = "Close quickfix window if the file containing it was closed",
  }, {
    event = { "QuitPre" },
    nested = true,
    command = function()
      if vim.bo.filetype ~= "qf" then vim.cmd.lclose({ mods = { silent = true } }) end
    end,
    desc = "Auto close corresponding loclist when quiting a window",
  })
end

v.nvim_augroup("GrepWinAutoOpen", {
  event = { "QuickFixCmdPost" },
  pattern = { "*grep*" },
  command = "cwindow",
})
v.nvim_augroup("CheckOutsideChange", {
  event = { "WinEnter", "BufWinEnter", "BufWinLeave", "BufRead", "BufEnter", "FocusGained" },
  command = "silent! checktime",
})
v.nvim_augroup("SetKeyOnCmdWin", {
  event = { "CmdwinEnter" },
  command = function(ctx)
    local bufnr = ctx.buf
    assert(type(bufnr) == "number")
    vim.b[bufnr].bufname = "Cmdwin"
    local set = vim.keymap.set

    --- run command and reopen it
    set("n", "<F1>", "<CR>q:", {
      buffer = bufnr,
      silent = true,
    })
    set("n", "q", "<C-w>c", {
      buffer = bufnr,
      silent = true,
      nowait = true,
      noremap = true,
    })
  end,
})
v.nvim_augroup("bigfile", {
  event = { "FileType" },
  pattern = "bigfile",
  command = function(ev)
    vim.b.minianimate_disable = true
    vim.schedule(function() vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or "" end)
  end,
})

-- Set up custom filetypes
vim.filetype.add({
  extension = {},
  filename = {},
  pattern = {},
})

do
  local set = vim.keymap.set
  local cmd = V.keymap_cmd

  for i = 1, 9 do
    set("n", "<space>" .. i, cmd(i .. "tabnext"), {
      desc = "which_key_ignore",
    })
    --- use option key to navigate tab quickly.
    --- cmd key is used by the mux program.
    set({ "n", "t" }, "<M-" .. i .. ">", cmd(i .. "tabnext"), {
      desc = "which_key_ignore",
    })
  end
  set({ "i", "n", "t" }, "<M-[>", cmd("tabp"), { desc = "Tab pre" })
  set({ "i", "n", "t" }, "<M-]>", cmd("tabn"), { desc = "Tab next" })
  set("n", "<leader>nt", cmd("tabnew"), {
    desc = "New tab",
  })
end

V.lazy_call(require, "vendor._abbr")
