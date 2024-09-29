if vim.o.background == 'dark' then
  package.loaded['darcula-solid.darcula-solid'] = nil
  require('lush')(require('darcula-solid.darcula-solid'))
else
  vim.cmd.source('$VIMRUNTIME/colors/default.vim')
end

vim.g.colors_name = "dark"

