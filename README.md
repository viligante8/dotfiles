# Personal Dotfiles

A modern, performance-optimized development environment setup featuring a blazing-fast shell configuration and a modular Neovim setup.

## 🚀 Quick Setup

```bash
# Clone the repository
git clone <your-repo-url> ~/dev/personal/dotfiles
cd ~/dev/personal/dotfiles

# Bootstrap dependencies + symlinks (interactive)
bin/bootstrap-dotfiles

# Or preview first
bin/bootstrap-dotfiles --dry-run
```

The setup is fully config-driven:
- Shared defaults: `dotfiles.config.json`
- Per-user overrides (gitignored): `dotfiles.local.json`

### Config Examples

Shared defaults (`dotfiles.config.json`):
```json
{
  "features": {
    "editor": { "enabled": true, "command": "nvim" },
    "ai": { "enabled": true, "command": "opencode" },
    "gitUi": { "enabled": true, "command": "lazygit" },
    "database": { "enabled": true, "command": "dbdev" }
  }
}
```

Local overrides (`dotfiles.local.json`):
```json
{
  "features": {
    "editor": { "command": "emacs -nw" },
    "gitUi": { "enabled": false },
    "database": { "command": "usql" }
  }
}
```

## 📁 Repository Structure

```
dotfiles/
├── dotfiles.config.json         # Shared feature and dependency config
├── dotfiles.local.json          # Local overrides (gitignored)
├── zprofile                     # Login-shell setup (Homebrew and user bin)
├── zshrc                       # Optimized Zsh configuration with Starship
├── .zshrc.secrets              # Private environment variables (gitignored)
├── tmux.conf                   # Tmux configuration with development workflows
├── bin/dev                     # Main dev workspace launcher for current directory
├── bin/dev-worktree            # Branch-first worktree picker
├── bin/tmux-feature-drawer     # Feature-aware tmux drawer launcher
├── bin/bootstrap-dotfiles      # Feature-aware installer/bootstrap script
├── bin/dotfiles-config         # Config reader (merged shared + local)
├── bin/lib/tmux-session-lib.sh # Shared tmux session layout helpers
├── opencode/                   # AI CLI configuration (linked to ~/.config/opencode)
├── nvim/                       # Neovim configuration
│   ├── init.lua                # Main entry point
│   ├── lazy-lock.json          # Plugin version lockfile
│   └── lua/
│       ├── config/             # Core Neovim configuration
│       │   ├── options.lua     # Vim settings and options
│       │   ├── keymaps.lua     # Global keymaps
│       │   └── autocmds.lua    # Autocommands
│       └── plugins/            # Individual plugin configurations
│           ├── lsp.lua         # Language Server Protocol setup
│           ├── telescope.lua   # Fuzzy finder configuration
│           ├── completion.lua  # Autocompletion setup
│           ├── treesitter.lua  # Syntax highlighting
│           ├── dashboard.lua   # Start screen
│           ├── script-runner.lua # Project script helper
│           ├── dap.lua         # Debug Adapter Protocol
│           └── ...             # 25+ other plugin configs
└── README.md                   # This file
```

## 🔍 PR Review Workflow

This setup includes powerful tools for efficient PR review directly in Neovim.

### Quick Start Commands

| Command | Description |
|---------|-------------|
| `<leader>gq` | Load all PR files with change stats into quickfix |
| `<leader>gd` | Browse PR files interactively with Telescope |
| `<leader>gs` | View git status (all changed files) |
| `<leader>gc` | Browse commits with preview |

### Complete PR Review Workflow

#### 1. **Get Overview of Changes**
```vim
<leader>gq  " Loads quickfix with: src/file.ts |1| +42 -8
```
This shows all changed files with line addition/deletion stats, helping you prioritize review.

#### 2. **Navigate Through Files**
In the quickfix window:
- `j/k` - Move up/down through files
- `Enter` - Open file at cursor
- `o` - Open file and close quickfix list
- `<C-w><C-w>` - Switch between quickfix and file windows

#### 3. **Interactive File Browsing**
```vim
<leader>gd  " Opens Telescope with changed files
```
- `j/k` - Navigate files
- `Enter` - Open file
- `<C-v>` - Open in vertical split
- `<C-x>` - Open in horizontal split
- `<C-q>` - Send all results to quickfix

#### 4. **Review Individual Files**
- `]c` / `[c` - Jump between git hunks (if using gitsigns)
- `<leader>gc` - View commit history for context

### BQF (Better Quickfix) Primer

BQF enhances the quickfix window with modern features:

#### Key Features
- **Preview window** - See file contents without opening
- **Fuzzy search** - Filter quickfix results
- **Better navigation** - Enhanced movement commands

#### BQF Keybinds in Quickfix Window

| Key | Action |
|-----|--------|
| `p` | Toggle preview window |
| `P` | Toggle preview window (stay in qf) |
| `<Tab>` | Toggle item selection |
| `zn` / `zN` | Create new quickfix list |
| `zf` | Fuzzy search in quickfix |
| `<C-f>` / `<C-b>` | Page down/up in preview |
| `<C-c>` | Close quickfix |

#### Advanced BQF Usage

**Filter quickfix results:**
```vim
:Cfilter pattern    " Keep only matching items
:Cfilter! pattern   " Remove matching items
```

**Example PR Review Session:**
1. `<leader>gq` - Load PR files
2. `p` - Enable preview
3. `j/k` - Navigate files, see preview
4. `zf` - Search for specific files
5. `Enter` - Open file for detailed review

### Pro Tips

- **Large PRs**: Use `<leader>gq` to see change stats, focus on files with most changes first
- **Context**: Use `<leader>gc` to understand commit history
- **File comparison**: Open files in splits with `<C-v>` from Telescope
- **Quick navigation**: Use quickfix commands `:cnext`, `:cprev` to jump between files
- **Search across PR**: Use `<leader>sg` (live grep) to search within changed files

This workflow transforms PR review from a tedious process into an efficient, keyboard-driven experience!

## ⚡ Shell Configuration (.zshrc)

### Key Features
- **NVM with .nvmrc auto-switching**: Automatically switches Node versions
- **Comprehensive autocompletion**: AWS CLI, Terraform, Git, npm, and more
- **FZF integration**: Fuzzy finding for files and command history
- **Opencode-ready PATH setup**: Uses `~/.opencode/bin` when installed

### Tools & Completions
- **AWS CLI**: Full autocompletion support
- **Terraform**: Command and resource completion
- **Git**: Full command completion (no aliases - using LazyGit instead)
- **Node/npm/bun**: Package and script completion
- **Tenv**: Terraform version management

## 🎨 Neovim Configuration

### Philosophy: Custom LazyVim-Inspired Setup

This is a **custom Neovim configuration** inspired by [LazyVim](https://lazyvim.org) but built from the ground up for complete control and transparency. 

**Why custom instead of LazyVim?**
- 🎯 **Full control**: Every plugin and setting is explicit and customizable
- 🔍 **Transparency**: No hidden configurations or magic - you see exactly what's loaded
- ⚡ **Performance**: Only the features you actually use, no bloat
- 🛠️ **Maintainability**: Individual plugin files make debugging and modifications easier
- 🎨 **Aesthetics**: Preserves LazyVim's beautiful UI (dashboard, noice, etc.) without the framework overhead

### Architecture
Modern Neovim setup using **Lazy.nvim** plugin manager with individual plugin files for better organization and maintainability. Each plugin is configured in its own file, making the setup modular and easy to understand.

### Core Features

#### 🎯 Language Support
- **LSP Integration**: Full Language Server Protocol support
- **Autocompletion**: Fast completion with blink.cmp
- **Syntax Highlighting**: TreeSitter for accurate highlighting
- **Code Formatting**: Conform.nvim with multiple formatters
- **Debugging**: DAP (Debug Adapter Protocol) support

#### 🔍 Navigation & Search
- **Telescope**: Fuzzy finder for files, symbols, and more
- **Neo-tree**: Modern file explorer
- **Which-key**: Interactive keybinding hints
- **Trouble**: Beautiful diagnostics and quickfix lists

#### 🤖 AI Integration
- **Tmux-driven workflow**: AI opens in tmux `ai` window
- **Configurable command**: Set `features.ai.command` in `dotfiles.config.json`
- **Local override support**: Override per-machine in `dotfiles.local.json`

#### 🛠️ Development Tools
- **LazyGit**: Terminal UI for Git operations
- **Terminal**: Integrated terminal management
- **Script Runner**: Custom plugin for running project scripts
- **Session Management**: Automatic session persistence

#### 🎨 UI & Aesthetics
- **Kanagawa**: Beautiful colorscheme
- **Lualine**: Customizable statusline
- **Bufferline**: Enhanced buffer/tab management
- **Dashboard**: Personalized start screen
- **Noice**: Enhanced UI for messages and notifications

### Key Keymaps

#### Leader Key: `<Space>`

**File Operations**
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>w` - Save file

**LSP & Coding**
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer

**Git**
- `<leader>gg` - Open LazyGit
- `<leader>gs` - Git status
- `<leader>gb` - Git blame

**AI Assistant**
- AI is launched from tmux via `M-space Q`
- Command is configurable in `dotfiles.config.json` (`features.ai.command`)

**Navigation**
- `<C-h/j/k/l>` - Window navigation
- `<C-e>` - Toggle file tree
- `<leader>xx` - Toggle trouble

## 📊 Configuration Comparison

### Custom vs LazyVim vs Kickstart.nvim

| Feature | This Setup | LazyVim | Kickstart.nvim |
|---------|------------|---------|----------------|
| **Philosophy** | LazyVim-inspired, full control | Opinionated distribution | Minimal starting point |
| **Plugin Count** | ~25 explicit plugins | 50+ plugins (many hidden) | ~8 essential plugins |
| **Startup Time** | Fast (lazy loading) | Fast (lazy loading) | Fastest (minimal) |
| **Transparency** | ✅ Every plugin visible | ❌ Many plugins hidden | ✅ Everything explicit |
| **Customization** | ✅ Full control | ⚠️ Limited without overrides | ✅ Full control |
| **Maintenance** | ✅ Individual files | ❌ Framework updates | ✅ Manual updates |
| **Learning Curve** | Medium | Low | High |

### Feature Matrix

| Feature | This Setup | LazyVim | Kickstart.nvim |
|---------|:----------:|:-------:|:--------------:|
| **LSP Integration** | ✅ | ✅ | ✅ |
| **Autocompletion** | ✅ blink.cmp | ✅ nvim-cmp | ✅ nvim-cmp |
| **Fuzzy Finding** | ✅ Telescope | ✅ Telescope | ✅ Telescope |
| **File Explorer** | ✅ Neo-tree | ✅ Neo-tree | ❌ |
| **Git Integration** | ✅ LazyGit + gitsigns | ✅ LazyGit + gitsigns | ✅ gitsigns only |
| **Debugging (DAP)** | ✅ | ✅ | ❌ |
| **Testing** | ✅ Neotest | ✅ Neotest | ❌ |
| **AI Integration** | ✅ tmux + configurable CLI | ✅ Copilot/Codeium/Supermaven | ❌ |
| **Beautiful UI** | ✅ Dashboard + Noice | ✅ Dashboard + Noice | ❌ |
| **Terminal** | ✅ Integrated | ✅ Integrated | ❌ |
| **Session Management** | ✅ Persistence | ✅ Persistence | ❌ |
| **Keybinding Hints** | ✅ Which-key | ✅ Which-key | ❌ |
| **Statusline** | ✅ Lualine | ✅ Lualine | ❌ |
| **Buffer Management** | ✅ Bufferline | ✅ Bufferline | ❌ |
| **Code Formatting** | ✅ Conform | ✅ Conform | ✅ |
| **Syntax Highlighting** | ✅ Treesitter | ✅ Treesitter | ✅ |

### Why This Approach?

**Advantages over LazyVim:**
- 🔍 **Complete transparency**: See exactly what's installed and configured
- 🎛️ **Granular control**: Modify any aspect without fighting the framework
- 📚 **Learning opportunity**: Understand how each piece works
- 🎨 **Aesthetic preservation**: Keep the beautiful UI without the hidden complexity
- ⚡ **Performance**: Only load what you actually need
- 🤖 **Configurable AI CLI**: Change tools without rewriting tmux workflows

**Advantages over Kickstart.nvim:**
- 🎨 **Rich UI**: Beautiful dashboard, notifications, and interface elements
- 🛠️ **Feature complete**: Debugging, testing, AI integration out of the box
- 💼 **Professional setup**: Ready for serious development work
- 🔧 **Advanced tooling**: Git UI, terminal integration, session management

**Trade-offs:**
- More complex than kickstart.nvim (but still manageable)
- Requires more maintenance than LazyVim (but gives you control)
- Larger plugin count than minimal setups (but each serves a purpose)

## 🔧 Development Workflow

### Custom Plugin Development
This setup is a testing ground for custom Neovim tooling, including `script-runner.nvim`.
The plugin flow is modular, with one plugin config per file under `nvim/lua/plugins`.

### Project Structure Support
- **Automatic Node version switching** with .nvmrc files
- **Project-specific configurations** via .nvim.lua files
- **Git integration** with LazyGit and gitsigns
- **Testing support** with various test runners

## 📦 Dependencies

Dependencies are installed by feature selection in `bin/bootstrap-dotfiles`.

- Every dependency is declared at feature level in `features.<name>.dependencies`.
- If a feature is disabled, its dependencies are not installed and its tmux window is not created.
- The `ai` feature installs `opencode` and links the `opencode` config directory.

Common examples:
- `editor` feature: `neovim`, `ripgrep`, `fd`
- `gitUi` feature: `lazygit`
- `database` feature: `pgcli`

### Platform-Specific Notes
- **macOS**: Uses Homebrew paths (`/opt/homebrew` for Apple Silicon, `/usr/local` for Intel)
- **Linux**: Installer supports `apt` and `pacman`
- **NVM**: Auto-detects installation method (Homebrew/Linuxbrew vs standard install script)
- **Clipboard**: Uses `pbcopy` on macOS, `xclip` or `xsel` on Linux

## 🎯 Design Philosophy

### Developer Experience
- **Comprehensive autocompletion**: Tab completion everywhere possible
- **Modern tooling**: Latest and greatest development tools
- **AI Integration**: Built-in AI assistance for coding tasks

### Maintainability
- **Modular configuration**: Easy to modify and extend
- **Clear organization**: Each plugin in its own file
- **Documentation**: Well-documented keymaps and configurations

### Neovim Startup
- **Lazy loading**: Plugins load on-demand
- **Optimized rtp**: Disabled unnecessary runtime plugins
- **Fast completion**: Blink.cmp for sub-millisecond completion

## 🛠️ Customization

### Adding New Plugins
1. Create a new file in `lua/plugins/`
2. Follow the existing pattern with proper lazy loading
3. Add keymaps and configuration as needed

### Modifying Shell Behavior
- Edit `.zshrc` for shell configuration
- Add private variables to `.zshrc.secrets`
- Customize Starship prompt with `~/.config/starship.toml`

### Extending Neovim
- Add new plugins in `lua/plugins/`
- Modify keymaps in `lua/config/keymaps.lua`
- Adjust options in `lua/config/options.lua`

## 📝 Notes

- **Secrets management**: Private environment variables in `.zshrc.secrets`
- **Cross-platform**: Configurations work on macOS and Linux
- **Regular updates**: Plugin versions locked but regularly updated
- **Community driven**: Based on best practices from the Neovim community
