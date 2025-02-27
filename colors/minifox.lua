require("nightfox.config").set_fox(vim.o.background == "dark" and "nordfox" or "dayfox")
require("nightfox").load()
vim.g.colors_name = "minifox"
