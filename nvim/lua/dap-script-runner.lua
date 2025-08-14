-- Integration between DAP and script-runner.nvim
-- This module allows debugging package.json scripts using your script-runner plugin

local M = {}

-- State to track last debugged script
local state = {
  last_script = nil,
  last_manager = nil,
}

-- Function to get package manager and scripts (similar to your script-runner)
local function get_package_info()
  local package_json_path = vim.fn.findfile("package.json", ".;")
  if package_json_path == "" then
    vim.notify("No package.json found", vim.log.levels.ERROR)
    return nil
  end

  local package_json = vim.fn.json_decode(vim.fn.readfile(package_json_path))
  if not package_json or not package_json.scripts then
    vim.notify("No scripts found in package.json", vim.log.levels.ERROR)
    return nil
  end

  -- Detect package manager (simplified version)
  local manager = "bun" -- Default to bun for your project
  if vim.fn.filereadable("yarn.lock") == 1 then
    manager = "yarn"
  elseif vim.fn.filereadable("pnpm-lock.yaml") == 1 then
    manager = "pnpm"
  elseif vim.fn.filereadable("package-lock.json") == 1 then
    manager = "npm"
  end

  return {
    scripts = package_json.scripts,
    manager = manager,
    cwd = vim.fn.fnamemodify(package_json_path, ":h")
  }
end

-- Function to create debug configuration for a script
local function create_debug_config(script_name, script_command, manager, cwd)
  local config = {
    type = "bun", -- Use bun adapter
    request = "launch",
    name = "Debug: " .. script_name,
    runtimeExecutable = manager,
    runtimeArgs = { "run" },
    cwd = cwd,
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  }

  -- Add the script name to runtime args
  table.insert(config.runtimeArgs, script_name)

  -- Add environment variables for specific scripts
  if script_name:match("pullLatestSkillMappings") or script_name:match("pushLatestSkills") then
    config.env = {
      AWS_PROFILE = "emsi-company-micro",
    }
  end

  -- Add inspect flag for debugging
  if manager == "bun" then
    table.insert(config.runtimeArgs, 2, "--inspect-wait")
  elseif manager == "node" or manager == "npm" then
    table.insert(config.runtimeArgs, 2, "--inspect-brk")
  end

  return config
end

-- Function to show script picker and debug selected script
function M.debug_script()
  local package_info = get_package_info()
  if not package_info then
    return
  end

  local scripts = package_info.scripts
  local script_names = {}
  for name, _ in pairs(scripts) do
    table.insert(script_names, name)
  end

  if #script_names == 0 then
    vim.notify("No scripts found", vim.log.levels.WARN)
    return
  end

  -- Sort scripts for better UX
  table.sort(script_names)

  -- Use vim.ui.select for script selection
  vim.ui.select(script_names, {
    prompt = "Select script to debug:",
    format_item = function(item)
      return string.format("🐛 %s - %s", item, scripts[item])
    end,
  }, function(selected)
    if not selected then
      return
    end

    -- Store for "debug last" functionality
    state.last_script = selected
    state.last_manager = package_info.manager

    -- Create and run debug configuration
    local debug_config = create_debug_config(
      selected,
      scripts[selected],
      package_info.manager,
      package_info.cwd
    )

    local dap = require("dap")
    dap.run(debug_config)
  end)
end

-- Function to debug the last selected script
function M.debug_last_script()
  if not state.last_script then
    vim.notify("No previous script to debug", vim.log.levels.WARN)
    return
  end

  local package_info = get_package_info()
  if not package_info then
    return
  end

  local scripts = package_info.scripts
  if not scripts[state.last_script] then
    vim.notify("Last script '" .. state.last_script .. "' not found", vim.log.levels.ERROR)
    return
  end

  local debug_config = create_debug_config(
    state.last_script,
    scripts[state.last_script],
    package_info.manager,
    package_info.cwd
  )

  local dap = require("dap")
  dap.run(debug_config)
end

-- Function to start a script with debugging enabled (for attach mode)
function M.start_script_with_debug(script_name)
  local package_info = get_package_info()
  if not package_info then
    return
  end

  local scripts = package_info.scripts
  if not scripts[script_name] then
    vim.notify("Script '" .. script_name .. "' not found", vim.log.levels.ERROR)
    return
  end

  -- Build command with debug flags
  local cmd = {}
  if package_info.manager == "bun" then
    cmd = { "bun", "--inspect-wait=0.0.0.0:6499", "run", script_name }
  elseif package_info.manager == "node" then
    cmd = { "node", "--inspect-brk=0.0.0.0:6499", "run", script_name }
  else
    cmd = { package_info.manager, "run", script_name }
  end

  -- Add environment variables if needed
  local env = {}
  if script_name:match("pullLatestSkillMappings") or script_name:match("pushLatestSkills") then
    env.AWS_PROFILE = "emsi-company-micro"
  end

  -- Start the process
  vim.fn.jobstart(cmd, {
    cwd = package_info.cwd,
    env = env,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line:match("Debugger listening") or line:match("Inspector listening") then
            vim.notify("🐛 Debugger ready on port 6499! Use <leader>da to attach.", vim.log.levels.INFO)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then
            print("Debug: " .. line)
          end
        end
      end
    end,
  })
end

-- Function to quickly attach to a running debug process
function M.attach_to_debug()
  local dap = require("dap")
  dap.run({
    type = "bun",
    request = "attach",
    name = "Attach to Debug Process",
    port = 6499,
    host = "localhost",
  })
end

return M
