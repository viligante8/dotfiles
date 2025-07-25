-- lua/config/keymaps.lua
-- Global keymaps and shortcuts

local keymap = vim.keymap.set

-- Clear search highlights on <Esc>
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Better window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to upper window' })

-- Terminal mappings
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
keymap('n', '<C-M-t>', '<cmd>term<cr>', { desc = 'Open terminal window' })

-- File tree toggle
keymap('n', '<C-f>', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle file tree' })

-- LazyGit
keymap('n', '<C-g>', '<cmd>LazyGit<cr>', { desc = 'Open LazyGit' })

-- Find and replace in quickfix list
keymap('n', '<A-f>', function()
  local replace_what = vim.fn.input('Replace what: ')
  if replace_what == '' then return end
  
  local with_what = vim.fn.input('With what: ')
  local replace_command = 'cdo s/' .. replace_what .. '/' .. with_what .. '/g | update'
  vim.cmd(replace_command)
end, { desc = 'Find/replace in quickfix results' })

-- Better up/down movement for wrapped lines
keymap({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move text up and down
keymap('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
keymap('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Keep cursor centered when scrolling
keymap('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
keymap('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })

-- Better indenting
keymap('v', '<', '<gv', { desc = 'Indent left and reselect' })
keymap('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Paste without overwriting register
keymap('x', '<leader>p', '"_dP', { desc = 'Paste without overwriting register' })

-- Delete without overwriting register
keymap({ 'n', 'v' }, '<leader>d', '"_d', { desc = 'Delete without overwriting register' })

-- System clipboard operations
keymap({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
keymap('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })

-- Testing keymaps
keymap('n', '<A-t>r', '<cmd>Neotest run<cr>', { desc = 'Run tests in file' })
keymap('n', '<A-t>o', '<cmd>Neotest output<cr>', { desc = 'View test output' })
keymap('n', '<A-t>s', '<cmd>Neotest summary<cr>', { desc = 'View test summary' })
keymap('n', '<A-t>a', function()
  require('neotest').run.run({ vitestCommand = 'bun run test:all' })
end, { desc = 'Run all tests' })
keymap('n', '<A-t>p', '<cmd>Neotest output-panel<cr>', { desc = 'View test output panel' })

-- Database UI
keymap('n', '<A-d>t', '<cmd>DBUIToggle<cr>', { desc = 'Toggle Database UI' })

-- AI Chat keymaps
keymap('n', '<C-q>nt', '<cmd>GpChatToggle tabnew<cr>', { desc = 'New AI chat in tab' })
keymap('n', '<C-q>ns', '<cmd>GpChatToggle split<cr>', { desc = 'New AI chat in split' })
keymap('n', '<C-q>nv', '<cmd>GpChatToggle vsplit<cr>', { desc = 'New AI chat in vsplit' })
keymap('n', '<C-q>np', '<cmd>GpChatToggle popup<cr>', { desc = 'New AI chat in popup' })

keymap({ 'n', 'v' }, '<C-q>pt', '<cmd>GpChatPaste tabnew<cr>', { desc = 'Paste to AI chat in tab' })
keymap({ 'n', 'v' }, '<C-q>ps', '<cmd>GpChatPaste split<cr>', { desc = 'Paste to AI chat in split' })
keymap({ 'n', 'v' }, '<C-q>pv', '<cmd>GpChatPaste vsplit<cr>', { desc = 'Paste to AI chat in vsplit' })
keymap({ 'n', 'v' }, '<C-q>pp', '<cmd>GpChatPaste popup<cr>', { desc = 'Paste to AI chat in popup' })

keymap('n', '<leader>sq', '<cmd>GpChatFinder<cr>', { desc = 'Search AI chats' })

-- REPL keymaps  
keymap('n', '<A-r>o', '<cmd>Repl<cr>', { desc = 'Open REPL' })
keymap('n', '<A-r>c', '<Plug>(ReplSendCell)', { desc = 'Send cell to REPL' })
keymap('n', '<A-r>l', '<Plug>(ReplSendLine)', { desc = 'Send line to REPL' })
keymap('x', '<A-r>v', '<Plug>(ReplSendVisual)', { desc = 'Send visual selection to REPL' })

-- Resize windows with arrows
keymap('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase window height' })
keymap('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease window height' })
keymap('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease window width' })
keymap('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase window width' })

-- Quick save
keymap('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
