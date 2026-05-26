local M = {}

function M.setup()
  require('guess-indent').setup {}

  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>j', group = '[J]ira' },
      { '<leader>a', group = '[A]gent Terminal' },
    },
  }

  require('rose-pine').setup { styles = { italic = false } }
  vim.cmd.colorscheme 'rose-pine'

  require('todo-comments').setup { signs = false }

  require('mini.ai').setup { n_lines = 500 }
  require('mini.surround').setup()
  require('mini.statusline').setup { use_icons = vim.g.have_nerd_font }
end

return M
