# 🚀 Development Environment Keymaps & Commands

## Tmux Keymaps (Prefix: `M-space`)

### 📋 Quick Reference
Press `M-space` then `?` to see tmux's built-in key list/help.

### 🏗️ Development Workflows
| Key | Action | Description |
|-----|--------|-------------|
| `M-space W` | **Project Picker** | Open `dev` project picker in a popup |
| `M-space B` | **Branch Worktree** | Pick/type branch and create/switch worktree |
| `M-space V` | **Editor Drawer** | Open/switch to configured editor window command |
| `M-space Q` | **AI Drawer** | Open/switch to configured AI window command |
| `M-space G` | **Git Drawer** | Open/switch to configured Git UI window command |
| `M-space D` | **Dev Layout** | Create 3-pane layout (nvim + 2 terminals) |

**Session Layout:**
`dev` picker session:
- Window 1: `editor` (configured command, default `nvim`)
- Window 2: `terminal`
- Window 3: `ai` (configured command, default `opencode`)
- Window 4: `git` (configured command, default `lazygit`)
- Window 5: `dbdev` (pre-types `dbdev`)

`dev-session`:
- Window 1: `editor` (configured command, default `nvim`)
- Window 2: `terminal`
- Window 3: `ai` (configured command, default `opencode`)
- Window 4: `git` (configured command, default `lazygit`)

### 🪟 Window & Pane Management
| Key | Action | Description |
|-----|--------|-------------|
| `M-space c` | **New Window** | Create window in current directory |
| `M-space \|` | **Split Horizontal** | Split pane left/right |
| `M-space -` | **Split Vertical** | Split pane top/bottom |
| `M-space h/j/k/l` | **Vim Panes** | Navigate panes (left/down/up/right) |
| `M-space H/J/K/L` | **Resize Panes** | Resize panes (hold and repeat) |

### 🧭 Navigation (No Prefix Needed)
| Key | Action | Description |
|-----|--------|-------------|
| `Alt-1..9` | **Quick Windows** | Jump directly to window 1 through 9 |
| `Alt-←/→/↑/↓` | **Quick Panes** | Navigate panes with arrow keys |
| `Alt-q` / `Alt-e` | **Session Prev/Next** | Switch tmux sessions |
| `Alt-w` | **Session Picker** | Open session chooser |
| `Alt-Shift-h/l` | **Window Prev/Next** | Previous/next window |
| `Alt-h` | **Previous Window** | Jump to previous window |

### 🛠️ Quick Tools
| Key | Action | Description |
|-----|--------|-------------|
| `M-space r` | **Reload Config** | Reload tmux configuration |
| `M-space d` | **Detach** | Detach from current session |
| `M-space s` | **List Sessions** | Show tmux sessions |
| `M-space ,` | **Rename Window** | Rename current window |

### 📋 Copy Mode (Vim-style)
| Key | Action | Description |
|-----|--------|-------------|
| `M-space [` | **Enter Copy Mode** | Start text selection |
| `v` | **Visual Select** | Start selection (in copy mode) |
| `y` | **Copy** | Copy selection to clipboard |
| `r` | **Rectangle** | Toggle rectangle selection |

---

## Neovim Keymaps (Leader: `Space`)

### 🤖 AI Assistant
| Key | Action | Description |
|-----|--------|-------------|
| *(No dedicated Neovim AI keymaps)* | **Use tmux drawer** | Use `M-space Q` to open AI drawer from tmux |

### 📁 File Operations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | **Find Files** | Fuzzy find files (Telescope) |
| `<leader>fg` | **Live Grep** | Search in files (Telescope) |
| `<leader>fb` | **Find Buffers** | Switch between open buffers |
| `<leader>w` | **Save File** | Write current buffer |
| `Ctrl-e` | **Toggle Tree** | Show/hide file explorer |

### 🔍 LSP & Coding
| Key | Action | Description |
|-----|--------|-------------|
| `gd` | **Go to Definition** | Jump to symbol definition |
| `gr` | **Go to References** | Show all references |
| `<leader>rn` | **Rename Symbol** | Rename variable/function |
| `<leader>ca` | **Code Actions** | Show available code actions |
| `<leader>f` | **Format Buffer** | Format current file |

### 🌊 Git Integration
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gg` | **Open LazyGit** | Full-screen git interface |
| `<leader>gs` | **Git Status** | Show git status |
| `<leader>gb` | **Git Blame** | Show git blame for current line |

### 🧭 Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-h/j/k/l` | **Window Navigation** | Move between Neovim windows |
| `<leader>xx` | **Toggle Trouble** | Show/hide diagnostics panel |

---

## Shell Commands & Aliases

### 🚀 Quick Development
| Command | Description |
|---------|-------------|
| `opencode` | **AI CLI** | Start AI assistant chat |
| `lazygit` | **Git UI** | Terminal-based git interface |
| `nvim` | **Neovim** | Your configured editor |

### 📦 Package Managers (Auto NVM-switching)
| Command | Description | Auto-loads NVM |
|---------|-------------|---------------|
| `npm` | Node Package Manager | ✅ |
| `yarn` | Yarn Package Manager | ✅ |
| `bun` | Bun Runtime/Package Manager | ✅ |
| `bunx` | Bun Package Runner | ✅ |
| `npx` | Node Package Runner | ✅ |
| `node` | Node.js Runtime | ✅ |

### 🔧 Version Management
| Command | Description |
|---------|-------------|
| `nvm use` | Switch Node version manually |
| `nvm list` | Show installed Node versions |
| `tenv` | Terraform version management |

---

## 💡 Pro Tips

### Tmux Workflow
1. **Start with project picker**: Use `M-space W` to pick/create project sessions
2. **Create worktree fast**: Use `M-space B` in a repo to pick/type a branch worktree
3. **Use Alt keys**: `Alt-1..9` and `Alt-arrows` work without prefix
4. **Quick drawers**: `M-space V` (editor), `M-space Q` (AI), `M-space G` (git)
5. **Development layout**: `M-space D` creates instant 3-pane setup

### Shell Optimization
- **Auto NVM switching**: Just `cd` into project directories
- **Lazy loading**: First use of `npm`/`node`/etc. loads NVM
- **Fast startup**: New shells start in ~0.2s instead of 1.6s

### Neovim Integration
- **Telescope**: `<leader>f*` for all file/search operations
- **LSP**: `g*` commands for code navigation

### Memory Aids
- **Tmux prefix**: `M-space` (Alt/Option + Space)
- **Neovim leader**: `Space` (easy to reach)
- **Project flow**: `W` picker, `B` branch worktree, `V` editor, `Q` AI, `G` git
- **Quick tools**: `r` reload config, `D` dev layout

---

## 🆘 Help Commands

| Context | Command | Description |
|---------|---------|-------------|
| **Tmux** | `M-space ?` | Show tmux key list/help |
| **Neovim** | `:WhichKey` | Show keybinding help |
| **Shell** | `opencode --help` | AI CLI help |
| **Git** | `?` (in LazyGit) | LazyGit help |

---

*This cheat sheet reflects the current dotfiles configuration.*
