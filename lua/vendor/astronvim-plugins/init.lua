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
  "aerial",
  "comment",
  "dap",
  "gitsigns",
  "heirline",
  "highlight-colors",
  "guess-indent",
  "lspconfig",
  "mason-tool-installer",
  "mason",
  "mini-icons",
  "neo-tree",
  "lazydev",
  "resession",
  "todo-comments",
  "toggleterm",
  "treesitter",
  "ts-autotag",
  "vim-illuminate",
  "ts-context-commentstring",
  "which-key",
  "window-picker",
  "luasnip"
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
