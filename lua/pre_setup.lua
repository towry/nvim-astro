vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("vim._extui").enable({
  enable = true,
  msg = {
    pos = "box",
    box = {
      timeout = 4000,
    },
  },
})

require("vendor.options")
