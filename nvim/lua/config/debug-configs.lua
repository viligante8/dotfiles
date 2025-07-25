-- lua/plugins/tools/debug-configs.lua
-- Debug configurations for Node.js/TypeScript/Bun projects
-- Separated for better maintainability and team sharing

local M = {}

-- Helper function to get project type based on current directory
local function get_project_type()
  local cwd = vim.fn.getcwd()
  if string.match(cwd, 'workday%-integrations') then
    return 'workday-integrations'
  elseif string.match(cwd, 'company%-datastore') then
    return 'company-datastore'
  end
  return nil
end

-- Helper function to check if package.json has a script
local function has_script(script_name)
  local package_json_path = vim.fn.getcwd() .. '/package.json'
  if vim.fn.filereadable(package_json_path) == 0 then
    return false
  end
  
  local package_json = vim.fn.readfile(package_json_path)
  local content = table.concat(package_json, '\n')
  return string.match(content, '"' .. script_name .. '"') ~= nil
end

-- Base debug configuration template
local function create_script_config(name, script_name, description)
  return {
    type = 'pwa-node',
    request = 'launch',
    name = name,
    program = '${workspaceFolder}/node_modules/.bin/bun',
    args = { 'run', script_name },
    cwd = '${workspaceFolder}',
    runtimeExecutable = 'bun',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    env = {
      NODE_ENV = 'development',
    },
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
    skipFiles = {
      '<node_internals>/**',
      'node_modules/**',
    },
  }
end

-- Project-specific configurations
M.project_configs = {
  ['workday-integrations'] = {
    -- API Server
    {
      name = 'Debug API Server',
      script = 'start:api',
      key = 'da',
      description = 'Debug the main API server',
    },
    -- Automations
    {
      name = 'Debug pullLatestSkillMappings',
      script = 'start:pullLatestSkillMappings',
      key = 'dp',
      description = 'Debug pull latest skill mappings automation',
    },
    {
      name = 'Debug pushLatestSkills',
      script = 'start:pushLatestSkills',
      key = 'ds',
      description = 'Debug push latest skills automation',
    },
    {
      name = 'Debug pushOrgSkillsAndMappings',
      script = 'start:pushOrgSkillsAndMappings',
      key = 'do',
      description = 'Debug push org skills and mappings automation',
    },
    {
      name = 'Debug createMaintainedSkills',
      script = 'start:createMaintainedSkills',
      key = 'dm',
      description = 'Debug create maintained skills automation',
    },
    {
      name = 'Debug pushOrgRoles',
      script = 'start:pushOrgRoles',
      key = 'dr',
      description = 'Debug push org roles automation',
    },
    -- Testing
    {
      name = 'Debug API Tests',
      script = 'test:api',
      key = 'dta',
      description = 'Debug API tests with Vitest',
    },
    {
      name = 'Debug Automation Tests',
      script = 'test:automations',
      key = 'dto',
      description = 'Debug automation tests with Vitest',
    },
    {
      name = 'Debug All Tests',
      script = 'test:all',
      key = 'dtA',
      description = 'Debug all tests',
    },
  },
  
  ['company-datastore'] = {
    -- API Server
    {
      name = 'Debug API Server',
      script = 'start:api',
      key = 'da',
      description = 'Debug the main API server',
    },
    -- Automations
    {
      name = 'Debug monthlyRecommendationProcessing',
      script = 'start:monthlyRecommendationProcessing',
      key = 'dm',
      description = 'Debug monthly recommendation processing',
    },
    -- Testing
    {
      name = 'Debug API Tests',
      script = 'test:api',
      key = 'dta',
      description = 'Debug API tests with Vitest',
    },
    {
      name = 'Debug Automation Tests',
      script = 'test:automations',
      key = 'dto',
      description = 'Debug automation tests with Vitest',
    },
    {
      name = 'Debug All Tests',
      script = 'test:all',
      key = 'dtA',
      description = 'Debug all tests',
    },
  },
}

-- Generic configurations (available in all projects)
M.generic_configs = {
  -- Debug current file with Node.js
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch Node.js',
    program = '${file}',
    cwd = '${workspaceFolder}',
    runtimeExecutable = 'node',
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
  },
  -- Debug current file with Bun
  {
    type = 'pwa-node',
    request = 'launch',
    name = 'Launch with Bun',
    program = '${file}',
    cwd = '${workspaceFolder}',
    runtimeExecutable = 'bun',
    runtimeArgs = { 'run' },
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
  },
  -- Attach to running Node.js process
  {
    type = 'pwa-node',
    request = 'attach',
    name = 'Attach to Node.js',
    processId = require('dap.utils').pick_process,
    cwd = '${workspaceFolder}',
    sourceMaps = true,
    protocol = 'inspector',
    resolveSourceMapLocations = {
      '${workspaceFolder}/**',
      '!**/node_modules/**',
    },
  },
}

-- Generate all configurations for DAP
function M.get_configurations()
  local configs = {}
  
  -- Add generic configurations
  for _, config in ipairs(M.generic_configs) do
    table.insert(configs, config)
  end
  
  -- Add project-specific configurations
  local project_type = get_project_type()
  if project_type and M.project_configs[project_type] then
    for _, project_config in ipairs(M.project_configs[project_type]) do
      if has_script(project_config.script) then
        local config = create_script_config(
          project_config.name,
          project_config.script,
          project_config.description
        )
        table.insert(configs, config)
      end
    end
  end
  
  return configs
end

-- Setup project-specific keymaps
function M.setup_keymaps()
  local project_type = get_project_type()
  if not project_type or not M.project_configs[project_type] then
    return
  end
  
  for _, project_config in ipairs(M.project_configs[project_type]) do
    if has_script(project_config.script) then
      local keymap = '<leader>' .. project_config.key
      vim.keymap.set('n', keymap, function()
        -- Find the configuration by name and run it
        local dap = require('dap')
        local configs = dap.configurations.typescript or dap.configurations.javascript
        for _, config in ipairs(configs) do
          if config.name == project_config.name then
            dap.run(config)
            return
          end
        end
        vim.notify('Debug configuration "' .. project_config.name .. '" not found', vim.log.levels.ERROR)
      end, { 
        desc = 'Debug: ' .. project_config.description,
        silent = true 
      })
    end
  end
end

-- Quick selector for available debug configurations
function M.select_debug_config()
  local project_type = get_project_type()
  if not project_type or not M.project_configs[project_type] then
    vim.notify('No project-specific debug configurations available', vim.log.levels.WARN)
    return
  end
  
  local available_configs = {}
  for _, project_config in ipairs(M.project_configs[project_type]) do
    if has_script(project_config.script) then
      table.insert(available_configs, {
        name = project_config.name,
        script = project_config.script,
        description = project_config.description,
        key = project_config.key,
      })
    end
  end
  
  if #available_configs == 0 then
    vim.notify('No available debug configurations for this project', vim.log.levels.WARN)
    return
  end
  
  vim.ui.select(available_configs, {
    prompt = 'Select debug configuration:',
    format_item = function(item)
      return string.format('%s (<leader>%s) - %s', item.name, item.key, item.description)
    end,
  }, function(choice)
    if choice then
      local dap = require('dap')
      local configs = dap.configurations.typescript or dap.configurations.javascript
      for _, config in ipairs(configs) do
        if config.name == choice.name then
          dap.run(config)
          return
        end
      end
    end
  end)
end

return M
