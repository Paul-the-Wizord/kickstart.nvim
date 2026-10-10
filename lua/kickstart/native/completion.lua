local M = {}

function M.setup()
  -- 'o' (omnifunc) is intentionally omitted here: filetype plugins set a legacy
  -- omnifunc (e.g. python3complete#Complete) as soon as the buffer loads, and
  -- 'autocomplete' would trigger it immediately, before the LSP client attaches
  -- and takes over 'omnifunc'. It's added buffer-locally on LspAttach instead
  -- (see native/lsp.lua) to avoid errors from those legacy completion functions.
  vim.o.complete = '.,w,b'
  vim.o.completeopt = 'menuone,noselect,fuzzy,popup'
  vim.o.autocomplete = true
  vim.o.autocompletedelay = 200
end

return M
