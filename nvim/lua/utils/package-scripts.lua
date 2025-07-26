-- Package Scripts Parser Utility
--
-- This module provides comprehensive parsing and categorization of npm scripts from
-- package.json files with advanced filtering, intelligent categorization, and rich metadata.
--
-- Features:
--   • Automatic script categorization (build, test, lint, deploy, etc.)
--   • Advanced filtering (lifecycle, debug, patterns, categories)
--   • Rich metadata with icons and flags
--   • Parent directory traversal for package.json discovery
--   • Comprehensive error handling
--
-- Usage:
--   local pkg_scripts = require('utils.package-scripts')
--   local scripts, err = pkg_scripts.get_package_scripts()
--   if scripts then
--     for _, script in ipairs(scripts) do
--       print(script.icon .. " " .. script.name .. ": " .. script.command)
--     end
--   end
--
-- Integration with other modules:
--   local package_manager = require('utils.package-manager')
--   local manager = package_manager.detect_package_manager()
--   -- Use detected manager to run selected scripts
--
-- Available categories:
--   start, test, build, lint, format, deploy, clean, watch, docs, install, debug, lifecycle, unknown

---@class PackageScripts
local M = {}

local uv = vim.loop

---@class FilterOptions
---@field exclude_lifecycle? boolean Exclude npm lifecycle scripts (default: true)
---@field exclude_debug? boolean Exclude debug-only scripts (default: false)
---@field include_patterns? string[] Include scripts matching these patterns
---@field exclude_patterns? string[] Exclude scripts matching these patterns
---@field categories? string[] Only include scripts from these categories

---@class PackageScript
---@field name string Script name
---@field command string Script command
---@field category string Script category (start, test, build, etc.)
---@field is_lifecycle boolean Whether this is an npm lifecycle script
---@field is_debug boolean Whether this appears to be a debug script
---@field icon string Icon for UI display

-- Default filter options
local DEFAULT_FILTER_OPTIONS = {
  exclude_lifecycle = true,
  exclude_debug = false,
  include_patterns = {},
  exclude_patterns = {},
  categories = {}
}

-- NPM lifecycle scripts that are automatically run
-- Only including actual npm lifecycle scripts, not custom pre/post hooks
local LIFECYCLE_SCRIPTS = {
  'preinstall', 'install', 'postinstall',
  'preuninstall', 'uninstall', 'postuninstall',
  'preversion', 'version', 'postversion',
  'prepublish', 'prepare', 'prepublishOnly', 'publish', 'postpublish'
}

-- Script category patterns
local CATEGORY_PATTERNS = {
  start = { '^start', '^serve', '^dev' },
  test = { '^test', '^spec', '^jest', '^mocha', '^vitest' },
  build = { '^build', '^compile', '^bundle', '^dist' },
  lint = { '^lint', '^eslint', '^tslint', '^prettier' },
  format = { '^format', '^fmt', '^prettier' },
  deploy = { '^deploy', '^publish', '^release' },
  clean = { '^clean', '^clear', '^reset' },
  watch = { '^watch', '^dev' },
  docs = { '^docs', '^doc', '^generate%-docs' },
  install = { '^install', '^setup', '^bootstrap' },
  -- Additional patterns for common script types
  check = { '^check' },
  fix = { '^fix' },
  generate = { '^generate' },
  docker = { 'docker', ':docker$' },
  nuke = { 'nuke' }
}

-- Debug script patterns
local DEBUG_PATTERNS = {
  'debug', 'inspect', 'node%-inspect', '%-%-debug', '%-%-inspect',
  -- Additional patterns for bun/node debugging
  'bun %-%-inspect', 'node %-%-inspect', '%-inspect',
  -- Case-insensitive patterns
  'DEBUG', 'INSPECT'
}

-- Icon mapping for different script categories
local SCRIPT_ICONS = {
  start = '🎆', -- More fun than play button
  test = '🧪',
  build = '🔨',
  lint = '🔍',
  format = '✨',
  deploy = '🚀',
  clean = '🧹',
  watch = '👀',
  docs = '📚',
  install = '📦',
  debug = '🐛',
  lifecycle = '⚙️',
  check = '✅',
  fix = '🔧',
  generate = '⚡',
  docker = '🐳',
  nuke = '☢️', -- Radioactive symbol for destructive operations
  unknown = '📄'
}

---Check if a script name matches any pattern in a list
---@param script_name string
---@param patterns string[]
---@return boolean
local function matches_patterns(script_name, patterns)
  for _, pattern in ipairs(patterns) do
    if script_name:match(pattern) then
      return true
    end
  end
  return false
end

---Check if a script is a lifecycle script
---@param script_name string
---@return boolean
local function is_lifecycle_script(script_name)
  -- Check exact matches for known lifecycle scripts
  for _, lifecycle in ipairs(LIFECYCLE_SCRIPTS) do
    if script_name == lifecycle then
      return true
    end
  end
  
  -- Check for pre/post hooks (any script starting with "pre" or "post")
  -- These are automatically run by npm and should not be run explicitly
  if script_name:match('^pre[a-zA-Z]') or script_name:match('^post[a-zA-Z]') then
    return true
  end
  
  return false
end

---Check if a script appears to be debug-related
---@param script_name string
---@param script_command string
---@return boolean
local function is_debug_script(script_name, script_command)
  -- Check for start and test scripts - these are commonly debugged in development
  if script_name:match('^start:') or script_name:match('^test:') then
    return true
  end
  
  -- Check script name for debug keywords
  for _, pattern in ipairs(DEBUG_PATTERNS) do
    if script_name:match(pattern) then
      return true
    end
  end
  
  -- Check script command for debug flags
  for _, pattern in ipairs(DEBUG_PATTERNS) do
    if script_command:match(pattern) then
      return true
    end
  end
  
  return false
end

---Categorize a script based on its name and command
---@param script_name string
---@param script_command string
---@return string
local function categorize_script(script_name, script_command)
  -- Check for lifecycle scripts first (these should never be run manually)
  if is_lifecycle_script(script_name) then
    return 'lifecycle'
  end
  
  -- Check category patterns to show what the script actually does
  for category, patterns in pairs(CATEGORY_PATTERNS) do
    if matches_patterns(script_name, patterns) then
      return category
    end
  end
  
  return 'unknown'
end

---Get icon for a script category
---@param category string
---@return string
function M.get_script_icon(category)
  return SCRIPT_ICONS[category] or SCRIPT_ICONS.unknown
end

---Get all available script categories
---@return string[]
function M.get_categories()
  local categories = {}
  for category, _ in pairs(CATEGORY_PATTERNS) do
    table.insert(categories, category)
  end
  table.insert(categories, 'debug')
  table.insert(categories, 'lifecycle')
  table.insert(categories, 'unknown')
  return categories
end

---Parse package.json and extract scripts
---@param package_path string Path to package.json file
---@return table<string, string>|nil scripts, string|nil error
local function parse_package_json(package_path)
  local file = io.open(package_path, 'r')
  if not file then
    return nil, 'Could not open package.json at ' .. package_path
  end
  
  local content = file:read('*all')
  file:close()
  
  local success, package_data = pcall(vim.fn.json_decode, content)
  if not success then
    return nil, 'Invalid JSON in package.json'
  end
  
  if not package_data.scripts or type(package_data.scripts) ~= 'table' then
    return {}, nil
  end
  
  return package_data.scripts, nil
end

---Apply filters to scripts
---@param scripts PackageScript[]
---@param filter_options FilterOptions
---@return PackageScript[]
local function apply_filters(scripts, filter_options)
  local filtered = {}
  
  for _, script in ipairs(scripts) do
    local should_include = true
    
    -- Filter by lifecycle scripts
    if filter_options.exclude_lifecycle and script.is_lifecycle then
      should_include = false
    end
    
    -- Filter by debug scripts
    if filter_options.exclude_debug and script.is_debug then
      should_include = false
    end
    
    -- Filter by include patterns
    if #filter_options.include_patterns > 0 then
      if not matches_patterns(script.name, filter_options.include_patterns) then
        should_include = false
      end
    end
    
    -- Filter by exclude patterns
    if #filter_options.exclude_patterns > 0 then
      if matches_patterns(script.name, filter_options.exclude_patterns) then
        should_include = false
      end
    end
    
    -- Filter by categories
    if #filter_options.categories > 0 then
      local category_match = false
      for _, category in ipairs(filter_options.categories) do
        if script.category == category then
          category_match = true
          break
        end
      end
      if not category_match then
        should_include = false
      end
    end
    
    if should_include then
      table.insert(filtered, script)
    end
  end
  
  return filtered
end

---Find package.json file starting from cwd and walking up
---@param cwd string Starting directory
---@return string|nil package_json_path, string|nil error
local function find_package_json(cwd)
  local current_path = vim.fn.fnamemodify(cwd, ':p:h') -- Get absolute path
  
  while current_path ~= '/' and current_path ~= '' do
    local package_path = current_path .. '/package.json'
    local stat = uv.fs_stat(package_path)
    
    if stat and stat.type == 'file' then
      return package_path, nil
    end
    
    -- Move up one directory
    local parent = vim.fn.fnamemodify(current_path, ':h')
    if parent == current_path then
      break -- Reached root
    end
    current_path = parent
  end
  
  return nil, 'No package.json found in ' .. cwd .. ' or parent directories'
end

---Get package.json scripts with filtering and categorization
---@param cwd string|nil Current working directory (defaults to vim.fn.getcwd())
---@param filter_options FilterOptions|nil Filter options (optional)
---@return PackageScript[]|nil scripts, string|nil error
function M.get_package_scripts(cwd, filter_options)
  cwd = cwd or vim.fn.getcwd()
  filter_options = vim.tbl_deep_extend('force', DEFAULT_FILTER_OPTIONS, filter_options or {})
  
  -- Find package.json
  local package_path, find_error = find_package_json(cwd)
  if not package_path then
    return nil, find_error
  end
  
  -- Parse package.json
  local raw_scripts, parse_error = parse_package_json(package_path)
  if not raw_scripts then
    return nil, parse_error
  end
  
  -- Convert to PackageScript objects
  local scripts = {}
  for name, command in pairs(raw_scripts) do
    local category = categorize_script(name, command)
    local script = {
      name = name,
      command = command,
      category = category,
      is_lifecycle = is_lifecycle_script(name),
      is_debug = is_debug_script(name, command),
      icon = M.get_script_icon(category)
    }
    table.insert(scripts, script)
  end
  
  -- Sort scripts alphabetically
  table.sort(scripts, function(a, b)
    return a.name < b.name
  end)
  
  -- Apply filters
  local filtered_scripts = apply_filters(scripts, filter_options)
  
  return filtered_scripts, nil
end

---Get scripts grouped by category
---@param cwd string|nil Current working directory
---@param filter_options FilterOptions|nil Filter options
---@return table<string, PackageScript[]>|nil grouped_scripts, string|nil error
function M.get_scripts_by_category(cwd, filter_options)
  local scripts, error = M.get_package_scripts(cwd, filter_options)
  if not scripts then
    return nil, error
  end
  
  local grouped = {}
  for _, script in ipairs(scripts) do
    if not grouped[script.category] then
      grouped[script.category] = {}
    end
    table.insert(grouped[script.category], script)
  end
  
  return grouped, nil
end

---Check if package.json exists in the given directory or parents
---@param cwd string|nil Directory to check (defaults to current working directory)
---@return boolean has_package_json
function M.has_package_json(cwd)
  cwd = cwd or vim.fn.getcwd()
  local package_path, _ = find_package_json(cwd)
  return package_path ~= nil
end

---Get the path to the nearest package.json file
---@param cwd string|nil Directory to start search from
---@return string|nil package_json_path
function M.get_package_json_path(cwd)
  cwd = cwd or vim.fn.getcwd()
  local package_path, _ = find_package_json(cwd)
  return package_path
end

return M
