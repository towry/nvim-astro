local M = {}

function M.cmp_is_visible(cmp) return cmp.core.view:visible() or vim.fn.pumvisible() == 1 end

function M.cmp_has_select(cmp) return cmp.core.view:get_selected_entry() ~= nil end

return M
