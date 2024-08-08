local V = require("v")

return {
  { import = "plugins.lsp.astrolsp" },
  { import = "plugins.lsp.mason" },
  { import = "plugins.lsp.none-ls" },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
      V.astro_extend_core({
        autocmds = {
          SetupNavbuddyOnAttach = {
            {
              event = "LspAttach",
              desc = "attach navic",
              callback = function(args)
                local client = V.lsp_get_autocmd_arg_client(args)
                if client and client.supports_method("textDocument/documentSymbol") then
                  require("nvim-navbuddy").attach(client, args.buf)
                end
              end,
            },
          },
        },
      }),
    },
    event = "LspAttach",
    cmd = "Navbuddy",
    keys = {
      {
        "<leader>le",
        function() require("nvim-navbuddy").open() end,
        desc = "Navigate symbols in tree view",
      },
    },
    opts = {
      window = {
        size = { width = "98%", height = "75%" },
        position = "2%",
      },
      lsp = { auto_attach = false },
    },
  },
}
