return {
  OrganizeImports = {
    function() vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true }) end,
    description = "Organize imports",
  },
  AddMissingImports = {
    function() vim.lsp.buf.code_action({ context = { only = { "source.addMissingImports" } }, apply = true }) end,
    description = "Add missing imports",
  },
}
