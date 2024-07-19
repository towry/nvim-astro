return {
  "s1n7ax/nvim-window-picker",
  opts = {
    filter_rules = {
      autoselect_one = true,
      include_current_win = false,
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = {
          "fzf",
        },

        -- if the file type is one of following, the window will be ignored
        buftype = {
          "prompt",
          "nowrite",
          "acwrite",
          "quickfix",
        },
      },
    },
    selection_chars = "ABCDEFGHIJKLMNOPQRSTUVW",
  },
  keys = {
    {
      "<leader>w",
      desc = " Windows, not the OS",
    },
    {
      "<leader>wi",
      function()
        local win = require("window-picker").pick_window({
          selection_chars = "123456789ABCDEFGHIJKLMN",
          autoselect_one = false,
          include_current_win = true,
          hint = "floating-big-letter",
          prompt_message = "Focus window: ",
          bo = {
            filetype = {
              "fzf",
            },
            buftype = {
              "acwrite",
            },
          },
        })
        if not win then return end
        vim.api.nvim_set_current_win(win)
      end,
      desc = "Focus a window",
    },
    {
      "<leader>wk",
      function()
        local win = require("window-picker").pick_window({
          selection_chars = "123456789ABCDEFGHIJKLMN",
          autoselect_one = false,
          include_current_win = true,
          hint = "floating-big-letter",
          prompt_message = "Focus window: ",
          bo = {
            filetype = {
              "fzf",
            },
            buftype = {
              "acwrite",
            },
          },
        })
        if not win then return end
        vim.api.nvim_win_close(win, false)
      end,
      desc = "Select window to close",
    },
  },
}
