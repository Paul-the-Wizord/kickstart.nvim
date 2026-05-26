local M = {}

function M.setup()
  require('conform').setup {
    format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format' },
      markdown = { 'prettier' },
      sh = { 'shfmt' },
    },
  }
end

return M
