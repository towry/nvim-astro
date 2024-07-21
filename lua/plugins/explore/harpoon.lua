local function normalize_path(buf_name, root)
  local Path = require("plenary.path")
  return Path:new(buf_name):make_relative(root)
end
local function get_display(buf_name) return normalize_path(buf_name, vim.fn.getcwd()) end
local function get_display_by_bufno(buf_no) return get_display(vim.api.nvim_buf_get_name(buf_no)) end
local function get_by_display(display) return require("harpoon"):list():get_by_value(display) end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    settings = {
      save_on_toggle = true,
    },
  },
  keys = function()
    local keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
          vim.notify("Harpoon added", vim.log.levels.INFO)
        end,
        desc = "Harpoon Add File",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<leader>hP",
        function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          for _, buf in ipairs(bufs) do
            local buf_no = buf.bufnr
            local display = get_display_by_bufno(buf_no)
            if not get_by_display(display) then vim.api.nvim_buf_delete(buf_no, { force = false }) end
          end
          vim.notify("All other buffers have been cleared", vim.log.levels.INFO)
        end,
        desc = "Delete non-harpooned buffers",
      },
      {
        "<leader>hC",
        function()
          local harpoon = require("harpoon")
          harpoon:list():clear()
          vim.notify("Harpoon buffers have been cleared", vim.log.levels.INFO)
        end,
        desc = "Delete all harpoon buffers",
      },
    }

    for i = 1, 5 do
      table.insert(keys, {
        "<leader>h" .. i,
        function() require("harpoon"):list():select(i) end,
        desc = "Harpoon to File " .. i,
      })
    end
    return keys
  end,
}
