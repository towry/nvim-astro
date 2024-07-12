local M = {}

function M.cmp_is_visible(cmp) return cmp.core.view:visible() or vim.fn.pumvisible() == 1 end

return M
