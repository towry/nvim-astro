local M = {}

---@param callback function
M.open = function(callback)
  local _ = function(prefix)
    return function() callback(prefix) end
  end

  require("plugins.utils._shortly_keymaps").open(function(set, unset)
    set("j", _("wip: <🤩>"), { desc = "wip: <🤩>", noremap = true })
    set("f", _("fix: <🐞>"), { desc = "fix: <🐞>" })
    set("s", _("format: <💅>"), { desc = "format: <💅>" })
    set("t", _("test: <🐛>"), { desc = "test: <🐛>" })
    set("r", _("refactor: <🍔>"), { desc = "refactor: <🍔>" })
    set("d", _("doc: <📚>"), { desc = "doc: <📚>" })
    set("p", _("perf: <🚀>"), { desc = "perf: <🚀>" })
    set("c", _("chore: <🔨>"), { desc = "chore: <🔨>" })
    set("b", _("build: <🏗️>"), { desc = "build: <🏗️>" })
    set("i", _("ci: <👷>"), { desc = "ci: <👷>" })
    set("a", _("deps: <📦>"), { desc = "deps: <📦>" })
    set("l", _("cleanup: <🗑️>"), { desc = "cleanup: <🗑️>" })
    set("x", _("revert: <🔙>"), { desc = "revert: <🔙>" })
    set("u", _("feat: <🍋>"), { desc = "feat: <🍋>" })
  end)
end

return M
