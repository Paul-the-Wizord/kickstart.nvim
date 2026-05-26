local M = {}

function M.setup()
  local native_treesitter_filetypes = { 'c', 'lua', 'markdown', 'vim', 'help' }
  local native_treesitter_langs = { c = true, lua = true, markdown = true, vim = true, vimdoc = true }

  vim.api.nvim_create_autocmd('FileType', {
    pattern = native_treesitter_filetypes,
    callback = function(event)
      local lang = vim.treesitter.language.get_lang(event.match) or event.match
      if not native_treesitter_langs[lang] then return end
      local ok = vim.treesitter.language.add(lang)
      if ok then vim.treesitter.start(event.buf, lang) end
    end,
  })

  local treesitter_configs_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
  if not treesitter_configs_ok then return end

  treesitter_configs.setup {
    ensure_installed = { 'bash', 'diff', 'html', 'luadoc', 'markdown_inline', 'query' },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(lang) return native_treesitter_langs[lang] == true end,
    },
  }
end

return M
