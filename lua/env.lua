local V = require "v"
pcall(require, "nix-env")
pcall(require, "settings_env")

vim.g.cfg_inside = {
  git = V.git_is_using_nvim_as_tool(),
}
