return {
  "echasnovski/mini.clue",
  enabled = false,
  event = {},
  lazy = true,
  opts = function()
    return {
      window = {
        delay = 200,
        config = {
          width = "auto",
        },
      },
      triggers = {},
      clues = {
        vim.g.miniclues,
      },
    }
  end,
}
