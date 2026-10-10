local M = {}

function M.setup()
  local builtin = require 'telescope.builtin'

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('telescope-lsp-attach', { clear = true }),
    callback = function(event)
      local buf = event.buf
      vim.keymap.set('n', 'grr', builtin.lsp_references, { buffer = buf, desc = '[G]oto [R]eferences' })
      vim.keymap.set('n', 'gri', builtin.lsp_implementations, { buffer = buf, desc = '[G]oto [I]mplementation' })
      vim.keymap.set('n', 'grd', builtin.lsp_definitions, { buffer = buf, desc = '[G]oto [D]efinition' })
      vim.keymap.set('n', 'gO', builtin.lsp_document_symbols, { buffer = buf, desc = 'Open Document Symbols' })
    end,
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('gra', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- Only pull omnifunc into 'complete' once the LSP has actually taken over
      -- 'omnifunc' (see native/completion.lua for why 'o' isn't set globally).
      if client and client:supports_method('textDocument/completion', event.buf) and vim.bo[event.buf].omnifunc == 'v:lua.vim.lsp.omnifunc' then
        vim.opt_local.complete:append 'o'
      end

      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end,
  })

  vim.lsp.config('lua_ls', {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
      },
    },
  })

  vim.lsp.config('terraformls', {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars' },
    root_markers = { '.terraform', '.git' },
    init_options = {
      indexing = {
        ignoreDirectoryNames = { '.venv' },
      },
    },
    on_attach = function(client, _)
      -- Disable semantic tokens to prevent known freeze bug
      -- https://github.com/hashicorp/terraform-ls/issues/2125
      client.server_capabilities.semanticTokensProvider = nil
    end,
  })

  vim.lsp.config('ty', {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = { 'ty.toml', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
  })

  vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', '.git' },
    handlers = {
      ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
        local seen = {}
        local filtered = {}
        for _, diag in ipairs(result.diagnostics) do
          local key = table.concat({
            diag.range.start.line,
            diag.range.start.character,
            diag.message,
          }, ':')
          if not seen[key] then
            seen[key] = true
            filtered[#filtered + 1] = diag
          end
        end
        result.diagnostics = filtered
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
      end,
    },
  })

  vim.lsp.config('ts_ls', {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
    root_markers = { 'tsconfig.json', 'package.json', '.git' },
  })

  vim.lsp.config('angularls', {
    cmd = { 'ngserver', '--stdio', '--tsProbeLocations', vim.fn.getcwd(), '--ngProbeLocations', vim.fn.getcwd() },
    filetypes = { 'typescript', 'html', 'typescriptreact' },
    root_markers = { 'angular.json' },
  })

  vim.lsp.enable { 'lua_ls', 'terraformls', 'ty', 'rust_analyzer', 'ts_ls', 'angularls' }
end

return M
