# Package Scripts Parser Utility

The `package-scripts.lua` module provides comprehensive parsing and categorization of npm scripts from `package.json` files. It offers advanced filtering, intelligent categorization, and rich metadata to enhance script management in Neovim.

## 🚀 Purpose

Managing npm scripts in Node.js projects can be overwhelming when dealing with numerous scripts across different categories. This module:

- **Automatically categorizes** scripts (build, test, lint, deploy, etc.)
- **Filters unwanted scripts** (lifecycle, debug, custom patterns)
- **Enriches metadata** with icons, categories, and flags
- **Provides flexible APIs** for both simple and advanced use cases
- **Handles edge cases** gracefully with comprehensive error handling

## 📋 API Reference

### Data Types

#### `PackageScript`
```lua
---@class PackageScript
---@field name string Script name from package.json
---@field command string The actual command to execute
---@field category string Script category (start, test, build, etc.)
---@field is_lifecycle boolean Whether this is an npm lifecycle script
---@field is_debug boolean Whether this appears to be a debug script
---@field icon string Icon for UI display based on category
```

#### `FilterOptions`
```lua
---@class FilterOptions
---@field exclude_lifecycle? boolean Exclude npm lifecycle scripts (default: true)
---@field exclude_debug? boolean Exclude debug-only scripts (default: false)
---@field include_patterns? string[] Include scripts matching these patterns
---@field exclude_patterns? string[] Exclude scripts matching these patterns
---@field categories? string[] Only include scripts from these categories
```

### Core Functions

#### `get_package_scripts(cwd?, filter_options?)`

Parses package.json and returns a filtered list of categorized scripts.

**Parameters:**
- `cwd` (string, optional): Project directory to search for package.json. Defaults to `vim.fn.getcwd()`
- `filter_options` (FilterOptions, optional): Filtering options to apply

**Returns:**
- `PackageScript[]|nil, string|nil`: Array of scripts on success, or nil and error message on failure

**Example:**
```lua
local scripts, err = package_scripts.get_package_scripts()
if not scripts then
  vim.notify("Error: " .. err, vim.log.levels.ERROR)
  return
end

for _, script in ipairs(scripts) do
  print(script.icon .. " " .. script.name .. " -> " .. script.command)
end
```

#### `get_scripts_by_category(cwd?, filter_options?)`

Groups scripts by their detected categories.

**Parameters:**
- `cwd` (string, optional): Project directory
- `filter_options` (FilterOptions, optional): Same filtering options as above

**Returns:**
- `table<string, PackageScript[]>|nil, string|nil`: Dictionary mapping category names to script arrays

**Example:**
```lua
local grouped, err = package_scripts.get_scripts_by_category()
if not grouped then
  vim.notify("Error: " .. err, vim.log.levels.ERROR)
  return
end

for category, scripts in pairs(grouped) do
  print("=== " .. category:upper() .. " ===")
  for _, script in ipairs(scripts) do
    print("  " .. script.icon .. " " .. script.name)
  end
end
```

### Utility Functions

#### `get_script_icon(category)`

Returns the icon associated with a script category.

**Parameters:**
- `category` (string): The category name

**Returns:**
- `string`: Unicode icon for the category

**Available Icons:**
- `start`: ▶️ - Start/serve scripts
- `test`: 🧪 - Testing scripts  
- `build`: 🔨 - Build/compilation scripts
- `lint`: 🔍 - Linting scripts
- `format`: ✨ - Code formatting scripts
- `deploy`: 🚀 - Deployment scripts
- `clean`: 🧹 - Cleanup scripts
- `watch`: 👀 - File watching scripts
- `docs`: 📚 - Documentation scripts
- `install`: 📦 - Installation scripts
- `debug`: 🐛 - Debug scripts
- `lifecycle`: ⚙️ - NPM lifecycle scripts
- `unknown`: 📄 - Uncategorized scripts

#### `get_categories()`

Returns all available script categories.

**Returns:**
- `string[]`: Array of all category names

#### `has_package_json(cwd?)`

Checks if package.json exists in the given directory or its parents.

**Parameters:**
- `cwd` (string, optional): Directory to check

**Returns:**
- `boolean`: True if package.json found

#### `get_package_json_path(cwd?)`

Finds the path to the nearest package.json file.

**Parameters:**
- `cwd` (string, optional): Starting directory for search

**Returns:**  
- `string|nil`: Full path to package.json or nil if not found

## 🔧 Usage Examples

### Display Scripts with Categories

```lua
local package_scripts = require('utils.package-scripts')
local scripts, err = package_scripts.get_package_scripts()

if err then
  print("Error: " .. err)
else
  for _, script in ipairs(scripts) do
    print(script.icon .. " " .. script.name .. " (" .. script.category .. ")")
  end
end
```

### Conditional Script Execution

```lua
local package_scripts = require('utils.package-scripts')

local function run_test_script()
  local scripts, err = package_scripts.get_package_scripts()
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  for _, script in ipairs(scripts) do
    if script.category == "test" then
      vim.cmd('terminal ' .. script.command)
      break
    end
  end
end
```

### Picker Integration

```lua
local package_scripts = require('utils.package-scripts')
local picker = require('utils.picker')

local function select_script_and_run()
  local scripts, err = package_scripts.get_package_scripts()
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  picker.pick_script(
    vim.fn.getcwd(),
    { patterns = {"package.json"} },
    "Select an npm script:",
    function(item) return item.icon .. " " .. item.name end,
    function(selection)
      vim.cmd('terminal ' .. selection.command)
    end
  )
end
```

## ⚙️ Error Handling

Comprehensive error handling for common script-related issues:

- **Missing Files**: Informative errors if `package.json` is missing
- **Invalid JSON**: Errors parsed gracefully
- **Unsupported Formats**: Non-dictionary scripts field handled

## 🔄 Examples & Edge Cases

### Filtering Logic

```lua
local filter_options = {
  exclude_lifecycle = false,
  categories = {"build", "test"}, -- Only build and test scripts
  exclude_patterns = { "^deprecated" } -- Exclude scripts starting with 'deprecated'
}
```

### Extensive Categorization

```lua
local scripts, err = package_scripts.get_scripts_by_category()

for category, scripts in pairs(scripts) do
  print("Category: " .. category)
  for _, script in ipairs(scripts) do
    print("  " .. script.icon .. " " .. script.name)
  end
end
```

### Debug and Lifecycle Flags

```lua
local scripts, err = package_scripts.get_package_scripts(nil, { exclude_debug = false })

for _, script in ipairs(scripts) do
  if script.is_debug then
    print("Debug Script: " .. script.name)
  elseif script.is_lifecycle then
    print("Lifecycle Script: " .. script.name)
  end
end
```

## 🔗 Advanced Configuration

Adjust script icons in `SCRIPT_ICONS` table:

```lua
local SCRIPT_ICONS = {
  build = "🔧",
  deploy = "🚀",
  test = "🧪",
  -- more icons...
}

function package_scripts.get_script_icon(category)
  return SCRIPT_ICONS[category] or "❓" -- default unknown
end
```

## 🛡️ Robustness Tests

Includes tests for:

- ✅ Lifecycle and debug detection
- ✅ Pattern matching
- ✅ Script categorization logic
- ✅ Handling malformed JSON and non-existent files

## ❓ FAQ

**Q: Can it handle multiple `package.json`?**  
A: Supports nested structures, parsing top-level.
  
**Q: How does it sort scripts?**  
A: Alphabetically by name within categories.

**Q: What happens if scripts overlap categories?**  
A: Default logic assigns one exclusive category based on a match.

## 🔧 Integration with Other Utilities

Combine with other modules like `picker` for enhanced functionality:

```lua
require('utils.picker').pick_script(
  vim.fn.getcwd(),
  { patterns = {"*.json"} },
  "Select a script:",
  function(item) return item.icon .. " " .. item.name end,
  function(script) -- Do something with selected script end
)
```

## 📚 References

- **NPM Scripts Guide**: Understand script capabilities: [link]
- **plenary.nvim**: Extends vim functions: [link]
