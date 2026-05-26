# Neovim 0.12 Migration Agent Guide

This repository uses this file (`AGENTS.md`) as the single source of truth for migration behavior.

## Scope

- Target Neovim: `0.12+`
- Package management: native `vim.pack` (no `lazy.nvim`)
- LSP + autocomplete: native Neovim APIs (no LSP/completion plugins)
- Treesitter: hybrid setup (`vim.treesitter` for bundled parsers + `nvim-treesitter` for additional parsers)

## Authoritative References

- Neovim 0.12 changes: <https://neovim.io/doc/user/news-0.12/>
- Neovim deprecations: <https://neovim.io/doc/user/deprecated/#deprecated-0.12>
- Native package manager: <https://neovim.io/doc/user/pack/#vim.pack>
- Native LSP framework: <https://neovim.io/doc/user/lsp/>

## Decisions For This Repo

1. Use only `AGENTS.md` (do not create `AGENT.md`).
2. Use `vim.pack.add(...)` for plugin install/load.
3. Pin plugin revisions during migration to reduce breakage.
4. Use native LSP via `vim.lsp.config()` + `vim.lsp.enable()`.
5. Use native autocomplete with `'autocomplete'` + `'complete'` including `o`.
6. Do not enable two auto-completion providers at once.
7. Keep native Treesitter highlighting for bundled languages and use `nvim-treesitter` for non-bundled languages.

## Current Implementation

- `init.lua`
  - module loader only
  - loads `core`, `plugins`, `native`, and `features` modules in order
- `lua/kickstart/core/*`
  - `options.lua`: general editor options + shell option from `user_config`
  - `keymaps.lua`: core keymaps
  - `autocmds.lua`: generic autocmds (yank highlight, autoread, spellcheck, terminal number toggles)
- `lua/kickstart/plugins/*`
  - `spec.lua`: `vim.pack.add(...)` plugin spec with pinned revisions
  - `ui.lua`, `search.lua`, `git.lua`, `files.lua`, `notes.lua`, `lint.lua`: plugin setup by concern
  - Telescope prompt disables `'autocomplete'` buffer-locally for `TelescopePrompt`
- `lua/kickstart/native/*`
  - `completion.lua`: native completion (`autocomplete`, `complete`, `completeopt`)
  - `lsp.lua`: native LSP configs (`lua_ls`, `terraformls`, `ty`) + `vim.lsp.enable(...)`
  - `formatting.lua`: conform formatters
  - `treesitter.lua`: hybrid native Treesitter + `nvim-treesitter`
- `lua/kickstart/features/*`
  - `terminal.lua`: internal terminal toggle behavior
  - `agent.lua`: right/floating agent terminal windows
  - `jira.lua`: Jira markdown mirror sync + telescope pickers
- `lua/kickstart/user_config.lua`
  - centralized user-configurable values (`terminal.*`, `agent.*`)
- `lua/kickstart/plugins/lint.lua`
  - converted from lazy spec to plain `setup()` module
- `lua/kickstart/health.lua`
  - minimum version check raised to `0.12`
  - checks configured external executables (basic tools, LSP servers, formatters/linters)
- `.gitignore`
  - removed `lazy-lock.json` ignore rule
- `nvim-pack-lock.json`
  - tracked lockfile for `vim.pack`

## Native LSP + Completion Rules

- Preferred completion flow in this repo:
  - builtin insert completion with `'autocomplete'`
  - LSP comes through `omnifunc` source (`o` in `'complete'`)
- Avoid combining both of these at the same time for autotrigger:
  - `vim.lsp.completion.enable(..., { autotrigger = true })`
  - `'autocomplete'`-driven completion

If `vim.lsp.completion.enable()` is used later, keep it intentional and ensure it does not create duplicate auto providers.

## External Tooling Expectations

Because Mason was removed, server/tool binaries must be installed externally (system package manager, mise, asdf, npm/pipx, etc.).

Expected executables used by current config:

- LSP servers: `lua-language-server`, `terraform-ls`, `ty`
- Formatting/linting: `stylua`, `ruff`, `prettier`, `shfmt`, `markdownlint`
- Plugin build helper: `make` (for `telescope-fzf-native.nvim`)

Treesitter parser note:

- Neovim bundles parsers for: `c`, `lua`, `markdown`, `vim`, `vimdoc`
- Additional languages are managed via `nvim-treesitter` (`:TSInstall`, `:TSUpdate`, or `ensure_installed`)

## Update Workflow

1. Start Neovim (`0.12+`) so `vim.pack` installs pinned plugins.
2. Review/upgrade plugins:
   - `:lua vim.pack.update()`
   - confirm update buffer with `:write` or cancel with `:quit`
3. Run health checks:
   - `:checkhealth`
   - `:checkhealth vim.lsp`
4. Validate core behavior:
   - Telescope opens and searches
   - LSP attaches in Lua and Terraform buffers
   - Python LSP (`ty`) attaches in Python buffers
   - completion menu appears while typing
   - format-on-save still works

## 0.12 Compatibility Audit Checklist

Search config for removed/deprecated patterns and migrate if found:

- `vim.diagnostic.disable()` / `vim.diagnostic.is_disabled()`
- legacy `vim.diagnostic.enable(buf, namespace)` signatures
- `vim.diff(...)` (use `vim.text.diff(...)`)
- `vim.lsp.semantic_tokens.start()/stop()` (use `enable()`)
- diagnostics sign setup via `sign_define()` for diagnostic signs
- old LSP helpers: `vim.lsp.set_log_level`, `vim.lsp.get_log_path`, `vim.lsp.stop_client`, etc.

## Notes For Future Edits

- Prefer native APIs first; add plugins only when native behavior is insufficient.
- Keep lockfile (`nvim-pack-lock.json`) under version control once generated.
- If adding new LSP servers, define them with `vim.lsp.config('<name>', {...})` and enable with `vim.lsp.enable('<name>')`.
