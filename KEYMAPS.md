# 🚀 Development Environment Keymaps & Commands

## Tmux Keymaps (Prefix: `Ctrl-a`)

### 📋 Quick Reference
Press `Ctrl-a` then `?` to see tmux-which-key menu with your custom shortcuts!

### 🏗️ Project Sessions (Instant Development Environments)
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-a W` | **Workday Dev** | Create/attach workday-integrations session (4 windows) |
| `Ctrl-a C` | **Company Datastore** | Create/attach company-datastore session (4 windows) |
| `Ctrl-a T` | **Talent Transform** | Create/attach talent-transform session (4 windows) |

**Session Layout:**
- Window 1: Main (usually nvim)
- Window 2: Terminal 
- Window 3: Amazon Q (`q chat`)
- Window 4: LazyGit

### 🪟 Window & Pane Management
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-a c` | **New Window** | Create window in current directory |
| `Ctrl-a \|` | **Split Horizontal** | Split pane left/right |
| `Ctrl-a -` | **Split Vertical** | Split pane top/bottom |
| `Ctrl-a D` | **Dev Layout** | 3-pane development layout |

### 🧭 Navigation (No Prefix Needed)
| Key | Action | Description |
|-----|--------|-------------|
| `Alt-1/2/3/4` | **Quick Windows** | Jump to window 1, 2, 3, or 4 |
| `Alt-←/→/↑/↓` | **Quick Panes** | Navigate panes with arrow keys |

### 🧭 Navigation (With Prefix)
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-a h/j/k/l` | **Vim Panes** | Navigate panes (left/down/up/right) |
| `Ctrl-a H/J/K/L` | **Resize Panes** | Resize panes (hold and repeat) |

### 🛠️ Quick Tools
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-a Q` | **Amazon Q** | Open/switch to Q chat window |
| `Ctrl-a G` | **LazyGit** | Open/switch to git window |
| `Ctrl-a r` | **Reload Config** | Reload tmux configuration |

### 📋 Copy Mode (Vim-style)
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl-a [` | **Enter Copy Mode** | Start text selection |
| `v` | **Visual Select** | Start selection (in copy mode) |
| `y` | **Copy** | Copy selection to clipboard |
| `r` | **Rectangle** | Toggle rectangle selection |

---

## Neovim Keymaps (Leader: `Space`)

### 🤖 AI Assistant (Amazon Q)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>aa` | **Toggle Q Sidebar** | Open/close Amazon Q sidebar |
| `<leader>ac` | **Q with Context** | Amazon Q with current buffer context |
| `<leader>as` | **Q Simple Chat** | Simple Amazon Q chat |
| `<leader>av` | **Add to Context** | Add visual selection to Q context |

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
| `q chat` | **Amazon Q CLI** | Start AI assistant chat |
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
1. **Start with project sessions**: Use `Ctrl-a W/C/T` instead of manual setup
2. **Use Alt keys**: `Alt-1/2/3/4` and `Alt-arrows` work without prefix
3. **Quick tools**: `Ctrl-a Q` for AI, `Ctrl-a G` for git
4. **Development layout**: `Ctrl-a D` creates instant 3-pane setup

### Shell Optimization
- **Auto NVM switching**: Just `cd` into project directories
- **Lazy loading**: First use of `npm`/`node`/etc. loads NVM
- **Fast startup**: New shells start in ~0.2s instead of 1.6s

### Neovim Integration
- **Amazon Q**: Built-in AI assistance with `<leader>a*` commands
- **Telescope**: `<leader>f*` for all file/search operations
- **LSP**: `g*` commands for code navigation

### Memory Aids
- **Tmux prefix**: `Ctrl-a` (easier than `Ctrl-b`)
- **Neovim leader**: `Space` (easy to reach)
- **Project sessions**: `W`orkday, `C`ompany, `T`alent
- **Quick tools**: `Q` for AI, `G` for Git

---

## 🆘 Help Commands

| Context | Command | Description |
|---------|---------|-------------|
| **Tmux** | `Ctrl-a ?` | Show which-key menu |
| **Neovim** | `:WhichKey` | Show keybinding help |
| **Shell** | `q --help` | Amazon Q CLI help |
| **Git** | `?` (in LazyGit) | LazyGit help |

---

*This cheat sheet is automatically updated when you modify your configurations.*
