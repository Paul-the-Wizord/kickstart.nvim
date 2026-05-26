local M = {}

function M.setup()
  local lint = require 'lint'
  lint.linters_by_ft = {
    markdown = { 'markdownlint' },
  }

  local function resolve_cmd(linter)
    if not linter then return nil end
    local cmd = linter.cmd
    if type(cmd) == 'function' then
      local ok, value = pcall(cmd)
      if ok then return value end
      return nil
    end
    return cmd
  end

  local function available_linters_for_current_buffer()
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)
    if not names or #names == 0 then return {} end

    local available = {}
    for _, name in ipairs(names) do
      local linter = lint.linters[name]
      local cmd = resolve_cmd(linter)
      if type(cmd) ~= 'string' or vim.fn.executable(cmd) == 1 then table.insert(available, name) end
    end

    return available
  end

  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      if vim.bo.buftype ~= '' or not vim.bo.modifiable or vim.bo.readonly then return end

      local available_linters = available_linters_for_current_buffer()
      if #available_linters == 0 then return end

      local ok, err = pcall(lint.try_lint, available_linters)
      if not ok then vim.notify('Lint failed: ' .. err, vim.log.levels.WARN) end
    end,
  })
end

return M
