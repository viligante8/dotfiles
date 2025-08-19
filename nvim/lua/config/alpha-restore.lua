-- Auto-restore Alpha dashboard when closing last buffer but keeping nvim open
local M = {}

-- Function to check if we should show Alpha
local function should_show_alpha()
  -- Get all windows
  local windows = vim.api.nvim_list_wins()
  local normal_windows = 0
  local has_special_windows = false
  
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
    
    -- Check for special windows (neotree, quickfix, etc.)
    if filetype == 'neo-tree' or 
       filetype == 'qf' or 
       filetype == 'help' or
       filetype == 'trouble' or
       filetype == 'neotest-summary' or
       filetype == 'neotest-output' or
       filetype == 'neotest-output-panel' or
       buftype == 'quickfix' or
       buftype == 'help' or
       buftype == 'terminal' then
      has_special_windows = true
    elseif buftype == '' or buftype == 'acwrite' then
      -- Normal file buffer
      normal_windows = normal_windows + 1
    end
  end
  
  -- Show Alpha if we have special windows but no normal file buffers
  return has_special_windows and normal_windows == 0
end

-- Function to show Alpha dashboard
local function show_alpha()
  -- Check if Alpha is available
  local alpha_ok, alpha = pcall(require, "alpha")
  if not alpha_ok then
    return
  end
  
  -- Create a new buffer for Alpha
  local buf = vim.api.nvim_create_buf(false, true)
  
  -- Find a suitable window to show Alpha in
  local target_win = nil
  local windows = vim.api.nvim_list_wins()
  
  for _, win in ipairs(windows) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    local buftype = vim.api.nvim_buf_get_option(win_buf, 'buftype')
    local filetype = vim.api.nvim_buf_get_option(win_buf, 'filetype')
    
    -- Use a window that's not special (neotree, qf, etc.)
    if buftype == '' and 
       filetype ~= 'neo-tree' and 
       filetype ~= 'qf' and 
       filetype ~= 'help' and
       filetype ~= 'trouble' and
       not filetype:match('neotest') then
      target_win = win
      break
    end
  end
  
  -- If no suitable window found, create a new one
  if not target_win then
    vim.cmd('new')
    target_win = vim.api.nvim_get_current_win()
  end
  
  -- Set the Alpha buffer in the target window
  vim.api.nvim_win_set_buf(target_win, buf)
  vim.api.nvim_set_current_win(target_win)
  
  -- Start Alpha
  alpha.start(false, alpha.default_config)
end

-- Setup the auto-command
function M.setup()
  local augroup = vim.api.nvim_create_augroup("AlphaRestore", { clear = true })
  
  -- When a buffer is deleted/hidden, check if we should show Alpha
  vim.api.nvim_create_autocmd({ "BufDelete", "BufHidden" }, {
    group = augroup,
    callback = function()
      -- Small delay to let the buffer deletion complete
      vim.defer_fn(function()
        if should_show_alpha() then
          show_alpha()
        end
      end, 10)
    end,
    desc = "Show Alpha when closing last buffer but keeping special windows"
  })
  
  -- Also handle when switching to a buffer that gets deleted
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
      local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
      
      -- If we enter a buffer that's empty and we should show Alpha
      if buftype == '' and filetype == '' and vim.api.nvim_buf_get_name(buf) == '' then
        if should_show_alpha() then
          show_alpha()
        end
      end
    end,
    desc = "Show Alpha when entering empty buffer with special windows open"
  })
end

return M
