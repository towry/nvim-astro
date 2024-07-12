vim.opt_local.relativenumber = false
-- do not show char after line ending.
vim.opt_local.listchars:append("trail: ")
vim.b[0].autoformat_disable = true
vim.bo.syntax = "diff"
vim.opt_local.foldmethod = "syntax"
if vim.fn.exists("*fugitive#Foldtext()") == 1 then vim.cmd("setlocal foldtext=fugitive#Foldtext()") end
vim.cmd("normal! zM")

--- copy file path from git view
--- press <enter> in the cmdline to yank
vim.keymap.set("n", "<localleader>yp", function()
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(".", true, true, true))
  --- wait until cmdline is fulfilled.
  vim.schedule(
    function() vim.fn.feedkeys(vim.api.nvim_replace_termcodes("silent !echo<C-e> | pbcopy", true, true, true)) end
  )
end, {
  desc = "Yank the file path under the cursor in cmdline",
  buffer = vim.api.nvim_get_current_buf(),
})
