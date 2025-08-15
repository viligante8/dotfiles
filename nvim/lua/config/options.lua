local opt = vim.opt

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.termguicolors = true
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 1

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = true  -- Default to wrap enabled
opt.linebreak = true  -- When wrap is enabled, break at word boundaries
opt.breakindent = true  -- Maintain indentation on wrapped lines
opt.showbreak = "↪ "  -- Visual indicator for wrapped lines
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

-- Misc
opt.updatetime = 250
opt.timeoutlen = 300
opt.mouse = "a"
opt.clipboard = "unnamedplus"