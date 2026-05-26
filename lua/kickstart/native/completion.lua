local M = {}

function M.setup()
  vim.o.complete = '.,w,b,o'
  vim.o.completeopt = 'menuone,noselect,fuzzy,popup'
  vim.o.autocomplete = true
  vim.o.autocompletedelay = 200
end

return M
