local M = {}

local terminals = {}

local function ensure_terminal_dimensions()
  for _, t in pairs(terminals) do
    if t.win and vim.api.nvim_win_is_valid(t.win) then
      if t.height then
        local current_h = vim.api.nvim_win_get_height(t.win)
        if current_h ~= t.height then vim.api.nvim_win_set_height(t.win, t.height) end
      end
      if t.width then
        local current_w = vim.api.nvim_win_get_width(t.win)
        if current_w ~= t.width then vim.api.nvim_win_set_width(t.win, t.width) end
      end
    end
  end
end

local function toggle_terminal(name)
  local t = terminals[name]
  if t.win and vim.api.nvim_win_is_valid(t.win) then
    vim.api.nvim_win_hide(t.win)
    t.win = nil
    return
  end

  vim.cmd(t.split)
  if t.buf == nil or not vim.api.nvim_buf_is_valid(t.buf) then
    vim.cmd(t.cmd)
    t.buf = vim.api.nvim_get_current_buf()
    t.win = vim.api.nvim_get_current_win()
  else
    vim.api.nvim_win_set_buf(0, t.buf)
    t.win = vim.api.nvim_get_current_win()
  end

  if t.width then vim.api.nvim_win_set_width(t.win, t.width) end
  if t.height then vim.api.nvim_win_set_height(t.win, t.height) end

  vim.api.nvim_set_option_value('number', false, { win = t.win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = t.win })
  vim.cmd 'startinsert'
end

function M.setup()
  local config = require 'kickstart.user_config'
  terminals.term = {
    buf = nil,
    win = nil,
    cmd = 'term',
    split = config.terminal.split,
    width = nil,
    height = config.terminal.height,
  }

  vim.api.nvim_create_autocmd('WinResized', {
    group = vim.api.nvim_create_augroup('kickstart-terminal-resize', { clear = true }),
    callback = ensure_terminal_dimensions,
  })

  vim.keymap.set('n', '<leader>t', function() toggle_terminal 'term' end, { desc = 'Toggle [T]erminal' })
end

return M
