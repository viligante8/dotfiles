# Utility Modules API Summary

This document provides a quick reference for all functions and classes available in the utility modules.

## 📦 Package Manager (`package-manager.lua`)

### Functions

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `detect_package_manager(cwd?)` | `cwd` (string, optional) | `string` | Detects package manager: "npm", "yarn", "bun", or "unknown" |

### Usage Examples

```lua
local pkg_mgr = require('utils.package-manager')

-- Basic detection
local manager = pkg_mgr.detect_package_manager()

-- With specific directory
local manager = pkg_mgr.detect_package_manager("/path/to/project")

-- Conditional logic
if manager ~= "unknown" then
  vim.cmd('terminal ' .. manager .. ' install')
end
```

## 📜 Package Scripts (`package-scripts.lua`)

### Data Types

#### `PackageScript`
```lua
{
  name = "build",              -- Script name
  command = "webpack --mode=production", -- Command to execute
  category = "build",          -- Auto-detected category
  is_lifecycle = false,        -- Is npm lifecycle script
  is_debug = false,           -- Is debug-related script
  icon = "🔨"                 -- Category icon
}
```

#### `FilterOptions`
```lua
{
  exclude_lifecycle = true,    -- Exclude lifecycle scripts
  exclude_debug = false,       -- Exclude debug scripts
  include_patterns = {},       -- Include matching patterns
  exclude_patterns = {},       -- Exclude matching patterns
  categories = {}              -- Only include these categories
}
```

### Functions

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `get_package_scripts(cwd?, filter_options?)` | `cwd` (string, optional)<br>`filter_options` (FilterOptions, optional) | `PackageScript[]|nil, string|nil` | Get filtered and categorized scripts |
| `get_scripts_by_category(cwd?, filter_options?)` | `cwd` (string, optional)<br>`filter_options` (FilterOptions, optional) | `table<string, PackageScript[]>|nil, string|nil` | Get scripts grouped by category |
| `get_script_icon(category)` | `category` (string) | `string` | Get icon for script category |
| `get_categories()` | None | `string[]` | Get all available categories |
| `has_package_json(cwd?)` | `cwd` (string, optional) | `boolean` | Check if package.json exists |
| `get_package_json_path(cwd?)` | `cwd` (string, optional) | `string|nil` | Get path to nearest package.json |

### Available Categories

| Category | Icon | Pattern Examples |
|----------|------|------------------|
| `start` | ▶️ | `start`, `serve`, `dev` |
| `test` | 🧪 | `test`, `spec`, `jest` |
| `build` | 🔨 | `build`, `compile`, `bundle` |
| `lint` | 🔍 | `lint`, `eslint`, `tslint` |
| `format` | ✨ | `format`, `prettier` |
| `deploy` | 🚀 | `deploy`, `publish`, `release` |
| `clean` | 🧹 | `clean`, `clear`, `reset` |
| `watch` | 👀 | `watch`, `dev` |
| `docs` | 📚 | `docs`, `doc`, `generate-docs` |
| `install` | 📦 | `install`, `setup`, `bootstrap` |
| `debug` | 🐛 | `debug`, `inspect`, `--debug` |
| `lifecycle` | ⚙️ | `preinstall`, `posttest`, etc. |
| `unknown` | 📄 | Scripts that don't match patterns |

### Usage Examples

```lua
local pkg_scripts = require('utils.package-scripts')

-- Get all scripts
local scripts, err = pkg_scripts.get_package_scripts()
if scripts then
  for _, script in ipairs(scripts) do
    print(script.icon .. " " .. script.name .. ": " .. script.command)
  end
end

-- Get scripts with filtering
local scripts, err = pkg_scripts.get_package_scripts(nil, {
  categories = {"build", "test"},
  exclude_patterns = {"^deprecated"}
})

-- Get scripts by category
local grouped, err = pkg_scripts.get_scripts_by_category()
if grouped then
  for category, scripts in pairs(grouped) do
    print("=== " .. category:upper() .. " ===")
    for _, script in ipairs(scripts) do
      print("  " .. script.icon .. " " .. script.name)
    end
  end
end
```

## 🎯 Generic Picker (`picker.lua`)

### Data Types

#### `FilterOptions`
```lua
{
  patterns = {"*.sh", "*.py"},  -- File patterns to match
  executable = true,            -- Only executable files
  max_depth = 3,               -- Max directory depth
  type = "f"                   -- File type ("f" or "d")
}
```

### Functions

| Function | Parameters | Returns | Description |
|----------|------------|---------|-------------|
| `pick_script(cwd, filter_options, prompt, format_item_fn, callback)` | `cwd` (string, required)<br>`filter_options` (FilterOptions, optional)<br>`prompt` (string, required)<br>`format_item_fn` (function, optional)<br>`callback` (function, required) | `nil` | Interactive file/script picker |

### Usage Examples

```lua
local picker = require('utils.picker')

-- Basic file picker
picker.pick_script(
  vim.fn.getcwd(),
  { patterns = {"*.lua", "*.vim"} },
  "Select file:",
  function(item) return "📁 " .. item end,
  function(selection) vim.cmd('edit ' .. selection) end
)

-- Executable scripts only
picker.pick_script(
  vim.fn.getcwd(),
  { 
    patterns = {"*.sh", "*.py"}, 
    executable = true,
    max_depth = 2
  },
  "Select script to run:",
  function(item)
    local ext = item:match("%.([^%.]+)$")
    local icons = { sh = "🐚", py = "🐍" }
    return (icons[ext] or "📄") .. " " .. item
  end,
  function(selection)
    vim.cmd('terminal ./' .. selection)
  end
)
```

## 🔗 Module Integration Examples

### Complete Package Management Workflow

```lua
local package_manager = require('utils.package-manager')
local package_scripts = require('utils.package-scripts')
local picker = require('utils.picker')

function run_npm_script()
  -- 1. Detect package manager
  local manager = package_manager.detect_package_manager()
  if manager == "unknown" then
    vim.notify("No package manager detected", vim.log.levels.WARN)
    return
  end

  -- 2. Get available scripts
  local scripts, err = package_scripts.get_package_scripts()
  if not scripts then
    vim.notify("Error: " .. err, vim.log.levels.ERROR)
    return
  end

  -- 3. Let user select script
  vim.ui.select(scripts, {
    prompt = "Select " .. manager .. " script:",
    format_item = function(script)
      return script.icon .. " " .. script.name .. " (" .. script.category .. ")"
    end
  }, function(selected)
    if selected then
      -- 4. Run with detected package manager
      local cmd = manager .. " run " .. selected.name
      vim.notify("Running: " .. cmd)
      vim.cmd('terminal ' .. cmd)
    end
  end)
end
```

### Development Environment Setup

```lua
local package_manager = require('utils.package-manager')
local picker = require('utils.picker')

function setup_dev_environment()
  local manager = package_manager.detect_package_manager()
  
  if manager ~= "unknown" then
    -- JavaScript/Node.js project detected
    vim.keymap.set('n', '<leader>pi', ':terminal ' .. manager .. ' install<CR>')
    vim.keymap.set('n', '<leader>pr', run_npm_script)
    vim.keymap.set('n', '<leader>pd', ':terminal ' .. manager .. ' run dev<CR>')
  end
  
  -- Generic script picker for any project
  vim.keymap.set('n', '<leader>ps', function()
    picker.pick_script(
      vim.fn.getcwd(),
      { patterns = {"*.sh", "*.py", "*.js"}, executable = true },
      "Run script:",
      function(item) return "🔧 " .. item end,
      function(selection) vim.cmd('terminal ./' .. selection) end
    )
  end)
end
```

### Project-Aware File Navigation

```lua
local package_scripts = require('utils.package-scripts')
local picker = require('utils.picker')

function smart_file_picker()
  -- Check if we're in a Node.js project
  if package_scripts.has_package_json() then
    -- Node.js project - focus on relevant files
    picker.pick_script(
      vim.fn.getcwd(),
      { patterns = {"*.js", "*.ts", "*.json", "*.md"} },
      "Select project file:",
      function(item)
        local ext = item:match("%.([^%.]+)$")
        local icons = { js = "📜", ts = "📘", json = "📋", md = "📝" }
        return (icons[ext] or "📄") .. " " .. item
      end,
      function(selection) vim.cmd('edit ' .. selection) end
    )
  else
    -- Generic project
    picker.pick_script(
      vim.fn.getcwd(),
      { patterns = {"*"} },
      "Select file:",
      function(item) return "📁 " .. item end,
      function(selection) vim.cmd('edit ' .. selection) end
    )
  end
end
```

## ⚠️ Error Handling Patterns

All modules follow consistent error handling:

### Return Value Pattern
```lua
local result, error = module.function()
if not result then
  vim.notify("Error: " .. error, vim.log.levels.ERROR)
  return
end
-- Use result safely
```

### Parameter Validation
```lua
-- All functions validate required parameters
picker.pick_script(nil, {}, "prompt", nil, function() end)
-- Result: "Error: cwd parameter is required"
```

### Graceful Degradation
```lua
-- Functions handle missing files/directories gracefully
local manager = package_manager.detect_package_manager("/nonexistent")
-- Result: "unknown" (no error thrown)
```

## 🚀 Performance Considerations

- **Package Manager Detection**: Uses efficient `vim.fn.filereadable()` checks
- **Package Scripts**: Parses JSON only once, caches categorization
- **Generic Picker**: Uses `find` command for fast file discovery
- **Memory Usage**: All modules are stateless and don't retain data

## 🧪 Testing

All modules include comprehensive test suites:

```bash
# Run all tests
nvim --headless -c "lua require('plenary.test_harness').test_directory('lua/utils/')"

# Run specific module tests
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/package-manager_spec.lua')"
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/package-scripts_spec.lua')"
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/picker_spec.lua')"
```

## 📚 Further Reading

- [Main README](./README.md) - Complete overview and integration examples
- [Package Manager Documentation](./package-manager.md) - Detailed package manager detection guide
- [Package Scripts Documentation](./package-scripts.md) - Comprehensive script parsing reference
- [Generic Picker Documentation](./picker.md) - Advanced picker usage patterns
- [Test Documentation](./README_TESTS.md) - Testing setup and coverage details
