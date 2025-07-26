# Minimal LazyVim Configuration Structure

Your LazyVim setup has been organized into a clean, minimal structure as requested:

## 1. ~/.config/nvim/lua/config/
- `options.lua` - Your custom options (colorcolumn, scrolloff, treesitter folding, performance)
- `keymaps.lua` - Your custom keymaps (file tree toggle, find/replace in quickfix)
- `autocmds.lua` - Your custom autocmds (close additional filetypes with `<q>`)
- `lazy.lua` - LazyVim bootstrap (unchanged)

## 2. ~/.config/nvim/lua/plugins/ (Core plugins as requested)
- `colorscheme.lua` - Kanagawa colorscheme setup
- `ai.lua` - GP.nvim AI chat configuration with your custom `<C-q>` keymaps
- `testing.lua` - Neotest setup with your custom `<A-t>` keymaps
- `database.lua` - Dadbod database UI with your custom `<A-d>` keymap
- `git.lua` - LazyGit integration with your custom `<C-g>` keymap
- `repl.lua` - REPL setup with your custom `<A-r>` keymaps

## 3. Additional plugins (not in minimal spec but useful)
- `bqf.lua` - Better quickfix window (enhances your find/replace workflow)
- `dap.lua` - Debugging configuration
- `nvim-surround.lua` - Text object manipulation
- `persistence.lua` - Session management
- `disable-defaults.lua` - Override conflicting LazyVim defaults if needed

## Key Features Preserved
- All your custom keymaps with their specific prefixes (`<C-q>`, `<A-t>`, `<A-d>`, `<A-r>`, `<C-g>`, `<C-f>`)
- Kanagawa colorscheme configuration
- Custom options for development workflow
- Custom autocmds for enhanced UX
- Clean plugin organization by functionality

## Conflicting Defaults
- Neo-tree remains enabled since you have a custom keymap for it (`<C-f>`)
- No conflicting keymaps detected with your custom bindings
- If you prefer nvim-tree over neo-tree, uncomment the disable spec in `disable-defaults.lua`

Your configuration is now organized according to the minimal LazyVim structure while preserving all your custom functionality.
