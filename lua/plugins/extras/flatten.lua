local V = require('v')

return {
  "willothy/flatten.nvim",
  ft = { "toggleterm", "terminal", "neo-term" },
  enabled = true,
  lazy = vim.env["NVIM"] == nil,
  priority = 1000,
  dependencies = {},
  opts = function()
    local saved_terminal
    local astrocore = require("astrocore")

    return {
      block_for = {
        gitcommit = true,
        gitrebase = true,
      },
      allow_cmd_passthrough = true,
      -- Allow a nested session to open if Neovim is opened without arguments
      nest_if_no_args = false,
      callbacks = {
        should_block = function(argv)
          local should_block = require("flatten").default_should_block(argv)
          if should_block == true then return true end
          return vim.tbl_contains(argv, "-b") or vim.tbl_contains(argv, "-d") or  V.git_start_nvim()
        end,
        should_nest = require("flatten").default_should_nest,
        pre_open = function()
          if astrocore.is_available("toggleterm.nvim") then
            local term = require("toggleterm.terminal")
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end
        end,
        post_open = vim.schedule_wrap(function(opts)
          local bufnr, winnr, ft, is_blocking, is_diff =
            opts.bufnr, opts.winnr, opts.filetype, opts.is_blocking, opts.is_diff
          local is_neo_term = vim.bo[bufnr].filetype == "neo-term"

          if is_blocking and saved_terminal then
            -- vim.g.cmd_on_toggleterm_close = 'lua vim.api.nvim_set_current_win(' .. winnr .. ')'
            -- Hide the terminal while it's blocking
            saved_terminal:close()
            vim.schedule(function() vim.api.nvim_set_current_win(winnr) end)
          elseif not is_neo_term or is_diff then
            vim.schedule(function() vim.api.nvim_set_current_win(winnr) end)
          end

          if ft == "gitcommit" or ft == "gitrebase" then
            -- If the file is a git commit, create one-shot autocmd to delete it on write
            -- If you just want the toggleable terminal integration, ignore this bit and only use the
            -- code in the else block
            vim.api.nvim_create_autocmd("BufWritePost", {
              buffer = bufnr,
              once = true,
              callback = vim.schedule_wrap(function() vim.api.nvim_buf_delete(bufnr, {}) end),
            })
          end
        end),
        block_end = vim.schedule_wrap(function(opts)
          if saved_terminal then
            saved_terminal:open()
            saved_terminal = nil
            vim.g.cmd_on_toggleterm_close = nil
          end
        end),
      },
      window = {
        open = "split",
      },
      pipe_path = require("flatten").default_pipe_path,
      one_per = {
        kitty = false, -- Flatten all instance in the current Kitty session
        wezterm = false, -- Flatten all instance in the current Wezterm session
      },
    }
  end,
}
