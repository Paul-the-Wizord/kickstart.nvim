# kickstart.nvim

## Introduction

A modular Neovim configuration built on **Neovim 0.12+** native APIs — no plugin manager required. Uses `vim.pack` for plugin installation, native LSP via `vim.lsp.config()`/`vim.lsp.enable()`, and native autocomplete with `'autocomplete'`.

**NOT** a Neovim distribution, but a starting point for your own configuration, forked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and restructured into a modular layout.

## Features

- **Native package management** — `vim.pack.add()` with pinned revisions and `nvim-pack-lock.json` lockfile
- **Native LSP** — `vim.lsp.config()` + `vim.lsp.enable()` for Lua, Terraform, and Python
- **Native autocomplete** — `'autocomplete'` + `'complete'` with `o` (omnifunc from LSP)
- **Hybrid Treesitter** — native highlighting for bundled languages (`c`, `lua`, `markdown`, `vim`, `vimdoc`), `nvim-treesitter` for additional languages
- **Format on save** — via `conform.nvim` (stylua, ruff, prettier, shfmt)
- **Linting** — `nvim-lint` with markdownlint
- **Fuzzy finder** — Telescope with fzf-native and ui-select extensions
- **Git integration** — Gitsigns (inline signs + blame), Diffview (diff/file history)
- **File explorer** — nvim-tree with git status
- **Note-taking** — Obsidian.nvim with Telescope picker
- **Terminal management** — Toggle terminal splits + floating/right-split agent terminals (default: `opencode`)
- **Jira integration** — Mirror sync + Telescope search + agent terminal (requires `jira-markdown-mirror`)
- **UI** — Rose Pine colorscheme, which-key, todo-comments, mini.ai/surround/statusline, nvim-web-devicons

## Directory Structure

```
init.lua                          # Module loader (loads all modules in order)
lua/kickstart/
  core/
    options.lua                   # Editor options + shell from user_config
    keymaps.lua                   # Core keymaps (diagnostics, window nav, terminal escape)
    autocmds.lua                  # Autocmds (yank highlight, autoread, spellcheck, terminal)
  plugins/
    spec.lua                      # vim.pack.add() plugin spec with pinned revisions
    ui.lua                        # Colorscheme, which-key, guess-indent, todo-comments, mini.*
    search.lua                    # Telescope setup + search keymaps
    git.lua                       # Gitsigns + Diffview setup + keymaps
    files.lua                     # nvim-tree setup + keymaps
    notes.lua                     # Obsidian.nvim setup
    lint.lua                      # nvim-lint setup (markdownlint)
  native/
    completion.lua                # Native completion (autocomplete, complete, completeopt)
    lsp.lua                       # Native LSP configs (lua_ls, terraformls, ty)
    formatting.lua                # conform.nvim formatters
    treesitter.lua                # Hybrid native + nvim-treesitter
  features/
    terminal.lua                  # Toggle terminal split
    agent.lua                     # Floating/right-split agent terminal windows
    jira.lua                      # Jira markdown mirror sync + Telescope pickers
  user_config.lua                 # Centralized user-configurable values
  health.lua                      # :checkhealth (version + external tool checks)
```

## Requirements

- **Neovim 0.12+** (required — uses `vim.pack`, native LSP, `'autocomplete'`)
- **Git** — for `vim.pack` plugin management
- **Make** + **C compiler** — for building `telescope-fzf-native.nvim`
- **[ripgrep](https://github.com/BurntSushi/ripgrep)** — Telescope grep pickers
- **[fd](https://github.com/sharkdp/fd)** — Telescope file finders
- **A [Nerd Font](https://www.nerdfonts.com/)** — optional, for icons (set `vim.g.have_nerd_font = true` in `options.lua`)
- **Clipboard tool** — xclip/xsel (Linux X11), wl-clipboard (Wayland), or platform default

### LSP Servers (install only for languages you use)

| Server | Language | Install |
| :- | :- | :-- |
| `lua-language-server` | Lua | `pacman -S lua-language-server` / `brew install lua-language-server` |
| `terraform-ls` | Terraform | [HashiCorp releases](https://developer.hashicorp.com/terraform/language-tools) |
| `ty` | Python | `curl -LsSf https://astral.sh/ty/install.sh \| sh` |

### Formatters & Linters (install only for languages you use)

| Tool | Language | Install |
| :- | :- | :-- |
| `stylua` | Lua | `cargo install stylua` or distro package |
| `ruff` | Python | `uv tool install ruff` or `pipx install ruff` |
| `prettier` | Markdown/JS/HTML | `npm install -g prettier` |
| `shfmt` | Shell | `go install mvdan.cc/sh/v3/cmd/shfmt@latest` or distro package |
| `markdownlint` | Markdown | `npm install -g markdownlint-cli` |

## Installation

### 1. Install Neovim 0.12+

<details><summary>macOS (Homebrew)</summary>

```sh
brew install neovim
```

</details>

<details><summary>Arch Linux</summary>

```sh
sudo pacman -S neovim
```

</details>

<details><summary>Ubuntu / Debian</summary>

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update && sudo apt install neovim
```

Note that the package managers lack behind the most current version and might still serve <= 0.11. For the most recent version download the most current version from GitHub:

```sh
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo mkdir -p /opt/nvim-linux-x86_64
sudo chmod a+rX /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/
```

</details>

<details><summary>Fedora</summary>

```sh
sudo dnf install -y neovim
```

</details>

<details><summary>mise (cross-platform)</summary>

```sh
mise plugins install neovim
mise use neovim@stable
```

</details>

<details><summary>Bob (cross-platform)</summary>

```sh
cargo install bob-nvim
bob use stable
```

</details>

Verify: `nvim --version` should report **0.12.0** or higher.

### 2. Install external dependencies

```sh
# macOS
brew install ripgrep fd make

# Arch
sudo pacman -S ripgrep fd make

# Ubuntu/Debian
sudo apt install ripgrep fd-find make
```

Install only the LSP servers and formatters you need (see tables above).

### 3. Clone this config

> [!IMPORTANT]
> Back up any existing Neovim config first:
> `mv ~/.config/nvim ~/.config/nvim.bak && mv ~/.local/share/nvim ~/.local/share/nvim.bak`

```sh
git clone https://github.com/<your-username>/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

### 4. Start Neovim

```sh
nvim
```

On first launch, `vim.pack` will download and install all pinned plugins automatically. The `telescope-fzf-native.nvim` native extension will also be built via `make` if available.

### 5. Verify

Run inside Neovim:

```vim
:checkhealth
:checkhealth vim.lsp
```

Fix any warnings for tools you intend to use. Not every warning is critical — only install tools for languages you actually work with.

## Updating Plugins

```vim
:lua vim.pack.update()
```

Review the update buffer, then `:write` to confirm or `:quit` to cancel. The lockfile (`nvim-pack-lock.json`) is tracked in git, so you can review changes before committing.

## Keymaps

| Key | Mode | Action |
| :-: | :-: | :-- |
| `<Space>` | — | Leader key |
| `<leader>t` | n | Toggle terminal split |
| `<leader>ar` | n | Toggle agent right split |
| `<leader>aa` | n | Toggle agent floating window |
| `<leader>e` | n | Toggle file explorer (nvim-tree) |
| `<leader>fe` | n | Focus file explorer |
| `<leader>gl` | n | Toggle git blame (gitsigns) |
| `<leader>gd` | n | Toggle git diff (diffview) |
| `<leader>gh` | n | Toggle git file history (diffview) |
| `<leader>gH` | n | Toggle git repo history (diffview) |
| `<leader>gc` | n | Git commits for current file (Telescope) |
| `<leader>gC` | n | Git commits for repo (Telescope) |
| `<leader>gb` | n | Git branches (Telescope) |
| `<leader>sf` | n | Search files (Telescope) |
| `<leader>sg` | n | Live grep (Telescope) |
| `<leader>sw` | n/v | Search current word (Telescope) |
| `<leader>sc` | n | Live grep with file glob filter |
| `<leader>sh` | n | Search help tags |
| `<leader>sk` | n | Search keymaps |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sn` | n | Search Neovim config files |
| `<leader>s.` | n | Search recent files |
| `<leader><leader>` | n | Find existing buffers |
| `<leader>q` | n | Open diagnostic quickfix list |
| `<leader>d` | n | Open diagnostic float |
| `<leader>ju` | n | Jira mirror sync |
| `<leader>jf` | n | Jira find files |
| `<leader>jg` | n | Jira grep |
| `<leader>ja` | n | Jira agent terminal |
| `grr` | n | Go to references (LSP) |
| `gri` | n | Go to implementation (LSP) |
| `grd` | n | Go to definition (LSP) |
| `grn` | n | Rename (LSP) |
| `gra` | n/x | Code action (LSP) |
| `grD` | n | Go to declaration (LSP) |
| `gO` | n | Document symbols (LSP) |
| `<Esc>` | n | Clear search highlight |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-h/j/k/l>` | n | Navigate windows |

## Customization

### User config

Edit `lua/kickstart/user_config.lua` to change:

- `terminal.shell` — shell used by Neovim (`$SHELL` by default, falls back to `/bin/bash`)
- `terminal.split` — split command for the toggle terminal (`botright 15split`)
- `terminal.height` — terminal split height
- `agent.command` — command launched in agent terminal windows (`opencode` by default)
- `agent.right_width` — width of the agent right split (60 by default)

### Adding plugins

1. Add an entry to `vim.pack.add(...)` in `lua/kickstart/plugins/spec.lua` with a pinned `version` (commit SHA)
2. Add setup code in the appropriate module under `lua/kickstart/plugins/` (or create a new one)

### Adding LSP servers

1. Define with `vim.lsp.config('<name>', { ... })` in `lua/kickstart/native/lsp.lua`
2. Enable with `vim.lsp.enable('<name>')` in the same file
3. Add the executable to the health check in `lua/kickstart/health.lua`

### Parallel configs

Use `NVIM_APPNAME` to run multiple Neovim configurations side by side:

```sh
# Install in an alternative directory
git clone https://github.com/<you>/kickstart.nvim.git ~/.config/nvim-myconfig

# Run with the alternative config
NVIM_APPNAME=nvim-myconfig nvim
```

## FAQ

- **What if I already have a Neovim config?** Back it up, then remove `~/.config/nvim` and `~/.local/share/nvim`.
- **How do I uninstall?** Remove `~/.config/nvim` and `~/.local/share/nvim`.
- **Plugins aren't installing?** Ensure Neovim 0.12+ and Git are available. Run `:checkhealth`.
- **LSP isn't attaching?** Install the relevant language server and run `:checkhealth vim.lsp`.
- **Completion isn't working?** This config uses native `'autocomplete'`. No completion plugin is needed.

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "%localappdata%\nvim"
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git "${env:LOCALAPPDATA}\nvim"
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Neovim will install plugins declared via `vim.pack.add(...)`.
You can update plugins with `:lua vim.pack.update()`.
