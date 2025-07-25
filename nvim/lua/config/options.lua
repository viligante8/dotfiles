-- lua/config/options.lua
-- Vim options and settings

local opt = vim.opt

-- Enable 24-bit colors
opt.termguicolors = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Mouse support
opt.mouse = 'a'

-- Don't show mode (status line will show it)
opt.showmode = false

-- Clipboard integration
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Undo
opt.undofile = true
opt.undolevels = 10000

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.signcolumn = 'yes'
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 8
opt.colorcolumn = '120'

-- Timing
opt.updatetime = 250
opt.timeoutlen = 300

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Whitespace characters
opt.list = true
opt.listchars = { 
  tab = '» ', 
  trail = '·', 
  nbsp = '␣',
  extends = '▶',
  precedes = '◀'
}

-- Live preview of substitutions
opt.inccommand = 'split'

-- Confirm before quit with unsaved changes
opt.confirm = true

-- Better completion experience
opt.completeopt = 'menu,menuone,noselect'

-- Folding
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevel = 99

-- Performance
opt.lazyredraw = false
opt.synmaxcol = 240

-- Backup and swap
opt.backup = false
opt.writebackup = false
opt.swapfile = false
