local M = {}

-- Path to your maccy export script
local MACCY_SCRIPT = vim.fn.expand("~/dev/personal/scripts/maccy_clipboard_export_enhanced.py")

-- Cache for last sync to avoid unnecessary syncs
local last_sync_time = 0
local sync_debounce_ms = 2000 -- 2 seconds

-- Get maccy clipboard history and sync to yanky
local function sync_maccy_to_yanky()
  local current_time = vim.loop.hrtime() / 1000000 -- Convert to milliseconds
  
  -- Debounce: don't sync if we just synced recently
  if current_time - last_sync_time < sync_debounce_ms then
    return
  end
  
  last_sync_time = current_time
  
  -- Get recent maccy items
  local temp_file = os.tmpname() .. ".json"
  local cmd = string.format("python3 %s --limit 15 --type text --export-json %s >/dev/null 2>&1", MACCY_SCRIPT, temp_file)
  
  local result = os.execute(cmd)
  if result ~= 0 then
    return
  end
  
  local file = io.open(temp_file, "r")
  if not file then
    os.remove(temp_file)
    return
  end
  
  local content = file:read("*a")
  file:close()
  os.remove(temp_file)
  
  local ok, data = pcall(vim.json.decode, content)
  if not ok or not data then
    return
  end
  
  -- Get yanky history manager
  local yanky_ok, yanky_history = pcall(require, "yanky.history")
  if not yanky_ok then
    return
  end
  
  -- Clear existing yanky history
  yanky_history.clear()
  
  -- Separate pinned and regular items, filter out empty content
  local pinned_items = {}
  local regular_items = {}
  
  for _, item in ipairs(data) do
    local content = item.content_preview
    
    -- Skip if content is not a string (could be userdata/binary)
    if type(content) ~= "string" then
      goto continue
    end
    
    -- Filter out empty, whitespace-only, or very short content
    if content and content ~= "" and content:match("%S") and string.len(content:gsub("%s+", "")) > 2 then
      if item.is_pinned and item.is_pinned == 1 then
        table.insert(pinned_items, item)
      else
        table.insert(regular_items, item)
      end
    end
    
    ::continue::
  end
  
  -- Build ordered list: regular items first, then pinned items
  local ordered_items = {}
  
  -- Add regular items first (in reverse order since push adds to end)
  local regular_count = math.min(#regular_items, 10 - #pinned_items)
  for i = regular_count, 1, -1 do
    table.insert(ordered_items, regular_items[i])
  end
  
  -- Add pinned items last (so they end up at top)
  for i = #pinned_items, 1, -1 do
    table.insert(ordered_items, pinned_items[i])
  end
  
  -- Push all items in order
  for _, item in ipairs(ordered_items) do
    local content = item.content_preview
    
    -- Double-check content is a string before processing
    if type(content) == "string" then
      local cleaned_content = content:gsub("^%s+", ""):gsub("%s+$", "")
      if cleaned_content ~= "" then
        local success, err = pcall(function()
          yanky_history.push({
            regcontents = cleaned_content,
            regtype = "v", -- characterwise
          })
        end)
        
        if not success then
          -- Silently skip problematic items instead of crashing
          -- vim.notify("Failed to add item to yanky: " .. tostring(err), vim.log.levels.DEBUG)
        end
      end
    end
  end
end

-- Setup automatic syncing
function M.setup()
  -- Initial sync after yanky is ready
  vim.defer_fn(function()
    sync_maccy_to_yanky()
  end, 1000)
  
  -- Auto-sync on various events
  local augroup = vim.api.nvim_create_augroup("MaccySync", { clear = true })
  
  -- Sync when nvim gains focus (user switches back to nvim)
  vim.api.nvim_create_autocmd("FocusGained", {
    group = augroup,
    callback = function()
      vim.defer_fn(sync_maccy_to_yanky, 100) -- Small delay to let system settle
    end,
    desc = "Sync maccy history when nvim gains focus"
  })
  
  -- Sync when entering insert mode (about to paste)
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup,
    callback = function()
      sync_maccy_to_yanky()
    end,
    desc = "Sync maccy history when entering insert mode"
  })
  
  -- Sync before opening yanky picker
  vim.api.nvim_create_autocmd("User", {
    pattern = "TelescopePreviewerLoaded",
    group = augroup,
    callback = function()
      if vim.bo.filetype == "TelescopePrompt" then
        sync_maccy_to_yanky()
      end
    end,
    desc = "Sync maccy history before telescope picker"
  })
  
  -- Periodic sync every 30 seconds (less aggressive than before)
  local timer = vim.loop.new_timer()
  timer:start(30000, 30000, vim.schedule_wrap(function()
    sync_maccy_to_yanky()
  end))
  
  -- Manual sync command (for debugging/force sync)
  vim.api.nvim_create_user_command('SyncMaccy', function()
    last_sync_time = 0 -- Reset debounce
    sync_maccy_to_yanky()
    vim.notify("Maccy history synced manually", vim.log.levels.INFO)
  end, { desc = 'Force sync Maccy history to Yanky' })
  
  -- Status command to check sync
  vim.api.nvim_create_user_command('MaccyStatus', function()
    local yanky_ok, yanky_history = pcall(require, "yanky.history")
    if yanky_ok then
      local items = yanky_history.all()
      vim.notify(string.format("Yanky has %d items, last sync: %dms ago", 
        #items, vim.loop.hrtime() / 1000000 - last_sync_time), vim.log.levels.INFO)
    end
  end, { desc = 'Show maccy sync status' })
end

return M
