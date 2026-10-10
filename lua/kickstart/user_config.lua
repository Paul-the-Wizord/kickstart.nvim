local M = {
  terminal = {
    shell = (vim.env.SHELL and vim.env.SHELL ~= '') and vim.env.SHELL or '/bin/bash',
    split = 'botright 15split',
    height = 15,
  },
  agent = {
    command = 'opencode',
  },
  llama = {
    endpoint_fim = 'http://127.0.0.1:8012/infill',
    show_info = 0, -- 0 = disabled, 1 = statusline, 2 = inline
    -- show_info = 1 overwrites the global &statusline option directly, which clobbers
    -- mini.statusline's custom render (e.g. mode indicator) until llama.vim clears it again;
    -- disabled to avoid statusbar glitches (e.g. after <Esc><Esc> in a terminal buffer)
    auto_fim = true, -- suggestions appear automatically as you type (no built-in debounce yet, upstream ggml-org/llama.vim#66); use keymap_fim_trigger to force a suggestion manually
    -- default keymap_fim_trigger is <leader>llf; since mapleader is <Space>, that creates a
    -- buffer-local Insert-mode mapping starting with Space, causing Neovim to wait
    -- 'timeoutlen' after every Space press to disambiguate. Use a non-leader key instead.
    keymap_fim_trigger = '<C-f>',
    -- default keymap_fim_accept_word is <leader>ll]; this is (re-)bound in Insert mode every
    -- time a suggestion renders, which is continuous while auto_fim = true, so Space becomes
    -- an ambiguous prefix again. Use a non-leader key here too.
    keymap_fim_accept_word = '<M-w>',
  },
}

return M
