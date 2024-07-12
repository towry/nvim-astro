return {
  "johmsalas/text-case.nvim",
  event = "User AstroFile",
  opts = {
    default_keymappings_enabled = false,
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        --  whichkey group
        maps.n["ga"] = { desc = "Toggle text case" }
        maps.n["ge"] = { desc = "Toggle text case [operator]" }
        maps.n["gau"] = {
          ':lua require("textcase").current_word("to_upper_case")<CR>',
          desc = "Toggle upper case",
        }
        maps.n["gal"] = {
          ':lua require("textcase").current_word("to_lower_case")<CR>',
          desc = "Toggle lower case",
        }

        maps.n["gas"] = {
          ':lua require("textcase").current_word("to_snake_case")<CR>',
          desc = "Toggle snake case",
        }

        maps.n["gan"] = {
          ':lua require("textcase").current_word("to_constant_case")<CR>',
          desc = "Toggle constant case",
        }

        maps.n["gad"] = {
          ':lua require("textcase").current_word("to_dash_case")<CR>',
          desc = "Toggle dash case",
        }

        maps.n["gaa"] = {
          ':lua require("textcase").current_word("to_phrase_case")<CR>',
          desc = "Toggle phrase case",
        }

        maps.n["gac"] = {
          ':lua require("textcase").current_word("to_camel_case")<CR>',
          desc = "Toggle camel case",
        }

        maps.n["gap"] = {
          ':lua require("textcase").current_word("to_pascal_case")<CR>',
          desc = "Toggle pascal case",
        }

        maps.n["gat"] = {
          ':lua require("textcase").current_word("to_title_case")<CR>',
          desc = "Toggle title case",
        }

        maps.n["gaf"] = {
          ':lua require("textcase").current_word("to_path_case")<CR>',
          desc = "Toggle path case",
        }

        maps.n["gaf"] = {
          ':lua require("textcase").current_word("to_path_case")<CR>',
          desc = "Toggle path case",
        }

        maps.n["gaf"] = {
          ':lua require("textcase").current_word("to_path_case")<CR>',
          desc = "Toggle path case",
        }
        -- nnoremap gaU :lua require('textcase').lsp_rename('to_upper_case')<CR>
        maps.n["gaU"] = {
          ':lua require("textcase").lsp_rename("to_upper_case")<CR>',
          desc = "[lsp] Toggle upper case",
        }

        maps.n["gaL"] = {
          ':lua require("textcase").lsp_rename("to_lower_case")<CR>',
          desc = "[lsp] Toggle lower case",
        }

        maps.n["gaS"] = {
          ':lua require("textcase").lsp_rename("to_snake_case")<CR>',
          desc = "[lsp] Toggle snake case",
        }

        maps.n["gaD"] = {
          ':lua require("textcase").lsp_rename("to_dash_case")<CR>',
          desc = "[lsp] Toggle dash case",
        }

        maps.n["gaC"] = {
          ':lua require("textcase").lsp_rename("to_camel_case")<CR>',
          desc = "[lsp] Toggle camel case",
        }

        maps.n["gaP"] = {
          ':lua require("textcase").lsp_rename("to_pascal_case")<CR>',
          desc = "[lsp] Toggle pascal case",
        }

        maps.n["gaT"] = {
          ':lua require("textcase").lsp_rename("to_title_case")<CR>',
          desc = "[lsp] Toggle title case",
        }

        maps.n["gaF"] = {
          ':lua require("textcase").lsp_rename("to_path_case")<CR>',
          desc = "[lsp] Toggle path case",
        }
        -- nnoremap geu :lua require('textcase').operator('to_upper_case')<CR>

        maps.n["geu"] = {
          ':lua require("textcase").operator("to_upper_case")<CR>',
          desc = "[operator] Toggle upper case",
        }

        maps.n["gel"] = {
          ':lua require("textcase").operator("to_lower_case")<CR>',
          desc = "[operator] Toggle lower case",
        }

        maps.n["ges"] = {
          ':lua require("textcase").operator("to_snake_case")<CR>',
          desc = "[operator] Toggle snake case",
        }

        maps.n["ged"] = {
          ':lua require("textcase").operator("to_dash_case")<CR>',
          desc = "[operator] Toggle dash case",
        }

        maps.n["gec"] = {
          ':lua require("textcase").operator("to_camel_case")<CR>',
          desc = "[operator] Toggle camel case",
        }

        maps.n["gep"] = {
          ':lua require("textcase").operator("to_pascal_case")<CR>',
          desc = "[operator] Toggle pascal case",
        }

        maps.n["get"] = {
          ':lua require("textcase").operator("to_title_case")<CR>',
          desc = "[operator] Toggle title case",
        }

        maps.n["gef"] = {
          ':lua require("textcase").operator("to_path_case")<CR>',
          desc = "[operator] Toggle path case",
        }
      end,
    },
  },
}
