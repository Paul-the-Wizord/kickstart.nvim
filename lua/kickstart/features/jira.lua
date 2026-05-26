local M = {}

local jira_mirror_path = '/home/paulgondolf-iso/jira'
local jira_search_cwd = jira_mirror_path .. '/.jira'
local agent = require 'kickstart.features.agent'

local function sync_jira_markdown()
  vim.notify('Jira mirror sync started…', vim.log.levels.INFO)
  vim.system({ 'uv', 'run', 'jira-markdown-mirror', '--config', 'mirror.config.json', 'sync' }, { cwd = jira_mirror_path }, function(result)
    vim.schedule(function()
      if result.code == 0 then
        vim.notify('Jira mirror sync complete', vim.log.levels.INFO)
      else
        local details = result.stderr ~= '' and result.stderr or ('Exit code: ' .. result.code)
        vim.notify('Jira mirror sync failed: ' .. details, vim.log.levels.ERROR)
      end
    end)
  end)
end

local function search_jira_find()
  require('telescope.builtin').find_files {
    prompt_title = 'Jira Files',
    cwd = jira_search_cwd,
    hidden = true,
    no_ignore = true,
  }
end

local function search_jira_grep()
  require('telescope.builtin').live_grep {
    prompt_title = 'Jira Grep',
    cwd = jira_search_cwd,
  }
end

local function open_jira_agent()
  if vim.fn.isdirectory(jira_search_cwd) == 0 then
    vim.notify('Jira directory not found: ' .. jira_search_cwd, vim.log.levels.ERROR)
    return
  end
  agent.open_float { cwd = jira_search_cwd }
end

function M.setup()
  vim.keymap.set('n', '<leader>ju', sync_jira_markdown, { desc = '[J]ira [U]pdate mirror' })
  vim.keymap.set('n', '<leader>jf', search_jira_find, { desc = '[J]ira [F]ind' })
  vim.keymap.set('n', '<leader>jg', search_jira_grep, { desc = '[J]ira [G]rep' })
  vim.keymap.set('n', '<leader>ja', open_jira_agent, { desc = '[J]ira [A]gent' })
end

return M
