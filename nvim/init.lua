-- =====================================================================
-- ==================== MODULAR NEOVIM CONFIGURATION ==================
-- =====================================================================
--
-- This configuration is organized into modules for better maintainability:
--
-- lua/config/
--   ├── options.lua     -- Vim options and settings
--   ├── keymaps.lua     -- Global keymaps
--   ├── autocmds.lua    -- Autocommands
--   └── lazy.lua        -- Lazy plugin manager setup
--
-- lua/plugins/
--   ├── ui/             -- UI-related plugins (colorschemes, statusline, etc.)
--   │   ├── kanagawa.lua    -- Colorscheme
--   │   ├── nvim-tree.lua   -- File explorer  
--   │   ├── which-key.lua   -- Keybinding hints
--   │   └── mini.lua        -- Mini.nvim statusline & more
--   ├── editor/         -- Editor enhancements (telescope, treesitter, etc.)
--   │   ├── telescope.lua   -- Telescope fuzzy finder
--   │   ├── treesitter.lua  -- Treesitter syntax highlighting
--   │   ├── gitsigns.lua    -- Git integration
--   │   └── autopairs.lua   -- Auto bracket pairing
--   ├── coding/         -- Coding tools (LSP, completion, etc.)
--   │   ├── lsp.lua         -- LSP configuration
--   │   ├── blink-cmp.lua   -- Completion engine
--   │   ├── conform.lua     -- Code formatting
--   │   └── nvim-lint.lua   -- Linting
--   └── tools/          -- Additional tools (git, testing, etc.)
--       ├── lazygit.lua     -- Git TUI integration
--       ├── neotest.lua     -- Testing framework
--       ├── dap.lua         -- Debugging
--       └── dadbod.lua      -- Database UI

-- Set leader keys before anything else
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Disable netrw (we'll use nvim-tree instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Load configuration modules
require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.lazy')
