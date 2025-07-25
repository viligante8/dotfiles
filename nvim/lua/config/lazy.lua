-- lua/config/lazy.lua
-- Lazy plugin manager setup and configuration

-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

-- Add lazy to runtime path
vim.opt.rtp:prepend(lazypath)

-- Configure and install plugins
require('lazy').setup({
  -- Import plugin specifications from different categories
  { import = 'plugins.ui' },
  { import = 'plugins.editor' },
  { import = 'plugins.coding' },
  { import = 'plugins.tools' },
}, {
  -- Lazy configuration options
  install = {
    missing = true,
    colorscheme = { 'kanagawa' },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
    icons = {
      ft = '',
      lazy = '󰂠 ',
      loaded = '',
      not_loaded = '',
    },
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
