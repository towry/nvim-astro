local function OverseerTasksForStatus(status)
  local utils = require("heirline.utils")

  return {
    condition = function(self) return self.tasks[status] end,
    provider = function(self)
      if #self.tasks[status] <= 0 then return "" end
      return string.format("%s%d", self.symbols[status], #self.tasks[status])
    end,
    surround = { separator = "left" },
    hl = function()
      return {
        fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
      }
    end,
  }
end

return function(opts)
  local extend_tbl = require("astrocore").extend_tbl
  local component = require("astroui.status.component")

  opts = extend_tbl({
    condition = function() return package.loaded.overseer end,
    init = function(self)
      local tasks = require("overseer.task_list").list_tasks({ unique = true })
      local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
      self.tasks = tasks_by_status
    end,
    static = {
      symbols = {
        ["CANCELED"] = " ",
        ["FAILURE"] = "󰅚 ",
        ["SUCCESS"] = "󰄴 ",
        ["RUNNING"] = "󰑮 ",
      },
    },

    OverseerTasksForStatus("CANCELED"),
    OverseerTasksForStatus("RUNNING"),
    OverseerTasksForStatus("SUCCESS"),
    OverseerTasksForStatus("FAILURE"),
  }, opts)

  return component.builder(opts)
end
