local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- DISABLED: Alpha restore functionality - was causing tab explosions
-- require("config.alpha-restore").setup()

-- Fix quickfix to open files in full window (not split)
autocmd("FileType", {
  pattern = "qf",
  group = augroup("QuickfixSettings", { clear = true }),
  callback = function()
    -- Map <CR> in quickfix to open file in full window
    vim.keymap.set("n", "<CR>", function()
      -- Get the current quickfix item
      local qf_idx = vim.fn.line('.')
      local qf_item = vim.fn.getqflist()[qf_idx]
      
      if qf_item and qf_item.bufnr ~= 0 then
        -- Close quickfix
        vim.cmd('cclose')
        -- Go to main window and make it only window
        vim.cmd('wincmd p')
        vim.cmd('only')
        -- Open the file
        vim.cmd('buffer ' .. qf_item.bufnr)
        -- Go to the line
        if qf_item.lnum > 0 then
          vim.api.nvim_win_set_cursor(0, {qf_item.lnum, qf_item.col > 0 and qf_item.col - 1 or 0})
        end
      end
    end, { buffer = true, desc = "Open file in full window" })
  end,
  desc = "Configure quickfix to open files in full window"
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some filetypes with <q>
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup("wrap_spell", { clear = true }),
  pattern = { "gitcommit", "markdown", "text", "rst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "80"
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})