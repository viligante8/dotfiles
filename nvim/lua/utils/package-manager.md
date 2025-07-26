# Package Manager Detection Utility

The `package-manager.lua` module provides automatic detection of JavaScript package managers (npm, yarn, bun) in project directories by examining lock files and package.json files.

## 🎯 Purpose

When working with JavaScript/Node.js projects in Neovim, it's essential to use the correct package manager for running scripts, installing dependencies, and other package-related tasks. This utility automatically detects which package manager is being used based on the presence of specific lock files.

## 📋 API Reference

### `detect_package_manager(cwd?)`

Detects the package manager used in a project directory by checking for lock files and package.json.

**Parameters:**
- `cwd` (string, optional): The directory to check. Defaults to `vim.fn.getcwd()`

**Returns:**
- `string`: The detected package manager: `"npm"`, `"yarn"`, `"bun"`, or `"unknown"`

**Detection Priority:**
1. `bun.lockb` → `"bun"`
2. `yarn.lock` → `"yarn"`
3. `package-lock.json` → `"npm"`
4. `package.json` (fallback) → `"npm"`
5. None found → `"unknown"`

## 🔧 Usage Examples

### Basic Detection

```lua
local package_manager = require('utils.package-manager')

-- Detect in current directory
local manager = package_manager.detect_package_manager()
print("Detected package manager: " .. manager)

-- Detect in specific directory
local manager = package_manager.detect_package_manager("/path/to/project")
print("Project uses: " .. manager)
```

### Plugin Integration

```lua
-- Create a plugin that runs package commands with the correct manager
local M = {}
local package_manager = require('utils.package-manager')

function M.install_dependencies()
  local manager = package_manager.detect_package_manager()
  
  if manager == "unknown" then
    vim.notify("No package manager detected in current directory", vim.log.levels.WARN)
    return
  end
  
  local cmd = manager .. " install"
  vim.notify("Running: " .. cmd)
  vim.cmd("terminal " .. cmd)
end

function M.run_dev_server()
  local manager = package_manager.detect_package_manager()
  
  if manager == "unknown" then
    vim.notify("No package manager detected", vim.log.levels.ERROR)
    return
  end
  
  -- Use appropriate command for each package manager
  local commands = {
    npm = "npm run dev",
    yarn = "yarn dev", 
    bun = "bun dev"
  }
  
  local cmd = commands[manager]
  if cmd then
    vim.cmd("split | terminal " .. cmd)
  else
    vim.notify("Unsupported package manager: " .. manager, vim.log.levels.ERROR)
  end
end

return M
```

### Conditional Logic Based on Package Manager

```lua
local package_manager = require('utils.package-manager')

function setup_project_keymaps()
  local manager = package_manager.detect_package_manager()
  
  if manager == "unknown" then
    return -- No JavaScript project detected
  end
  
  -- Set up keymaps based on detected package manager
  local keymap_opts = { noremap = true, silent = true }
  
  if manager == "bun" then
    -- Bun-specific commands
    vim.keymap.set('n', '<leader>pi', ':terminal bun install<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pd', ':terminal bun dev<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pt', ':terminal bun test<CR>', keymap_opts)
  elseif manager == "yarn" then
    -- Yarn-specific commands
    vim.keymap.set('n', '<leader>pi', ':terminal yarn install<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pd', ':terminal yarn dev<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pt', ':terminal yarn test<CR>', keymap_opts)
  else -- npm or fallback
    -- npm commands
    vim.keymap.set('n', '<leader>pi', ':terminal npm install<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pd', ':terminal npm run dev<CR>', keymap_opts)
    vim.keymap.set('n', '<leader>pt', ':terminal npm test<CR>', keymap_opts)
  end
end
```

### Project Setup Automation

```lua
local package_manager = require('utils.package-manager')

-- Auto-setup function that adapts to detected package manager
function M.setup_javascript_project()
  local manager = package_manager.detect_package_manager()
  
  if manager == "unknown" then
    -- Prompt user to initialize a new project
    vim.ui.select({"npm", "yarn", "bun"}, {
      prompt = "Initialize new JavaScript project with:",
    }, function(choice)
      if choice then
        local init_commands = {
          npm = "npm init -y",
          yarn = "yarn init -y",
          bun = "bun init -y"
        }
        vim.cmd("terminal " .. init_commands[choice])
      end
    end)
    return
  end
  
  -- Project already exists, set up environment
  vim.notify("JavaScript project detected (using " .. manager .. ")")
  
  -- Setup project-specific configurations
  setup_project_keymaps()
  setup_lsp_config(manager)
  setup_debugger_config(manager)
end
```

## ⚠️ Error Handling

The module handles various edge cases gracefully:

### Non-existent Directories
```lua
local manager = package_manager.detect_package_manager("/non/existent/path")
-- Returns: "unknown" (no error thrown)
```

### Permission Issues
```lua
-- Even if files can't be read due to permissions, the function won't crash
local manager = package_manager.detect_package_manager("/restricted/path")
-- Returns: "unknown"
```

### Special Characters in Paths
```lua
-- Handles paths with spaces and special characters
local manager = package_manager.detect_package_manager("/path with spaces/project!")
-- Works correctly
```

## 🧪 Testing

The module includes comprehensive tests covering:

- ✅ Detection of each package manager type
- ✅ Priority order enforcement (bun > yarn > npm > fallback)
- ✅ Handling of missing files and directories
- ✅ Path normalization (with/without trailing slashes)
- ✅ Edge cases (empty files, permission issues, special characters)

Run tests with:
```bash
nvim --headless -c "lua require('plenary.test_harness').test_file('lua/utils/package-manager_spec.lua')"
```

## 🔄 Integration with Other Modules

### With Package Scripts Module

```lua
local package_manager = require('utils.package-manager')
local package_scripts = require('utils.package-scripts')

function M.run_script_with_manager()
  local manager = package_manager.detect_package_manager()
  if manager == "unknown" then
    vim.notify("No package manager detected", vim.log.levels.ERROR)
    return
  end
  
  local scripts, err = package_scripts.get_package_scripts()
  if not scripts then
    vim.notify("Error loading scripts: " .. err, vim.log.levels.ERROR)
    return
  end
  
  -- Present scripts in a picker and run with detected manager
  vim.ui.select(scripts, {
    prompt = "Select script to run with " .. manager .. ":",
    format_item = function(script)
      return script.icon .. " " .. script.name
    end
  }, function(choice)
    if choice then
      local cmd = manager .. " run " .. choice.name
      vim.cmd("terminal " .. cmd)
    end
  end)
end
```

### With Generic Picker

```lua
local package_manager = require('utils.package-manager')
local picker = require('utils.picker')

function M.pick_package_manager_script()
  local manager = package_manager.detect_package_manager()
  
  if manager == "unknown" then
    vim.notify("No JavaScript project detected", vim.log.levels.WARN)
    return
  end
  
  -- Use picker to select package.json scripts
  picker.pick_script(
    vim.fn.getcwd(),
    { patterns = {"package.json"} },
    "Select " .. manager .. " script:",
    function(item) return "📦 " .. item .. " (" .. manager .. ")" end,
    function(selection)
      -- Parse and run the selected script
      -- Implementation would parse package.json and run script
    end
  )
end
```

## 🚀 Performance Notes

- **Fast Detection**: Uses `vim.fn.filereadable()` for efficient file existence checks
- **No Parsing**: Only checks file existence, doesn't parse file contents
- **Caching**: Consider caching results in plugins that call this frequently
- **Minimal I/O**: Single directory scan, no recursive searching

## 🛠️ Customization

### Extending Detection Logic

```lua
-- Create a wrapper that adds custom detection logic
local original_detect = require('utils.package-manager').detect_package_manager

local function extended_detect(cwd)
  local result = original_detect(cwd)
  
  -- Add custom logic for other package managers
  if result == "unknown" then
    cwd = cwd or vim.fn.getcwd()
    
    -- Check for pnpm
    if vim.fn.filereadable(cwd .. "/pnpm-lock.yaml") == 1 then
      return "pnpm"
    end
    
    -- Check for other managers...
  end
  
  return result
end
```

### Project-Specific Overrides

```lua
-- Allow project-specific package manager override
local function detect_with_override(cwd)
  cwd = cwd or vim.fn.getcwd()
  
  -- Check for .nvimrc or similar config file with override
  local override_file = cwd .. "/.package-manager"
  if vim.fn.filereadable(override_file) == 1 then
    local file = io.open(override_file, "r")
    if file then
      local override = file:read("*line"):match("^%s*(.-)%s*$")
      file:close()
      if override and override ~= "" then
        return override
      end
    end
  end
  
  -- Fall back to normal detection
  return require('utils.package-manager').detect_package_manager(cwd)
end
```

## 📚 Related Modules

- **[package-scripts.lua](./package-scripts.md)**: Parse and categorize npm scripts
- **[picker.lua](./picker.md)**: Create interactive pickers for script selection

## 🔗 Dependencies

- **Neovim**: Built-in `vim.fn` functions
- **No external dependencies**: Pure Lua implementation
