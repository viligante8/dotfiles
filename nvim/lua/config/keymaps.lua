-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymap = vim.keymap.set

-- Script debugging and execution keymaps (avoiding conflicts with LazyVim DAP)
keymap("n", "<leader>dQ", "<cmd>DebugQuick<cr>", { desc = "Debug Quick (Current Project)" })
keymap("n", "<leader>dR", "<cmd>RunScript<cr>", { desc = "Run Script (Terminal Split)" })
