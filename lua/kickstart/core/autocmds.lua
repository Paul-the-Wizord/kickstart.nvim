local M = {}

function M.setup()
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
    group = vim.api.nvim_create_augroup('auto-reload-files', { clear = true }),
    callback = function() vim.cmd 'checktime' end,
  })

  vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
    end,
  })

  -- Clear the legacy python3complete omnifunc before the LSP attaches.
  -- Without this, 'autocomplete' fires on insert and calls python3complete#Complete
  -- which errors because g:python3complete_completions is undefined.
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Clear legacy omnifunc for Python (LSP will set it on attach)',
    group = vim.api.nvim_create_augroup('python-clear-omnifunc', { clear = true }),
    pattern = 'python',
    callback = function() vim.bo.omnifunc = '' end,
  })

  local spell_group = vim.api.nvim_create_augroup('user-spell-check', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Enable spell checking for text files',
    group = spell_group,
    pattern = { 'markdown', 'text', 'gitcommit', 'tex' },
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_us'
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    desc = 'Enable spell checking in comments/strings for code',
    group = spell_group,
    pattern = { 'python', 'javascript', 'typescript', 'lua', 'java', 'c', 'cpp', 'rust', 'go' },
    callback = function()
      vim.opt_local.spell = true
      vim.opt_local.spelllang = 'en_us'
    end,
  })
end

return M
