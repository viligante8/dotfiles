# Custom Neovim Configuration

A fully customizable Neovim configuration built from the ground up, taking inspiration from LazyVim but with complete control over every aspect.

## Features

### Core
- **Lazy.nvim** plugin manager
- **Modular structure** for easy customization
- **Fast startup** with lazy loading
- **Sensible defaults** that can be easily overridden

### UI
- **Kanagawa** colorscheme (beautiful and easy on the eyes)
- **Neo-tree** file explorer with proper window management
- **Lualine** statusline with git integration
- **Bufferline** for tab-like buffer management
- **Which-key** for keybinding discovery
- **Indent guides** and **notifications**

### Editor
- **Telescope** fuzzy finder with `<C-CR>` for fuzzy refine
- **Treesitter** for syntax highlighting and text objects
- **Auto pairs**, **comments**, and **surround** support
- **Git signs** in the gutter with hunk navigation

### Coding
- **LSP** with Mason for automatic server installation
- **nvim-cmp** completion with snippets
- **Conform** for formatting
- **nvim-lint** for linting
- Support for: Lua, TypeScript/JavaScript, Python, Rust, Go

### Tools
- **LazyGit** integration (`<leader>gg`)
- **ToggleTerm** floating terminal (`<C-\>`)
- **Trouble** for diagnostics and quickfix
- **Session management** with persistence
- **Todo comments** highlighting
- **Flash** for better navigation

## Key Mappings

### Leader Key: `<Space>`

#### Files & Search
- `<leader>ff` - Find files
- `<leader>fr` - Recent files  
- `<leader>fb` - Buffers
- `<leader>sg` - Live grep
- `<leader>sw` - Search word under cursor

#### Git
- `<leader>gg` - LazyGit
- `<leader>gc` - Git commits
- `<leader>gb` - Git branches
- `<leader>gs` - Git status

#### Code
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>ca` - Code actions
- `<leader>rn` - Rename
- `<leader>f` - Format

#### UI
- `<leader>e` - Toggle file explorer
- `<leader>xx` - Toggle Trouble
- `<C-\>` - Toggle terminal

#### Navigation
- `<C-h/j/k/l>` - Window navigation
- `<S-h/l>` - Buffer navigation
- `s` - Flash jump
- `]h/[h` - Next/prev git hunk

## Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Global keymaps
│   │   └── autocmds.lua        # Autocommands
│   └── plugins/                # Plugin configurations
│       ├── ui/                 # UI plugins
│       ├── editor/             # Editor enhancements
│       ├── coding/             # LSP, completion, formatting
│       └── tools/              # Git, terminal, utilities
└── README.md                   # This file
```

## Customization

### Adding Plugins
Add new plugins to the appropriate category in `lua/plugins/`:

```lua
-- In lua/plugins/ui/init.lua
return {
  -- existing plugins...
  
  {
    "author/plugin-name",
    opts = {
      -- configuration
    },
  },
}
```

### Modifying Keymaps
Edit `lua/config/keymaps.lua` for global keymaps, or add plugin-specific keymaps in the plugin configuration.

### Changing Options
Edit `lua/config/options.lua` to modify Vim settings.

### LSP Servers
Add new LSP servers in `lua/plugins/coding/init.lua`:

```lua
servers = {
  -- existing servers...
  new_server = {
    settings = {
      -- server-specific settings
    },
  },
},
```

## Installation

1. Backup your existing config:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this configuration:
   ```bash
   git clone <your-repo> ~/.config/nvim
   ```

3. Start Neovim and let Lazy install plugins:
   ```bash
   nvim
   ```

4. Run health check:
   ```
   :checkhealth
   ```

## Differences from LazyVim

- **No forced defaults** - every plugin is explicitly configured
- **No Snacks** - uses individual, focused plugins instead
- **Telescope-first** - no conflicting pickers
- **Neo-tree** properly configured without window management issues
- **Modular structure** - easy to understand and modify
- **Minimal dependencies** - only what you need

## Migration from LazyVim

Your LazyVim configuration has been backed up to `nvim-lazyvim-backup/`. You can:

1. Copy specific plugin configurations you want to keep
2. Migrate custom keymaps and options
3. Add any missing plugins you relied on

This configuration provides a solid foundation that you can build upon without fighting against opinionated defaults.