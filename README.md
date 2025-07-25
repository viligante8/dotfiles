# Modular Neovim Configuration

This configuration has been reorganized into a modular structure for better maintainability and understanding.

## Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── options.lua         # Vim options and settings
│   │   ├── keymaps.lua         # Global keymaps
│   │   ├── autocmds.lua        # Autocommands
│   │   └── lazy.lua            # Lazy plugin manager setup
│   └── plugins/                # Plugin configurations
│       ├── ui/                 # UI-related plugins
│       │   └── init.lua        # Colorschemes, file trees, which-key
│       ├── editor/             # Editor enhancements
│       │   └── init.lua        # Telescope, treesitter, autopairs
│       ├── coding/             # Coding tools
│       │   └── init.lua        # LSP, completion, formatting
│       └── tools/              # Additional tools
│           └── init.lua        # Git, testing, database, AI
└── init.lua.backup             # Your original configuration (backup)
```

## Key Features

### Core Configuration (`lua/config/`)

- **options.lua**: All Vim settings and options organized logically
- **keymaps.lua**: Global keymaps with clear descriptions
- **autocmds.lua**: Autocommands for various file events
- **lazy.lua**: Plugin manager configuration

### Plugin Categories

#### UI Plugins (`lua/plugins/ui/init.lua`)
- **Kanagawa**: Beautiful colorscheme
- **nvim-tree**: File explorer
- **nvim-bqf**: Enhanced quickfix window
- **which-key**: Keybinding hints
- **FZF**: Fuzzy finder support

#### Editor Plugins (`lua/plugins/editor/init.lua`)
- **Telescope**: Fuzzy finder for files, commands, etc.
- **Treesitter**: Better syntax highlighting
- **nvim-autopairs**: Auto-close brackets and quotes
- **Comment.nvim**: Easy commenting
- **gitsigns**: Git integration in gutter
- **nvim-surround**: Surround text objects

#### Coding Plugins (`lua/plugins/coding/init.lua`)
- **blink.cmp**: Fast completion engine
- **nvim-lspconfig**: LSP configuration
- **Mason**: LSP/tool installer
- **conform.nvim**: Code formatting
- **nvim-lint**: Code linting
- **TypeScript tools**: Enhanced TypeScript support

#### Tool Plugins (`lua/plugins/tools/init.lua`)
- **LazyGit**: Git UI
- **Neotest**: Testing framework
- **vim-dadbod**: Database interface
- **nvim-repl**: REPL integration
- **gp.nvim**: AI chat assistant
- **nvim-dap**: Debugging support
- **Mini.nvim**: Collection of useful mini-plugins

## Key Keymaps

### Leader Key: `<Space>`

#### File Operations
- `<leader>sf` - Search files
- `<leader>sg` - Live grep
- `<leader>sw` - Search current word
- `<leader><leader>` - Find buffers
- `<leader>w` - Save file

#### LSP
- `gd` - Go to definition
- `gr` - Go to references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>f` - Format buffer

#### Git
- `<C-g>` - Open LazyGit
- `<leader>lg` - LazyGit (alternative)

#### Testing
- `<A-t>r` - Run tests
- `<A-t>o` - Test output
- `<A-t>s` - Test summary
- `<A-t>a` - Run all tests

#### AI Chat
- `<C-q>nt` - New AI chat in tab
- `<C-q>ns` - New AI chat in split
- `<leader>sq` - Search AI chats

#### Navigation
- `<C-h/j/k/l>` - Window navigation
- `<C-f>` - Toggle file tree

## How to Modify

### Adding New Plugins

1. **Choose the right category** based on the plugin's purpose
2. **Add to the appropriate file** in `lua/plugins/`
3. **Follow the existing structure** with proper configuration

Example - Adding a new UI plugin:
```lua
-- In lua/plugins/ui/init.lua
return {
  -- ... existing plugins ...
  
  -- New plugin
  {
    'author/plugin-name',
    config = function()
      require('plugin-name').setup({
        -- configuration here
      })
    end,
  },
}
```

### Modifying Keymaps

1. **Global keymaps**: Edit `lua/config/keymaps.lua`
2. **Plugin-specific keymaps**: Edit within the plugin configuration
3. **LSP keymaps**: Edit in `lua/plugins/coding/init.lua`

### Changing Options

Edit `lua/config/options.lua` to modify Vim settings.

### Adding Autocommands

Add new autocommands to `lua/config/autocmds.lua`.

## Benefits of This Structure

1. **Easier to navigate**: Each category is clearly separated
2. **Better maintainability**: Changes are isolated to specific areas
3. **Clearer understanding**: Each file has a specific purpose
4. **Easier debugging**: Problems are easier to locate
5. **Modular loading**: Plugins load only when needed

## Migration Notes

- Your original configuration is backed up as `init.lua.backup`
- All existing functionality has been preserved
- The modular structure makes it easier to:
  - Add new plugins
  - Modify existing configurations
  - Debug issues
  - Share specific parts of your config

## Next Steps

1. **Test the configuration**: Start Neovim and run `:checkhealth`
2. **Install plugins**: Run `:Lazy sync`
3. **Customize as needed**: Modify individual files based on your preferences
4. **Learn the structure**: Explore each file to understand the organization

For any issues, you can always restore from `init.lua.backup` and gradually migrate pieces of the modular configuration.
