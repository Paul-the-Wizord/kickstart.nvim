local M = {
  terminal = {
    shell = (vim.env.SHELL and vim.env.SHELL ~= '') and vim.env.SHELL or '/bin/bash',
    split = 'botright 15split',
    height = 15,
  },
  agent = {
    command = 'opencode',
    right_width = 60,
  },
}

return M
