return {
  "s1n7ax/nvim-window-picker",
  version = "*",
  opts = {
    filter_rules = {
      autoselect_one = true,
      include_current_win = false,
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = {
          "fzf",
          "neo-tree",
        },

        -- if the file type is one of following, the window will be ignored
        buftype = {
          "prompt",
          "nofile",
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
          hint = "floating-big-letter",
          prompt_message = "Focus window: ",
          filter_rules = {
            include_current_win = true,
            autoselect_one = false,
            bo = {
              filetype = {
                "fzf",
              },
              buftype = {
                "acwrite",
              },
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
          hint = "floating-big-letter",
          prompt_message = "Focus window: ",
          filter_rules = {
            autoselect_one = false,
            include_current_win = true,
            bo = {
              filetype = {
                "fzf",
              },
              buftype = {
                "acwrite",
              },
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
