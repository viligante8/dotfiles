# Neovim Utility Modules

This directory contains reusable utility modules for Neovim plugins and configurations. Each module is designed to provide specific functionality that can be easily integrated into different parts of your Neovim setup.

## 📚 Available Modules

### 🔧 [Package Manager Detection](./package-manager.md)
**File:** `package-manager.lua` | **[Full API Docs](./package-manager.md)**

Detects which package manager (npm, yarn, bun) is being used in a JavaScript/Node.js project by examining lock files and package.json.

**Quick Example:**
```lua
local pkg_mgr = require('utils.package-manager')
local manager = pkg_mgr.detect_package_manager() -- Returns "npm", "yarn", "bun", or "unknown"
```

### 📦 [Package Scripts Parser](./package-scripts.md)
**File:** `package-scripts.lua` | **[Full API Docs](./package-scripts.md)**

Parses and categorizes npm scripts from package.json files with advanced filtering and categorization capabilities.

**Quick Example:**
```lua
local pkg_scripts = require('utils.package-scripts')
local scripts, err = pkg_scripts.get_package_scripts()
if scripts then
  for _, script in ipairs(scripts) do
    print(script.icon .. " " .. script.name .. ": " .. script.command)
  end
end
```

### 🎯 [Generic Picker](./picker.md)
**File:** `picker.lua` | **[Full API Docs](./picker.md)**

Provides a reusable script picker interface that works with both Telescope and vim.ui.select as fallback.

**Quick Example:**
```lua
local picker = require('utils.picker')
picker.pick_script(
  vim.fn.getcwd(),
  { patterns = {"*.sh"} },
  "Select script:",
  function(item) return "📄 " .. item end,
  function(selection) print("Selected: " .. selection) end
)
```

## 🚀 Quick Start

1. **Installation**: Copy the `lua/utils/` directory to your Neovim configuration
2. **Dependencies**: Ensure you have `plenary.nvim` installed for path utilities
3. **Usage**: Require any module with `require('utils.module-name')`

## 🧪 Testing

All modules include comprehensive unit tests using `plenary.nvim`:

```bash
# Run all tests
nvim --headless -c "lua require('plenary.test_harness').test_directory('lua/utils/')"

# Run specific module tests
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/package-manager_spec.lua')"
```

See [README_TESTS.md](./README_TESTS.md) for detailed testing information.

## 🔄 Integration Examples

### Creating a Package Manager-Aware Plugin

```lua
-- plugins/my-package-plugin.lua
local M = {}

local package_manager = require('utils.package-manager')
local package_scripts = require('utils.package-scripts')

function M.run_package_command(command)
  local manager = package_manager.detect_package_manager()
  if manager == "unknown" then
    vim.notify("No package manager detected", vim.log.levels.WARN)
    return
  end
  
  -- Execute command with detected package manager
  vim.cmd('terminal ' .. manager .. ' ' .. command)
end

function M.pick_and_run_script()
  local scripts, err = package_scripts.get_package_scripts()
  if not scripts then
    vim.notify("Error: " .. err, vim.log.levels.ERROR)
    return
  end
  
  local picker = require('utils.picker')
  -- Convert package scripts to picker format
  local script_items = {}
  for _, script in ipairs(scripts) do
    table.insert(script_items, script.name)
  end
  
  vim.ui.select(script_items, {
    prompt = "Select script to run:",
    format_item = function(item)
      -- Find the script object
      for _, script in ipairs(scripts) do
        if script.name == item then
          return script.icon .. " " .. script.name .. " (" .. script.category .. ")"
        end
      end
      return item
    end
  }, function(choice)
    if choice then
      M.run_package_command("run " .. choice)
    end
  end)
end

return M
```

### Creating a Development Script Selector

```lua
-- plugins/dev-scripts.lua
local M = {}

local picker = require('utils.picker')

function M.select_dev_script()
  picker.pick_script(
    vim.fn.getcwd(),
    {
      patterns = {"*.sh", "*.py", "*.js"},
      executable = true,
      max_depth = 3
    },
    "Select development script:",
    function(item)
      -- Custom formatting with file type icons
      local ext = item:match("%.([^%.]+)$")
      local icons = {
        sh = "🐚",
        py = "🐍", 
        js = "📜"
      }
      return (icons[ext] or "📄") .. " " .. item
    end,
    function(selection)
      -- Execute the selected script
      vim.cmd('split | terminal ./' .. selection)
    end
  )
end

return M
```

## 🛠️ Error Handling

All utility modules follow consistent error handling patterns:

- **Return Values**: Functions return `(result, error)` tuple where `error` is `nil` on success
- **Validation**: Input parameters are validated with descriptive error messages
- **Graceful Degradation**: Modules handle missing dependencies and files gracefully
- **Logging**: Errors are logged using `vim.notify()` with appropriate log levels

## 📝 Documentation

Comprehensive documentation is available for all modules:

### 📋 Quick References
- **[API Summary](./API_SUMMARY.md)** - Complete function reference with examples
- **[Testing Guide](./README_TESTS.md)** - Test setup, coverage, and running instructions

### 📚 Detailed Guides
- **[Package Manager Guide](./package-manager.md)** - Detection, integration, and customization
- **[Package Scripts Guide](./package-scripts.md)** - Parsing, filtering, and categorization
- **[Generic Picker Guide](./picker.md)** - Interactive selection and UI integration

### 📡 Features
Each module provides:
- **Type Annotations**: Full Lua Language Server annotations
- **Parameter Validation**: Input validation with clear error messages  
- **Consistent APIs**: Similar function signatures across modules
- **Extensible Design**: Easy to extend and customize for specific use cases
- **Comprehensive Testing**: Unit tests covering edge cases and error scenarios

## 🤝 Contributing

When adding new utility modules:

1. Follow the existing code patterns and naming conventions
2. Include comprehensive unit tests using `plenary.nvim`
3. Add type annotations and documentation comments
4. Update this README with module information
5. Create individual module documentation files

## 📚 Quick Links

- **[API Summary](./API_SUMMARY.md)** - Quick function reference
- **[Package Manager Docs](./package-manager.md)** - Detailed package manager detection guide
- **[Package Scripts Docs](./package-scripts.md)** - Script parsing and categorization
- **[Generic Picker Docs](./picker.md)** - Interactive file/script selection
- **[Testing Documentation](./README_TESTS.md)** - Test setup and coverage

## 🔗 License

These utility modules are part of the Neovim configuration and follow the same licensing terms.
