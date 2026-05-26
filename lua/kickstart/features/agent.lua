local M = {}

local agent = { buf = nil, right_win = nil, float_win = nil, cwd = nil }
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

local function ensure_agent_dimensions()
  if agent.right_win and vim.api.nvim_win_is_valid(agent.right_win) then
    local current_w = vim.api.nvim_win_get_width(agent.right_win)
    if current_w ~= config.agent.right_width then vim.api.nvim_win_set_width(agent.right_win, config.agent.right_width) end
  end
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

local function ensure_agent_buffer(cwd)
  local normalized_cwd = normalize_cwd(cwd)
  local has_valid_buf = agent.buf ~= nil and vim.api.nvim_buf_is_valid(agent.buf)
  if has_valid_buf and agent.cwd == normalized_cwd then
    vim.api.nvim_win_set_buf(0, agent.buf)
    return
  end

  vim.cmd('term ' .. build_agent_term_command(normalized_cwd))
  agent.buf = vim.api.nvim_get_current_buf()
  agent.cwd = normalized_cwd
  set_float_close_keymap(agent.buf)
end

local function open_agent_float(cwd)
  local width = math.floor(vim.o.columns * 0.95)
  local height = math.floor(vim.o.lines * 0.90)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  if agent.float_win and vim.api.nvim_win_is_valid(agent.float_win) then
    vim.api.nvim_set_current_win(agent.float_win)
  elseif agent.buf and vim.api.nvim_buf_is_valid(agent.buf) and agent.cwd == normalize_cwd(cwd) then
    agent.float_win = vim.api.nvim_open_win(agent.buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
  else
    local tmp_buf = vim.api.nvim_create_buf(false, true)
    agent.float_win = vim.api.nvim_open_win(tmp_buf, true, {
      relative = 'editor',
      width = width,
      height = height,
      row = row,
      col = col,
      style = 'minimal',
      border = 'rounded',
    })
  end

  ensure_agent_buffer(cwd)
  set_float_close_keymap(agent.buf)

  vim.api.nvim_set_option_value('number', false, { win = agent.float_win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = agent.float_win })
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

local function open_agent_right(cwd)
  if agent.right_win and vim.api.nvim_win_is_valid(agent.right_win) then
    vim.api.nvim_set_current_win(agent.right_win)
  else
    vim.cmd 'botright vsplit'
    agent.right_win = vim.api.nvim_get_current_win()
  end

  ensure_agent_buffer(cwd)
  vim.api.nvim_win_set_width(agent.right_win, config.agent.right_width)
  vim.api.nvim_set_option_value('number', false, { win = agent.right_win })
  vim.api.nvim_set_option_value('relativenumber', false, { win = agent.right_win })
  vim.cmd 'startinsert'
end

local function toggle_agent_right(cwd)
  if agent.right_win and vim.api.nvim_win_is_valid(agent.right_win) then
    vim.api.nvim_win_hide(agent.right_win)
    agent.right_win = nil
    return
  end

  open_agent_right(cwd)
end

function M.open_float(opts)
  open_agent_float(opts and opts.cwd or nil)
end

function M.open_right(opts)
  open_agent_right(opts and opts.cwd or nil)
end

function M.setup()
  vim.api.nvim_create_autocmd('WinResized', {
    group = vim.api.nvim_create_augroup('kickstart-agent-resize', { clear = true }),
    callback = ensure_agent_dimensions,
  })

  vim.keymap.set('n', '<leader>ar', toggle_agent_right, { desc = 'Toggle [A]gent [R]ight split' })
  vim.keymap.set('n', '<leader>aa', toggle_agent_float, { desc = 'Toggle [A]gent flo[A]ting window' })
end

return M
