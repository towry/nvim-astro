-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

if vim.env.PYENV_VERSION == nil then
  -- https://github.com/neovim/nvim-lspconfig/issues/717#issuecomment-1938450468
  vim.env.PYENV_VERSION = vim.fn.system('pyenv version'):match('(%S+)%s+%(.-%)')
end

---- vim.g.{sometable} doesnt update by key
local vim_g_internal_ft_formatter = {}
_G.vim_g_internal_ft_formatter = vim_g_internal_ft_formatter
vim.g.lsp_handler_setup = 0

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Configuration table of features provided by AstroLSP
    features = vim.g.vscode and {} or {
      codelens = true,        -- enable/disable codelens refresh on start
      inlay_hints = true,     -- enable/disable inlay hints on start
      semantic_tokens = true, -- enable/disable semantic token highlighting
      signature_help = false,
    },
    -- customize lsp formatting options
    formatting = {
      -- control auto formatting on save
      format_on_save = {
        enabled = false,    -- enable or disable format on save globally
        allow_filetypes = { -- enable format on save for specified filetypes only
          -- "go",
        },
        ignore_filetypes = { -- disable format on save for specified filetypes
          -- "python",
        },
      },
      disabled = { -- disable formatting capabilities for the listed language servers
        -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
        "lua_ls",
      },
      timeout_ms = 1000,        -- default format timeout
      filter = function(client) -- fully override the default formatting function
        local buf = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(buf) then return false end
        local filetype = vim.api.nvim_get_option_value("filetype", {
          buf = buf,
        })

        if vim_g_internal_ft_formatter[filetype] then
          if vim_g_internal_ft_formatter[filetype] == client.name then return true end
          return false
        end

        --- check null-ls formatter
        if require("plugins.utils._none_ls_utils").is_null_ls_formatter_avalable(filetype) then
          vim_g_internal_ft_formatter[filetype] = "null-ls"
          return client.name == "null-ls"
        end

        vim_g_internal_ft_formatter[filetype] = client.name

        --- others
        return true
      end,
    },
    -- enable servers that you already have installed without mason
    servers = {
      "ocamllsp",
      -- "pyright"
    },
    -- customize language server configuration options passed to `lspconfig`
    ---@diagnostic disable: missing-fields
    config = {
      basedpyright = {
        before_init = function(_, c)
          if not c.settings then c.settings = {} end
          if not c.settings.python then c.settings.python = {} end
          c.settings.python.pythonPath = vim.g.pythonPath or V.util_locate_python_exec_path() or vim.fn.exepath("python")
        end,
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedFunction = "information",
                reportUnusedVariable = "information",
                reportGeneralTypeIssues = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportPrivateImportUsage = "none",
              },
            },
          },
        },
      },
      -- clangd = { capabilities = { offsetEncoding = "utf-8" } },
      vtsls = {
        commands = require("plugins.lsp.commands_.init"),
        settings = {
          typescript = {
            tsserver = {
              -- log = 'verbose',
              maxTsServerMemory = 1800,
            },
            preferences = {
              importModuleSpecifierEnding = "index",
              importModuleSpecifier = "relative",
            },
          },
          javascript = {
            preferences = {
              importModuleSpecifierEnding = "index",
              importModuleSpecifier = "relative",
            },
          },
        },
      },
    },
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
    -- Configure buffer local auto commands to add when attaching a language server
    autocmds = {
      -- first key is the `augroup` to add the auto commands to (:h augroup)
      lsp_codelens_refresh = {
        -- Optional condition to create/delete auto command group
        -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
        -- condition will be resolved for each client on each execution and if it ever fails for all clients,
        -- the auto commands will be deleted for that buffer
        cond = "textDocument/codeLens",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        -- list of auto commands to set
        {
          -- events to trigger
          event = { "InsertLeave", "BufEnter", "LspAttach" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh({ bufnr = args.buf }) end
          end,
        },
      },
      --- need LspReferenceWrite|Read highlights
      lsp_document_highlight = {
        cond = "textDocument/documentHighlight",
        -- cond = function(client, bufnr) return client.name == "lua_ls" end,
        {
          -- events to trigger
          event = { "CursorHold", "CursorHoldI" },
          -- the rest of the autocmd options (:h nvim_create_autocmd)
          desc = "Document Highlighting",
          callback = function() vim.lsp.buf.document_highlight() end,
        },
        {
          event = { "CursorMoved", "CursorMovedI", "BufLeave" },
          desc = "Document Highlighting Clear",
          callback = function() vim.lsp.buf.clear_references() end,
        },
      },
    },
    -- mappings to be set up on attaching of a language server
    --- https://github.com/AstroNvim/AstroNvim/blob/820e6174f75ceffc867c6e2772d463a346be22e8/lua/astronvim/plugins/_astrolsp_mappings.lua#L2
    mappings = {
      n = {
        -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
        -- gD = {
        --   vim.lsp.buf.declaration,
        --   desc = "Declaration of current symbol",
        --   cond = "textDocument/declaration",
        -- },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client.supports_method("textDocument/semanticTokens/full") and vim.lsp.semantic_tokens ~= nil
          end,
        },
        ["<Leader>xd"] = {
          "<cmd>lua vim.diagnostic.setloclist()<cr>",
          desc = "Send all diagnostics to quickfix",
        },
        ["<Leader>xe"] = {
          "<cmd>lua vim.diagnostic.setloclist({severity = vim.diagnostic.severity.ERROR })<cr>",
          desc = "Send error diagnostics to quickfix",
        },
        ["<Leader>xw"] = {
          "<cmd>lua vim.diagnostic.setloclist({severity = vim.diagnostic.severity.WARN })<cr>",
          desc = "Send error diagnostics to quickfix",
        },
      },
    },
    -- A custom `on_attach` function to be run after the default `on_attach` function
    -- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
    on_attach = function(client, bufnr)
      -- this would disable semanticTokensProvider for all clients
      -- client.server_capabilities.semanticTokensProvider = nil
      if vim.g.lsp_handler_setup == 0 then
        vim.g.lsp_handler_setup = 1
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "single",
          title = "Symbol Hover",
          max_width = 80,
        })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { title = "Signature Help", border = "single", max_width = 80 })
      end
    end,
  },
}
