local M = {}

function M.setup()
  if vim.fn.has 'nvim-0.12' == 0 then error('This config requires Neovim 0.12+') end

  vim.api.nvim_create_autocmd('PackChanged', {
    group = vim.api.nvim_create_augroup('kickstart-pack-changed', { clear = true }),
    callback = function(event)
      local data = event.data
      if data.spec.name ~= 'telescope-fzf-native.nvim' then return end
      if data.kind ~= 'install' and data.kind ~= 'update' then return end
      if vim.fn.executable 'make' ~= 1 then return end

      vim.system({ 'make' }, { cwd = data.path }, function(result)
        if result.code ~= 0 then
          vim.schedule(function()
            vim.notify('Failed to build telescope-fzf-native.nvim:\n' .. (result.stderr or ''), vim.log.levels.WARN)
          end)
        end
      end)
    end,
  })

  vim.pack.add({
    { src = 'https://github.com/NMAC427/guess-indent.nvim', version = '84a4987ff36798c2fc1169cbaff67960aed9776f' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim', version = '7c4faa3540d0781a28588cafbd4dd187a28ac6e3' },
    { src = 'https://github.com/folke/which-key.nvim', version = '3aab2147e74890957785941f0c1ad87d0a44c15a' },
    { src = 'https://github.com/nvim-lua/plenary.nvim', version = 'b9fd5226c2f76c951fc8ed5923d85e4de065e509' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '5255aa27c422de944791318024167ad5d40aad20' },
    { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', version = '6fea601bd2b694c6f2ae08a6c6fab14930c60e2c' },
    { src = 'https://github.com/nvim-telescope/telescope-ui-select.nvim', version = '6e51d7da30bd139a6950adf2a47fda6df9fa06d2' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons', version = 'd7462543c9e366c0d196c7f67a945eaaf5d99414' },
    { src = 'https://github.com/stevearc/conform.nvim', version = '086a40dc7ed8242c03be9f47fbcee68699cc2395' },
    { src = 'https://github.com/rose-pine/neovim', name = 'rose-pine', version = '9504524e5ed0e326534698f637f9d038ba4cd0ee' },
    { src = 'https://github.com/folke/todo-comments.nvim', version = '31e3c38ce9b29781e4422fc0322eb0a21f4e8668' },
    { src = 'https://github.com/echasnovski/mini.nvim', version = '9990c41f10f54f29a888d13024c9f765037bde23' },
    { src = 'https://github.com/epwalsh/obsidian.nvim', version = 'ae1f76a75c7ce36866e1d9342a8f6f5b9c2caf9b' },
    { src = 'https://github.com/sindrets/diffview.nvim', version = '4516612fe98ff56ae0415a259ff6361a89419b0a' },
    { src = 'https://github.com/nvim-tree/nvim-tree.lua', name = 'nvim-tree.lua', version = 'e1ad8b96834779b4c2674ef83be3f1a4ed007358' },
    { src = 'https://github.com/mfussenegger/nvim-lint', version = '606b823a57b027502a9ae00978ebf4f5d5158098' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = '4916d6592ede8c07973490d9322f187e07dfefac' },
  }, {
    confirm = false,
    load = true,
  })
end

return M
