local M = {}

function M.setup()
  require('obsidian').setup {
    workspaces = { { name = 'vault', path = '~/notes/' } },
    picker = { name = 'telescope.nvim' },
    ui = { enable = true },
  }
end

return M
