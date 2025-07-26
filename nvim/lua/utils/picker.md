# Generic Picker Utility

The `picker.lua` module provides a reusable, flexible interface for creating interactive file and script selectors in Neovim. It intelligently adapts between Telescope and `vim.ui.select` based on availability, ensuring consistent functionality across different Neovim setups.

## 🎯 Purpose

Creates a unified interface for interactive selection that:

- **Adapts automatically** to available UI frameworks (Telescope → vim.ui.select)
- **Provides consistent API** regardless of underlying implementation
- **Handles edge cases** with comprehensive validation and error handling
- **Supports customization** through flexible filtering and formatting options
- **Integrates seamlessly** with other utility modules and plugins

## 📋 API Reference

### Data Types

#### `FilterOptions`
```lua
---@class FilterOptions
---@field patterns? string[] File name patterns to match (e.g., {"*.sh", "*.py"})
---@field executable? boolean Only include executable files
---@field max_depth? number Maximum directory depth to search
---@field type? string File type filter ("f" for files, "d" for directories)
```

### Core Function

#### `pick_script(cwd, filter_options, prompt, format_item_fn, callback)`

Creates an interactive file/script picker with customizable filtering and display options.

**Parameters:**
- `cwd` (string, required): Working directory to search in
- `filter_options` (FilterOptions, optional): Filtering criteria for file selection
- `prompt` (string, required): Text displayed as the picker prompt
- `format_item_fn` (function, optional): Function to format items for display
- `callback` (function, required): Function called with selected item

**Parameter Details:**

**`cwd`**: Must be a valid directory path. The search will be performed recursively from this location.

**`filter_options`**: Table controlling which files are included:
```lua
{
  patterns = {"*.lua", "*.vim"},  -- File patterns to match
  executable = true,              -- Only executable files
  max_depth = 3,                  -- Limit search depth
  type = "f"                      -- File type ("f"=files, "d"=dirs)
}
```

**`format_item_fn`**: Optional function to customize item display:
```lua
function(item_path)
  -- item_path is relative to cwd
  return "📄 " .. item_path  -- Add icon prefix
end
```

**`callback`**: Function executed when user selects an item:
```lua
function(selected_path)
  -- selected_path is relative to cwd
  print("User selected: " .. selected_path)
end
```

**Returns:**
- `nil` (executes asynchronously via UI picker)

**Error Handling:**
- Validates required parameters and shows error notifications
- Handles empty results gracefully with user feedback
- Reports command execution failures with descriptive messages

## 🔧 Usage Examples

### Basic Script Picker

```lua
local picker = require('utils.picker')
-- Simple script selection with basic filtering
picker.pick_script(
  vim.fn.getcwd(),
  { patterns = {"*.sh", "*.py"} },
  "Select a script to execute:",
  function(item) return "📄 " .. item end,
  function(selection)
    vim.cmd('split | terminal ./' .. selection)
  end
)
```

### Advanced Filtering

```lua
local picker = require('utils.picker')
-- Only executable scripts within 2 directory levels
picker.pick_script(
  vim.fn.getcwd(),
  {
    patterns = {"*.sh", "*.py", "*.js"},
    executable = true,
    max_depth = 2
  },
  "Select executable script:",
  function(item)
    -- Add file type icons based on extension
    local ext = item:match("%.([^%.]+)$")
    local icons = { sh = "🐚", py = "🐍", js = "📜" }
    return (icons[ext] or "📄") .. " " .. item
  end,
  function(selection)
    -- Execute script in new terminal split
    vim.cmd('split | terminal ./' .. selection)
  end
)
```

### Configuration File Picker

```lua
local picker = require('utils.picker')
-- Pick Neovim configuration files
function pick_config_file()
  local config_dir = vim.fn.stdpath('config')
  picker.pick_script(
    config_dir,
    { patterns = {"*.lua", "*.vim"} },
    "Select config file to edit:",
    function(item)
      -- Show file path with folder structure
      local parts = vim.split(item, "/")
      local filename = parts[#parts]
      local folder = #parts > 1 and parts[#parts-1] .. "/" or ""
      return "⚙️ " .. folder .. filename
    end,
    function(selection)
      -- Open file in current buffer
      vim.cmd('edit ' .. config_dir .. '/' .. selection)
    end
  )
end
```

### Integration with Package Scripts

```lua
local picker = require('utils.picker')
local package_scripts = require('utils.package-scripts')
local package_manager = require('utils.package-manager')

function pick_and_run_npm_script()
  -- First, detect package manager
  local manager = package_manager.detect_package_manager()
  if manager == "unknown" then
    vim.notify("No package manager detected", vim.log.levels.WARN)
    return
  end
  -- Get available scripts
  local scripts, err = package_scripts.get_package_scripts()
  if not scripts then
    vim.notify("Error loading scripts: " .. err, vim.log.levels.ERROR)
    return
  end
  -- Convert scripts to picker format
  local script_names = {}
  for _, script in ipairs(scripts) do
    table.insert(script_names, script.name)
  end
  -- Create a temporary directory with script "files" for picker
  -- (This is a creative use of the picker for non-file selection)
  vim.ui.select(script_names, {
    prompt = "Select " .. manager .. " script to run:",
    format_item = function(item)
      -- Find the script object for formatting
      for _, script in ipairs(scripts) do
        if script.name == item then
          return script.icon .. " " .. script.name .. " (" .. script.category .. ")"
        end
      end
      return item
    end
  }, function(choice)
    if choice then
      local cmd = manager .. " run " .. choice
      vim.notify("Running: " .. cmd)
      vim.cmd('terminal ' .. cmd)
    end
  end)
end
```

### File Type Specific Pickers

```lua
local picker = require('utils.picker')
-- Specialized pickers for different file types
local M = {}

function M.pick_test_file()
  picker.pick_script(
    vim.fn.getcwd(),
    {
      patterns = {"*test*.js", "*spec*.js", "*.test.lua", "*.spec.lua"},
      max_depth = 5
    },
    "Select test file:",
    function(item)
      return "🧪 " .. item
    end,
    function(selection)
      -- Run the specific test file
      local ext = selection:match("%.([^%.]+)$")
      if ext == "js" then
        vim.cmd('terminal npm test ' .. selection)
      elseif ext == "lua" then
        vim.cmd('terminal nvim --headless -c "lua require(\\'plenary.test_harness\\').test_file(\\'" .. selection .. "\\')"')
      end
    end
  )
end

function M.pick_documentation()
  picker.pick_script(
    vim.fn.getcwd(),
    { patterns = {"*.md", "*.txt", "*.rst"} },
    "Select documentation:",
    function(item)
      return "📚 " .. item
    end,
    function(selection)
      -- Open in preview mode
      vim.cmd('split | edit ' .. selection)
    end
  )
end

return M
```

### Integration with Telescope (Advanced)

When Telescope is available, you can customize the picker behavior:

```lua
local picker = require('utils.picker')
-- The picker automatically detects Telescope and uses it
-- But you can also create direct Telescope integrations:

local function advanced_telescope_picker()
  local has_telescope, telescope = pcall(require, "telescope")
  if not has_telescope then
    vim.notify("Telescope not available", vim.log.levels.WARN)
    return
  end
  -- Use the picker but with pre/post processing
  picker.pick_script(
    vim.fn.getcwd(),
    { patterns = {"*.lua"} },
    "Select Lua file (Telescope):",
    function(item)
      -- Rich formatting for Telescope
      local size = vim.fn.getfsize(item)
      local modified = vim.fn.strftime("%Y-%m-%d", vim.fn.getftime(item))
      return string.format("🌙 %s │ %db │ %s", item, size, modified)
    end,
    function(selection)
      -- Custom action with Telescope features
      vim.cmd('edit ' .. selection)
      vim.notify("Opened: " .. selection)
    end
  )
end
```

## ⚠️ Error Handling

The module provides comprehensive error handling with user-friendly messages:

### Parameter Validation

```lua
-- Missing required parameters
picker.pick_script(nil, {}, "prompt", nil, function() end)
-- Result: "Error: cwd parameter is required"

picker.pick_script("/tmp", {}, nil, nil, function() end)
-- Result: "Error: prompt parameter is required"

picker.pick_script("/tmp", {}, "prompt", nil, "not_a_function")
-- Result: "Error: callback parameter must be a function"
```

### Empty Results Handling

```lua
-- No files match the criteria
picker.pick_script(
  "/empty/directory",
  { patterns = {"*.nonexistent"} },
  "Select file:",
  nil,
  function() end
)
-- Result: "No scripts found in /empty/directory matching patterns: *.nonexistent"
```

### Command Execution Errors

```lua
-- Directory doesn't exist or permission denied
picker.pick_script("/restricted/path", {}, "prompt", nil, function() end)
-- Result: "Error: Failed to execute find command"
```

## 🔄 Advanced Customization

### Custom Filter Logic

```lua
-- Create a wrapper function for custom filtering
local function pick_recent_files()
  local recent_threshold = os.time() - (7 * 24 * 60 * 60) -- 7 days ago
  picker.pick_script(
    vim.fn.getcwd(),
    { patterns = {"*"} },
    "Select recently modified file:",
    function(item)
      local mtime = vim.fn.getftime(item)
      if mtime > recent_threshold then
        local days_ago = math.floor((os.time() - mtime) / (24 * 60 * 60))
        return "📅 " .. item .. " (" .. days_ago .. " days ago)"
      end
      return nil -- Skip old files
    end,
    function(selection)
      vim.cmd('edit ' .. selection)
    end
  )
end
```

### Dynamic Formatting

```lua
local function smart_format(item)
  local ext = item:match("%.([^%.]+)$")
  local stat = vim.loop.fs_stat(item)
  -- File type icons
  local icons = {
    lua = "🌙", js = "📜", py = "🐍", sh = "🐚",
    md = "📝", json = "📋", yaml = "⚙️", yml = "⚙️"
  }
  local icon = icons[ext] or "📄"
  local size = stat and stat.size or 0
  local size_str = size > 1024 and string.format("%.1fK", size/1024) or tostring(size) .. "B"
  return string.format("%s %s │ %s", icon, item, size_str)
end
```

## 🚀 Plugin Integration Examples

### Development Workflow Integration

```lua
-- Create a complete development workflow picker
local M = {}
local picker = require('utils.picker')
local package_manager = require('utils.package-manager')

function M.dev_workflow_picker()
  vim.ui.select({
    "Run Script",
    "Edit Config", 
    "View Logs",
    "Run Tests",
    "Build Project"
  }, {
    prompt = "Development Action:"
  }, function(choice)
    if choice == "Run Script" then
      picker.pick_script(
        vim.fn.getcwd(),
        { patterns = {"*.sh", "package.json"} },
        "Select script:",
        function(item) return "🔧 " .. item end,
        function(selection)
          if selection:match("%.json$") then
            -- Handle package.json scripts
            M.pick_npm_script()
          else
            vim.cmd('terminal ./' .. selection)
          end
        end
      )
    elseif choice == "Edit Config" then
      picker.pick_script(
        vim.fn.stdpath('config'),
        { patterns = {"*.lua", "*.vim"} },
        "Edit config:",
        function(item) return "⚙️ " .. item end,
        function(selection) vim.cmd('edit ' .. selection) end
      )
    -- ... handle other choices
    end
  end)
end

return M
```

### Project Template Picker

```lua
local function pick_project_template()
  local templates_dir = vim.fn.expand("~/.config/templates")
  picker.pick_script(
    templates_dir,
    { patterns = {"*"}, type = "d" }, -- Pick directories
    "Select project template:",
    function(item)
      -- Show template info if available
      local info_file = templates_dir .. "/" .. item .. "/template.info"
      if vim.fn.filereadable(info_file) == 1 then
        local info = vim.fn.readfile(info_file)[1] or "No description"
        return "📁 " .. item .. " - " .. info
      else
        return "📁 " .. item
      end
    end,
    function(selection)
      -- Copy template to current directory
      local source = templates_dir .. "/" .. selection
      local target = vim.fn.getcwd() .. "/" .. vim.fn.input("Project name: ")
      vim.cmd('!cp -r ' .. source .. ' ' .. target)
      vim.notify("Created project from template: " .. selection)
    end
  )
end
```

## 🛡️ Robustness Testing

Includes tests for various edge cases such as invalid callbacks, empty directories, and missing parameters in `/utils/picker_spec.lua`.

## 📚 Related Modules

- **[package-manager.lua](./package-manager.md)**: Detect and manage package-related operations
- **[package-scripts.lua](./package-scripts.md)**: Parse and run npm scripts

## 🔗 Dependencies

- **Neovim**: Core interfaces relying on `vim.fn` and `vim.ui`
- **Optional**: Telescope.nvim for enhanced interaction
