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
--   ├── editor/         -- Editor enhancements (telescope, treesitter, etc.)
--   ├── coding/         -- Coding tools (LSP, completion, etc.)
--   └── tools/          -- Additional tools (git, testing, etc.)

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
