return setmetatable({}, {
  __index = function(_, key) return require("plugins.ui.heirline.component_" .. key) end,
})
