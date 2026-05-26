local M = {}

function M.setup()
  require('nvim-tree').setup {
    git = { ignore = false },
    renderer = {
      icons = {
        show = { file = vim.g.have_nerd_font, folder = vim.g.have_nerd_font },
      },
    },
  }

  vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle [E]xplorer', silent = true })
  vim.keymap.set('n', '<leader>fe', ':NvimTreeFocus<CR>', { desc = '[F]ocus [E]xplorer', silent = true })
end

return M
