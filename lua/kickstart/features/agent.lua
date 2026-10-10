local M = {}

local agent = { buf = nil, float_win = nil, cwd = nil }
local config = require 'kickstart.user_config'
local agent_command = config.agent.command

local function normalize_cwd(cwd)
  if cwd == nil or cwd == '' then return nil end
  return vim.fn.fnamemodify(cwd, ':p')
end

local function build_agent_term_command(cwd)
  local normalized_cwd = normalize_cwd(cwd)
  if normalized_cwd == nil then return agent_command end
  return string.format('cd %s && %s', vim.fn.shellescape(normalized_cwd), agent_command)
end

local function compute_float_dimensions()
  local max_lines = vim.o.lines - vim.o.cmdheight
  if vim.o.laststatus ~= 0 then
    max_lines = max_lines - 1
  end
  local width = math.floor(vim.o.columns * 0.95)
  local height = math.floor(max_lines * 0.90)
  local row = math.floor((max_lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return width, height, row, col
end

local function float_win_config()
  local width, height, row, col = compute_float_dimensions()
  return {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Agent ',
    title_pos = 'center',
    noautocmd = true,
    zindex = 50,
  }
end

local function set_float_close_keymap(buf)
  vim.keymap.set('n', '<Esc>', function()
    if
      agent.float_win
      and vim.api.nvim_win_is_valid(agent.float_win)
      and vim.api.nvim_get_current_win() == agent.float_win
    then
      vim.api.nvim_win_hide(agent.float_win)
      agent.float_win = nil
    end
  end, { buffer = buf, desc = 'Close agent float' })
end

local function set_window_options(win)
  vim.api.nvim_set_option_value('number', false, { win = win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = win })
  vim.api.nvim_set_option_value('winfixbuf', true, { win = win })
end

local function needs_new_terminal(cwd)
  local normalized_cwd = normalize_cwd(cwd)
  return not (agent.buf and vim.api.nvim_buf_is_valid(agent.buf) and agent.cwd == normalized_cwd)
end

local function start_agent_terminal(cwd)
  local normalized_cwd = normalize_cwd(cwd)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.fn.termopen(build_agent_term_command(normalized_cwd))
  agent.buf = buf
  agent.cwd = normalized_cwd
  set_float_close_keymap(buf)
end

local function open_agent_float(cwd)
  if agent.float_win and vim.api.nvim_win_is_valid(agent.float_win) then
    vim.api.nvim_set_current_win(agent.float_win)
    return
  end

  local buf = needs_new_terminal(cwd) and vim.api.nvim_create_buf(false, true) or agent.buf

  agent.float_win = vim.api.nvim_open_win(buf, true, float_win_config())

  if needs_new_terminal(cwd) then
    start_agent_terminal(cwd)
  else
    vim.api.nvim_win_set_buf(0, agent.buf)
  end

  set_window_options(agent.float_win)
  vim.api.nvim_set_option_value('winhighlight', 'Normal:Normal', { win = agent.float_win })
  vim.cmd 'startinsert'
end

local function toggle_agent_float(cwd)
  if agent.float_win and vim.api.nvim_win_is_valid(agent.float_win) then
    vim.api.nvim_win_hide(agent.float_win)
    agent.float_win = nil
    return
  end

  open_agent_float(cwd)
end

local function ensure_float_dimensions()
  if agent.float_win and vim.api.nvim_win_is_valid(agent.float_win) then
    vim.api.nvim_win_set_config(agent.float_win, float_win_config())
  end
end

function M.open_float(opts)
  open_agent_float(opts and opts.cwd or nil)
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'WinResized', 'VimResized' }, {
    group = vim.api.nvim_create_augroup('kickstart-agent-resize', { clear = true }),
    callback = ensure_float_dimensions,
  })

  vim.keymap.set('n', '<leader>aa', toggle_agent_float, { desc = 'Toggle [A]gent flo[A]ting window' })
end

return M
