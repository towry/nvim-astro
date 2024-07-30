local modules = {
  "_astrocore",
  "_astrocore_autocmds",
  "_astrocore_mappings",
  "_astrocore_options",
  "_astrolsp",
  "_astrolsp_autocmds",
  "_astrolsp_mappings",
  "_astrotheme",
  "_astroui",
  "_astroui_status",
  "autopairs",
  "cmp_luasnip",
  "colorizer",
  "comment",
  "dap",
  "dressing",
  "gitsigns",
  "guess-indent",
  "heirline",
  "indent-blankline",
  "lspconfig",
  "lspkind",
  "mason",
  "mini-bufremove",
  "neo-tree",
  "lazydev",
  -- "none-ls",
  require("vendor.astronvim-plugins.none-ls"),
  "resession",
  -- "smart-splits",
  "telescope",
  "todo-comments",
  "toggleterm",
  "treesitter",
  "ts-autotag",
  "ts-context-commentstring",
  "web-devicons",
  "which-key",
  "window-picker",
}

local M = {}

for _, m in ipairs(modules) do
  if type(m) == "string" then
    table.insert(M, require("astronvim.plugins." .. m))
  else
    table.insert(M, m)
  end
end
return M
