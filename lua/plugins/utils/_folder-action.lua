local V = require("v")
local M = {}

local picker_mod = "plugins.finder.fzf-lua._pickers"

M.open = vim.schedule_wrap(function(new_cwd)
  new_cwd = V.path_remove_last_separator(new_cwd)
  --- NOTE: wip
  local nicely_cwd = new_cwd

  require("plugins.utils._shortly_keymaps").open(function(set, unset)
    set("n", "1", '<cmd>echo expand("%")<cr>', { desc = " :" .. vim.fn.fnamemodify(nicely_cwd, ":~") })

    set("n", "f", function()
      require(picker_mod).files({
        cwd = new_cwd,
        cwd_header = true,
      })
      unset()
    end, {
      desc = "Open files",
    })
    set("n", "p", function()
      require(picker_mod).folders({
        cwd = new_cwd,
        cwd_header = true,
      })
      unset()
    end, {
      desc = "Open folders",
    })
    set("n", "s", function()
      require(picker_mod).live_grep({
        cwd = new_cwd,
        cwd_header = true,
      })
      unset()
    end, {
      desc = "Search content",
    })

    set("n", "\\", function()
      require("neo-tree.command").execute({
        position = "right",
        -- action = 'set_root',
        source = "filesystem",
        dir = new_cwd,
        reveal_force_cwd = true,
      })
    end, {
      desc = "Open in tree",
    })

    set(
      "n",
      "|",
      function()
        require("neo-tree.command").execute({
          position = "left",
          reveal_file = new_cwd,
          reveal_force_cwd = true,
          source = "buffers",
        })
      end,
      {
        desc = "Open in tree and reveal buffers",
      }
    )

    set("n", "g", function() require("rgflow").open(nil, nil, new_cwd) end, {
      desc = "Grep on it",
    })
    set("n", "r", function()
      require("fzf-lua").oldfiles({
        cwd_header = true,
        cwd = new_cwd,
        cwd_only = true,
        winopts = {
          fullscreen = false,
        },
      })
      unset()
    end, {
      desc = "Open recent",
    })

    set("n", "#", function()
      vim.cmd.cd(new_cwd)
      vim.notify("New Cwd: " .. vim.fn.fnamemodify(new_cwd, ":~"), vim.log.levels.INFO)
    end, {
      desc = "Change project root",
    })

    set("n", "o", function()
      require("oil").open(new_cwd)
      unset()
    end, {
      desc = "Open in oil",
    })
    set("n", "t", function()
      vim.cmd("tabfind " .. new_cwd)
      unset()
    end, {
      desc = "Open in tab",
    })
    set("n", "c", function() vim.cmd(string.format("ToggleTerm dir=%s", new_cwd)) end, {
      desc = "Open in terminal",
    })
    -- set("n", "p", function() require("userlib.mini.visits").add_project(new_cwd, vim.cfg.runtime__starts_cwd) end, {
    --   desc = "Mark project",
    -- })
  end)
end)

return M
