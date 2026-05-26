local M = {}

function M.setup()
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    current_line_blame = false,
    current_line_blame_opts = { delay = 300 },
    on_attach = function(bufnr)
      vim.keymap.set('n', '<leader>gl', require('gitsigns').toggle_current_line_blame, {
        buffer = bufnr,
        desc = 'Toggle git blame',
      })
    end,
  }

  vim.keymap.set('n', '<leader>gd', function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd 'DiffviewOpen'
    else
      vim.cmd 'DiffviewClose'
    end
  end, { desc = '[G]it [D]iff toggle' })

  vim.keymap.set('n', '<leader>gh', function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd 'DiffviewFileHistory %'
    else
      vim.cmd 'DiffviewClose'
    end
  end, { desc = '[G]it file [H]istory toggle' })

  vim.keymap.set('n', '<leader>gH', function()
    if next(require('diffview.lib').views) == nil then
      vim.cmd 'DiffviewFileHistory'
    else
      vim.cmd 'DiffviewClose'
    end
  end, { desc = '[G]it repo [H]istory toggle' })
end

return M
