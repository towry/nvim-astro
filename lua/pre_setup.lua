require("vim._extui").enable({
  enable = true,
  msg = {
    pos = "box",
  },
})
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("vendor.options")
