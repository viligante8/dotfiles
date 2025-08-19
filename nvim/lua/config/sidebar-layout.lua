-- Right sidebar layout manager for Aerial + Trouble
local M = {}

-- Track if sidebar is currently open
local sidebar_open = false

-- Function to open the stacked right sidebar
function M.open_sidebar()
  if sidebar_open then
    return
  end
  
  -- Simply open Aerial and Trouble and let them manage their own windows
  vim.cmd('AerialOpen')
  vim.cmd('Trouble diagnostics open')
  
  sidebar_open = true
end

-- Function to close the sidebar
function M.close_sidebar()
  if not sidebar_open then
    return
  end
  
  -- Close both
  pcall(vim.cmd, 'AerialClose')
  pcall(vim.cmd, 'Trouble diagnostics close')
  
  sidebar_open = false
end

-- Function to toggle the sidebar
function M.toggle_sidebar()
  if sidebar_open then
    M.close_sidebar()
  else
    M.open_sidebar()
  end
end

-- Setup function
function M.setup()
  -- Minimal setup
end

-- Check if sidebar is open
function M.is_open()
  return sidebar_open
end

return M
