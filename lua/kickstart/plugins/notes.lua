local M = {}

function M.setup()
  require('obsidian').setup {
    workspaces = { { name = 'vault', path = '~/Desktop/Pauls Notes' } },
    picker = { name = 'telescope.nvim' },
    ui = { enable = true },
  }
end

return M
