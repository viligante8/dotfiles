# Plugin Configuration Organization

This directory contains a well-organized structure with **individual Lua files for each plugin**, organized into logical folders for easy navigation and maintenance.

## 📁 Folder Structure

```
lua/plugins/
├── ui/                    # UI-related plugins (colorschemes, statusline, etc.)
├── editor/                # Editor enhancements (telescope, treesitter, etc.)
├── coding/                # Coding tools (LSP, completion, etc.)
└── tools/                 # Additional tools (git, testing, etc.)
```

## 🎨 UI Plugins (`ui/`)

- **`kanagawa.lua`** - Colorscheme configuration
- **`nvim-tree.lua`** - File explorer
- **`which-key.lua`** - Keybinding hints
- **`nvim-web-devicons.lua`** - Icons
- **`mini.lua`** - Mini.nvim collection (statusline, textobjects, etc.)
- **`bqf.lua`** - Better quickfix window
- **`fzf.lua`** - FZF fuzzy finder support

## ✏️ Editor Plugins (`editor/`)

- **`telescope.lua`** - Fuzzy finder and file picker
- **`treesitter.lua`** - Syntax highlighting and parsing
- **`gitsigns.lua`** - Git integration and indicators
- **`autopairs.lua`** - Automatic bracket pairing
- **`comment.lua`** - Comment toggling
- **`nvim-surround.lua`** - Surround text objects
- **`indent-blankline.lua`** - Indent guides
- **`guess-indent.lua`** - Automatic indentation detection

## 💻 Coding Plugins (`coding/`)

- **`lsp.lua`** - Language Server Protocol configuration
- **`blink-cmp.lua`** - Completion engine
- **`conform.lua`** - Code formatting
- **`nvim-lint.lua`** - Linting
- **`lazydev.lua`** - Lua development tools
- **`typescript-tools.lua`** - TypeScript tooling

## 🛠️ Tools Plugins (`tools/`)

- **`lazygit.lua`** - Git TUI integration
- **`neotest.lua`** - Testing framework
- **`dap.lua`** - Debugging support
- **`dadbod.lua`** - Database UI
- **`repl.lua`** - REPL integration
- **`gp.lua`** - AI chat assistant
- **`persistence.lua`** - Session management
- **`todo-comments.lua`** - TODO highlighting

## 🚀 Usage Examples

Now you can easily find and edit any specific plugin configuration:

```bash
# Edit telescope configuration
nvim ~/.dotfiles/nvim/lua/plugins/editor/telescope.lua

# Modify colorscheme settings
nvim ~/.dotfiles/nvim/lua/plugins/ui/kanagawa.lua

# Update LSP configuration
nvim ~/.dotfiles/nvim/lua/plugins/coding/lsp.lua

# Configure debugging
nvim ~/.dotfiles/nvim/lua/plugins/tools/dap.lua
```

## ✨ Benefits

- **🔍 Easy to find**: Logical folder organization
- **📝 Easy to edit**: Each plugin has its own file
- **🔧 Easy to maintain**: No massive files to navigate
- **📚 Easy to understand**: Clear separation of concerns
- **🚀 Easy to extend**: Just add new `.lua` files

All plugins are automatically loaded by Lazy.nvim when you start Neovim. The folder structure provides organization while individual files provide specificity!
