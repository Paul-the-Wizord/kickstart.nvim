local M = {}

function M.setup()
  local telescope = require 'telescope'
  local builtin = require 'telescope.builtin'

  telescope.setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  pcall(telescope.load_extension, 'fzf')
  pcall(telescope.load_extension, 'ui-select')

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('kickstart-telescope-prompt', { clear = true }),
    pattern = 'TelescopePrompt',
    callback = function()
      vim.bo.autocomplete = false
    end,
  })

  vim.keymap.set('n', '<leader>gc', builtin.git_bcommits, { desc = '[G]it [C]ommits (file)' })
  vim.keymap.set('n', '<leader>gC', builtin.git_commits, { desc = '[G]it [C]ommits (repo)' })
  vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[G]it [B]ranches' })

  vim.keymap.set('n', '<leader>sc', function()
    vim.ui.input({ prompt = 'File glob (empty = all): ' }, function(glob)
      local opts = {}
      if glob and glob ~= '' then opts.glob_pattern = glob end
      builtin.live_grep(opts)
    end)
  end, { desc = '[S]earch [C]ombined (grep + file filter)' })

  vim.keymap.set('n', '<leader>sC', function()
    vim.ui.input({ prompt = 'File glob (empty = all): ' }, function(glob)
      local opts = {
        additional_args = function() return { '--hidden', '--no-ignore' } end,
      }
      if glob and glob ~= '' then opts.glob_pattern = glob end
      builtin.live_grep(opts)
    end)
  end, { desc = '[S]earch [C]ombined (grep + file filter, hidden)' })

  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sF', function() builtin.find_files { hidden = true, no_ignore = true } end, { desc = '[S]earch [F]iles (hidden)' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sG', function()
    builtin.live_grep { additional_args = function() return { '--hidden', '--no-ignore' } end }
  end, { desc = '[S]earch by [G]rep (hidden)' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', hidden = true } end, { desc = '[S]earch [N]eovim files' })
end

return M
