-- Debug Configurations Utility
--
-- This module provides reusable debug configurations for different runtime environments
-- with intelligent package manager detection and script selection.
--
-- Features:
--   • Smart script debugger with package manager detection
--   • Current file debugging
--   • Process attachment debugging
--   • Bun/Yarn/NPM support with appropriate flags
--   • Integration with package-scripts utility
--
-- Usage:
--   local debug_configs = require('utils.debug-configs')
--   dap.configurations.javascript = debug_configs.get_javascript_configs()
--   dap.configurations.typescript = debug_configs.get_typescript_configs()

---@class DebugConfigs
local M = {}

-- Get the required utilities
local function get_utils()
  local package_manager = require("utils.package-manager")
  local package_scripts = require("utils.package-scripts")
  local picker = require("utils.picker")
  
  return {
    detect_package_manager = package_manager.detect_package_manager,
    get_package_scripts = package_scripts.get_package_scripts,
    pick_script = picker.pick_script
  }
end

---Create a smart script debugger configuration with DAP input variables
---@return table debug_config
local function create_smart_script_debugger()
  return {
    name = "🚀 Smart Script Debugger",
    type = "pwa-node",
    request = "launch",
    cwd = "${workspaceFolder}",
    runtimeExecutable = function()
      -- Synchronous package manager detection for DAP
      local pm = "npm" -- default fallback
      pcall(function()
        local utils = get_utils()
        pm = utils.detect_package_manager()
      end)
      return pm
    end,
    runtimeArgs = function()
      -- Get available debug scripts
      local debug_scripts = {}
      pcall(function()
        local utils = get_utils()
        local all_scripts = utils.get_package_scripts(nil, {})
        if all_scripts then
          for _, script in ipairs(all_scripts) do
            if script.is_debug then
              table.insert(debug_scripts, script)
            end
          end
        end
      end)
      
      if #debug_scripts == 0 then
        vim.notify("No debuggable scripts found", vim.log.levels.WARN)
        return {}
      end
      
      -- Prompt user to select script
      local script_names = {}
      for _, script in ipairs(debug_scripts) do
        table.insert(script_names, script.name)
      end
      
      local choice = vim.fn.inputlist(
        vim.list_extend({"Select debug script:"}, 
        vim.tbl_map(function(idx)
          return string.format("%d. %s", idx, script_names[idx])
        end, vim.fn.range(1, #script_names)))
      )
      
      if choice < 1 or choice > #script_names then
        return {}
      end
      
      local selected_script = script_names[choice]
      local pm = "npm"
      pcall(function()
        local utils = get_utils()
        pm = utils.detect_package_manager()
      end)
      
      if pm == "bun" then
        return { "--inspect", "run", selected_script }
      elseif pm == "yarn" then
        return { selected_script }
      else -- npm
        return { "run", selected_script }
      end
    end,
    console = "integratedTerminal",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    -- Enhanced TypeScript support
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
  }
end

---Create a current file debugger configuration
---@return table debug_config
local function create_current_file_debugger()
  return {
    name = "📁 Debug Current File",
    type = "pwa-node",
    request = "launch",
    program = "${file}",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    console = "integratedTerminal",
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    -- Enhanced TypeScript support
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
  }
end

---Create a process attachment debugger configuration
---@return table debug_config
local function create_process_attach_debugger()
  return {
    name = "🔗 Attach to Process",
    type = "pwa-node",
    request = "attach",
    processId = require('dap.utils').pick_process,
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    -- Enhanced TypeScript support
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
  }
end

---Create NPM-specific attach configuration
---@return table debug_config
local function create_npm_attach_debugger()
  return {
    name = "📦 Attach to NPM Process (--inspect)",
    type = "pwa-node",
    request = "attach",
    port = 9229,
    host = "localhost",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
    -- Note: DAP doesn't support preLaunchTask, start your process with:
    -- npm run <script> -- --inspect
    -- Then use this configuration to attach
  }
end

---Create Yarn-specific attach configuration
---@return table debug_config
local function create_yarn_attach_debugger()
  return {
    name = "🧶 Attach to Yarn Process (--inspect)",
    type = "pwa-node",
    request = "attach",
    port = 9229,
    host = "localhost",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
    -- Note: DAP doesn't support preLaunchTask, start your process with:
    -- yarn <script> --inspect
    -- Then use this configuration to attach
  }
end

---Create Bun-specific attach configuration
---@return table debug_config
local function create_bun_attach_debugger()
  return {
    name = "🥖 Attach to Bun Process (--inspect)",
    type = "pwa-node",
    request = "attach",
    port = 9229,
    host = "localhost",
    cwd = "${workspaceFolder}",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
    -- Note: DAP doesn't support preLaunchTask, start your process with:
    -- bun --inspect run <script>
    -- Then use this configuration to attach
  }
end

---Create a simple script launch configuration (LazyVim compatible)
---@return table debug_config
local function create_simple_script_debugger()
  return {
    name = "⚡ Launch Script (Simple)",
    type = "pwa-node",
    request = "launch",
    cwd = "${workspaceFolder}",
    runtimeExecutable = function()
      -- Detect package manager for runtime
      local pm = "npm" -- default fallback
      pcall(function()
        local utils = get_utils()
        pm = utils.detect_package_manager()
      end)
      return pm
    end,
    runtimeArgs = function()
      local script_name = vim.fn.input("Script name: ")
      if script_name == "" then
        return {}
      end
      
      -- Detect package manager for args
      local pm = "npm"
      pcall(function()
        local utils = get_utils()
        pm = utils.detect_package_manager()
      end)
      
      if pm == "bun" then
        return { "run", script_name }
      elseif pm == "yarn" then
        return { script_name }
      else -- npm
        return { "run", script_name }
      end
    end,
    console = "integratedTerminal",
    sourceMaps = true,
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
    outFiles = {
      "${workspaceFolder}/**/*.js",
      "${workspaceFolder}/dist/**/*.js",
      "${workspaceFolder}/build/**/*.js",
      "${workspaceFolder}/out/**/*.js",
    },
    skipFiles = {
      "<node_internals>/**",
      "${workspaceFolder}/node_modules/**",
    },
  }
end

---Get JavaScript debug configurations
---@return table[] debug_configs Array of debug configurations
function M.get_javascript_configs()
  local configs = {
    create_simple_script_debugger(),
    create_smart_script_debugger(),
    create_current_file_debugger(),
    create_process_attach_debugger(),
  }
  
  -- Add package manager specific attach configurations
  -- Using a more robust package manager detection
  local pm = "unknown"
  pcall(function()
    local utils = get_utils()
    pm = utils.detect_package_manager()
  end)
  
  if pm == "npm" then
    table.insert(configs, create_npm_attach_debugger())
  elseif pm == "yarn" then
    table.insert(configs, create_yarn_attach_debugger())
  elseif pm == "bun" then
    table.insert(configs, create_bun_attach_debugger())
  else
    -- Add all package manager configs if unknown
    table.insert(configs, create_npm_attach_debugger())
    table.insert(configs, create_yarn_attach_debugger())
    table.insert(configs, create_bun_attach_debugger())
  end
  
  return configs
end

---Get TypeScript debug configurations
---@return table[] debug_configs Array of debug configurations
function M.get_typescript_configs()
  -- TypeScript uses the same configurations as JavaScript
  return M.get_javascript_configs()
end

---Get Node.js debug configurations (alias for JavaScript)
---@return table[] debug_configs Array of debug configurations
function M.get_nodejs_configs()
  return M.get_javascript_configs()
end

---Create DAP adapter configurations
---@return table adapters DAP adapter configurations
function M.get_adapters()
  local adapters = {}
  
  -- Primary adapter: pwa-node (js-debug-adapter)
  -- This is the modern adapter that supports better source maps and TypeScript
  -- LazyVim DAP approach: use simple executable without port allocation
  local js_debug_path = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter"
  local js_debug_exists = vim.fn.executable(js_debug_path) == 1
  
  if js_debug_exists then
    adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = js_debug_path,
        args = { "${port}" },
      },
    }
    
    -- Also configure for Chrome-style debugging (for browser-based Node apps)
    adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = js_debug_path,
        args = { "${port}" },
      },
    }
  else
    vim.notify("js-debug-adapter not found. Install with :MasonInstall js-debug-adapter", vim.log.levels.WARN)
  end
  
  -- Fallback adapter: node (legacy node-debug2-adapter)
  local node_debug2_path = vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js"
  local node_debug2_exists = vim.fn.filereadable(node_debug2_path) == 1
  
  if node_debug2_exists then
    adapters["node"] = {
      type = "executable",
      command = "node",
      args = { node_debug2_path },
    }
  else
    -- Fallback to system node if available
    if vim.fn.executable("node") == 1 then
      adapters["node"] = {
        type = "executable",
        command = "node",
        args = {},
      }
    end
  end
  
  return adapters
end

---Setup all debug configurations and adapters for DAP
---@param dap table The nvim-dap module
function M.setup_dap(dap)
  -- Only set up adapters if they don't already exist (LazyVim may have set them up)
  local adapters = M.get_adapters()
  for name, config in pairs(adapters) do
    if not dap.adapters[name] then
      dap.adapters[name] = config
    end
  end
  
  -- Extend existing JavaScript and TypeScript configurations
  -- rather than overriding LazyVim's configurations
  local js_configs = M.get_javascript_configs()
  local ts_configs = M.get_typescript_configs()
  
  -- Merge with existing configurations
  if dap.configurations.javascript then
    -- Prepend our configurations to existing ones
    for i = #js_configs, 1, -1 do
      table.insert(dap.configurations.javascript, 1, js_configs[i])
    end
  else
    dap.configurations.javascript = js_configs
  end
  
  if dap.configurations.typescript then
    -- Prepend our configurations to existing ones
    for i = #ts_configs, 1, -1 do
      table.insert(dap.configurations.typescript, 1, ts_configs[i])
    end
  else
    dap.configurations.typescript = ts_configs
  end
  
  -- Also add configurations for javascriptreact and typescriptreact
  if not dap.configurations.javascriptreact then
    dap.configurations.javascriptreact = js_configs
  end
  
  if not dap.configurations.typescriptreact then
    dap.configurations.typescriptreact = ts_configs
  end
end

return M
