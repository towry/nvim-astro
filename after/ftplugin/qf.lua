vim.opt_local.wrap = true
vim.keymap.set("n", "tw", function()
  ---@diagnostic disable-next-line: undefined-field
  if vim.opt_local.wrap:get() then
    vim.opt_local.wrap = false
  else
    vim.opt_local.wrap = true
  end
end, {
  buffer = true,
  desc = "Toggle wrap",
})
