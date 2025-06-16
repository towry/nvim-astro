return {
  "azorng/goose.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    keymap = {
      global = {
        open_input = "<leader>agi",
        open_input_new_session = "<leader>agn",
        open_output = "<leader>ago",
        close = "<leader>agc",
        toggle_fullscreen = "<leader>agf",
        select_session = "<leader>ags",
      },
    },
    ui = {
      window_width = 0.45, -- Width as percentage of editor width
      input_height = 0.10, -- Input height as percentage of window height
      fullscreen = false, -- Start in fullscreen mode (default: false)
    },
  },
}
