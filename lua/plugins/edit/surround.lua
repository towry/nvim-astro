return {
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "User AstroFile",
    keys = {
      { "z]", desc = "Mini surround find right" },
      { "z[", desc = "Mini surround find left" },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "z]",
        find_left = "z[",
        highlight = "",
        replace = "cs",
        update_n_lines = "",

        -- Add this only if you don't want to use extended mappings
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
  },
}
