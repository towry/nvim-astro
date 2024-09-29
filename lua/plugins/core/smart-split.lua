local V = require("v")
local term = vim.trim((vim.env.TERM_PROGRAM or ""):lower())
local mux = term == "tmux" or term == "wezterm" or vim.env.KITTY_LISTEN_ON
local cmdstr = V.keymap_cmd

return {
  "mrjones2014/smart-splits.nvim",
  lazy = true,
  event = mux and "VeryLazy" or nil, -- load early if mux detected
  keys = {
    {
      "<C-\\><C-r>h",
      mode = { "n", "t" },
      cmdstr([[lua require("smart-splits").resize_left()]]),
      desc = "Start resize mode",
    },
    {
      "<C-\\><C-r>j",
      mode = { "n", "t" },
      cmdstr([[lua require("smart-splits").resize_down()]]),
      desc = "Resize window to down",
    },
    {
      "<C-\\><C-r>k",
      mode = { "n", "t" },
      cmdstr([[lua require("smart-splits").resize_up()]]),
      desc = "Resize window to up",
    },
    {
      "<C-\\><C-r>l",
      mode = { "n", "t" },
      cmdstr([[lua require("smart-splits").resize_right()]]),
      desc = "Resize window to right",
    },

    {
      "<A-h>",
      cmdstr([[lua require("smart-splits").resize_left()]]),
      desc = "Resize window to left",
    },
    {
      "<A-j>",
      cmdstr([[lua require("smart-splits").resize_down()]]),
      desc = "Resize window to down",
    },
    {
      "<A-k>",
      cmdstr([[lua require("smart-splits").resize_up()]]),
      desc = "Resize window to up",
    },
    {
      "<A-l>",
      cmdstr([[lua require("smart-splits").resize_right()]]),
      desc = "Resize window to right",
    },
    {
      "<C-h>",
      cmdstr([[lua require("smart-splits").move_cursor_left()]]),
      desc = "Move cursor to left window",
    },
    {
      "<C-j>",
      cmdstr([[lua require("smart-splits").move_cursor_down()]]),
      desc = "Move cursor to down window",
    },
    {
      "<C-k>",
      cmdstr([[lua require("smart-splits").move_cursor_up()]]),
      desc = "Move cursor to up window",
    },
    {
      "<C-l>",
      cmdstr([[lua require("smart-splits").move_cursor_right()]]),
      desc = "Move cursor to right window",
    },
  },
  -- only if you use kitty term
  -- build = './kitty/install-kittens.bash',
  config = function()
    local splits = require("smart-splits")

    splits.setup({
      default_amount = 5,
      -- Ignored filetypes (only while resizing)
      ignored_filetypes = {
        "nofile",
        "quickfix",
        "prompt",
        "qf",
      },
      -- Ignored buffer types (only while resizing)
      ignored_buftypes = { "nofile", "NvimTree" },
      resize_mode = {
        quit_key = {
          quit_key = "<ESC>",
          resize_keys = { "h", "j", "k", "l" },
        },
        hooks = {
          -- on_leave = function() Ty.resize.record() end,
        },
      },
      ignored_events = {
        "BufEnter",
        "WinEnter",
      },
      log_level = "error",
      disable_multiplexer_nav_when_zoomed = true,
    })
  end,
}
