-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {
  { import = "plugins.extras.flatten" },
  { import = "plugins.extras.window-picker" },
  { import = "plugins.extras.trailblazer" },
  { import = "plugins.extras.codeium" },
  {
    "echasnovski/mini.move",
    keys = {
      { "<M-h>", mode = { "v" } },
      { "<M-j>", mode = { "v" } },
      { "<M-k>", mode = { "v" } },
      { "<M-l>", mode = { "v" } },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "LspAttach",
    config = function() require("lsp_signature").setup() end,
  },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    optional = true,
    config = function(plugin, opts)
      require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local ws_root = V.nvim_workspaces_root() .. "/.vscode"
      local uv_root = vim.uv.cwd() .. "/.vscode"

      require("luasnip.loaders.from_vscode").lazy_load({
        paths = {
          vim.fn.stdpath("config") .. "/snippets",
          ws_root,
          uv_root,
        },
      })
      local luasnip = require("luasnip")
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    optional = true,
    config = function(plugin, opts)
      require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require("nvim-autopairs")
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex("%%"))
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex("xx"))
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
