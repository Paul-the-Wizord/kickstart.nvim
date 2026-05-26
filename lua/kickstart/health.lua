--[[
--
-- This file is not required for your own configuration,
-- but helps people determine if their system is setup correctly.
--
--]]

local check_version = function()
  local verstr = tostring(vim.version())
  if not vim.version.ge then
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
    return
  end

  if vim.version.ge(vim.version(), '0.12') then
    vim.health.ok(string.format("Neovim version is: '%s'", verstr))
  else
    vim.health.error(string.format("Neovim out of date: '%s'. Upgrade to latest stable or nightly", verstr))
  end
end

local function check_executables(group_name, executables)
  vim.health.info(group_name)

  for _, exe in ipairs(executables) do
    if vim.fn.executable(exe) == 1 then
      vim.health.ok(string.format("Found executable: '%s'", exe))
    else
      vim.health.warn(string.format("Could not find executable: '%s'", exe))
    end
  end
end

local check_external_reqs = function()
  check_executables('Basic utilities used by this config:', { 'git', 'make', 'unzip', 'rg' })
  check_executables('LSP servers configured in native LSP setup:', { 'lua-language-server', 'terraform-ls', 'ty' })
  check_executables('Formatters and linters configured in this config:', {
    'stylua',
    'ruff',
    'prettier',
    'shfmt',
    'markdownlint',
  })
end

return {
  check = function()
    vim.health.start 'kickstart.nvim'

    vim.health.info [[NOTE: Not every warning is a 'must-fix' in `:checkhealth`

  Fix only warnings for plugins and languages you intend to use.
    External tools and language servers are managed outside Neovim in this config.
    You only need to install tools for languages you actually use.
    Some checks below are optional depending on your workflow.]]

    local uv = vim.uv
    vim.health.info('System Information: ' .. vim.inspect(uv.os_uname()))

    check_version()
    check_external_reqs()
  end,
}
