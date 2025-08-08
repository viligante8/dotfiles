# Personal Dotfiles

A modern, performance-optimized development environment setup featuring a blazing-fast shell configuration and a modular Neovim setup.

## 🚀 Quick Setup

```bash
# Clone the repository
git clone <your-repo-url> ~/.dotfiles

# Link configurations
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# Install dependencies
brew install starship fzf
```

## 📁 Repository Structure

```
~/.dotfiles/
├── .zshrc                      # Optimized Zsh configuration with Starship
├── .zshrc.secrets              # Private environment variables (gitignored)
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
│           ├── avante.lua      # AI coding assistant
│           ├── dap.lua         # Debug Adapter Protocol
│           └── ...             # 25+ other plugin configs
└── README.md                   # This file
```

## ⚡ Shell Configuration (.zshrc)

### Key Features
- **NVM with .nvmrc auto-switching**: Automatically switches Node versions
- **Comprehensive autocompletion**: AWS CLI, Terraform, Git, npm, and more
- **FZF integration**: Fuzzy finding for files and command history
- **Amazon Q integration**: Built-in AI assistant support

### Tools & Completions
- **AWS CLI**: Full autocompletion support
- **Terraform**: Command and resource completion
- **Git**: Full command completion (no aliases - using LazyGit instead)
- **Node/npm/bun**: Package and script completion
- **Tenv**: Terraform version management

## 🎨 Neovim Configuration

### Architecture
Modern Neovim setup using **Lazy.nvim** plugin manager with individual plugin files for better organization and maintainability.

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
- **Avante**: AI coding assistant for code generation and chat
- **Amazon Q**: Integrated development assistant

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
- `<leader>aa` - Open Avante chat
- `<leader>ae` - Avante edit
- `<leader>ar` - Avante refresh

**Navigation**
- `<C-h/j/k/l>` - Window navigation
- `<C-e>` - Toggle file tree
- `<leader>xx` - Toggle trouble

## 🔧 Development Workflow

### Project Structure Support
- **Automatic Node version switching** with .nvmrc files
- **Project-specific configurations** via .nvim.lua files
- **Git integration** with LazyGit and gitsigns
- **Testing support** with various test runners

## 📦 Dependencies

### Required
- **Neovim** (>= 0.9.0)
- **Git**
- **Node.js** (via NVM)
- **Starship** (`brew install starship`)
- **FZF** (`brew install fzf`)

### Optional but Recommended
- **LazyGit** (`brew install lazygit`)
- **Ripgrep** (`brew install ripgrep`) - for better grep performance
- **fd** (`brew install fd`) - for better file finding
- **Terraform** (`brew install terraform`)
- **AWS CLI** (`brew install awscli`)

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
