-- Intelligent multi-project DAP configuration with auto-detection
return {
  "mfussenegger/nvim-dap",
  optional = true,
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "js", "node2" },
      },
    },
  },
  config = function()
    local dap = require("dap")
    
    -- Helper function to detect package manager
    local function detect_package_manager(cwd)
      cwd = cwd or vim.fn.getcwd()
      
      -- Check for lockfiles in order of preference
      if vim.fn.filereadable(cwd .. "/bun.lock") == 1 then
        return "bun"
      elseif vim.fn.filereadable(cwd .. "/yarn.lock") == 1 then
        return "yarn"
      elseif vim.fn.filereadable(cwd .. "/package-lock.json") == 1 or vim.fn.filereadable(cwd .. "/package.json") == 1 then
        return "npm"
      else
        return "npm" -- fallback
      end
    end
    
    -- Helper function to get package.json scripts with various filtering options
    local function get_package_scripts(cwd, filter_options)
      cwd = cwd or vim.fn.getcwd()
      filter_options = filter_options or {}
      local package_json_path = cwd .. "/package.json"
      
      if vim.fn.filereadable(package_json_path) == 0 then
        return {}
      end
      
      local ok, package_data = pcall(vim.fn.json_decode, vim.fn.readfile(package_json_path))
      if not ok or not package_data.scripts then
        return {}
      end
      
      local scripts = {}
      local lifecycle_prefixes = { "pre", "post" }
      local debug_prefixes = { "start:", "test:" }
      
      for script_name, script_command in pairs(package_data.scripts) do
        local should_include = true
        
        -- Filter lifecycle scripts (default: true)
        if filter_options.filter_lifecycle ~= false then
          for _, prefix in ipairs(lifecycle_prefixes) do
            if script_name:match("^" .. prefix) then
              should_include = false
              break
            end
          end
        end
        
        -- Filter to debug-only scripts (for debugging commands)
        if filter_options.debug_only and should_include then
          local is_debuggable = false
          for _, prefix in ipairs(debug_prefixes) do
            if script_name:match("^" .. prefix) then
              is_debuggable = true
              break
            end
          end
          should_include = is_debuggable
        end
        
        if should_include then
          table.insert(scripts, {
            name = script_name,
            command = script_command,
          })
        end
      end
      
      -- Sort by script name
      table.sort(scripts, function(a, b) return a.name < b.name end)
      return scripts
    end
    
    -- Reusable script picker function
    local function pick_script(cwd, filter_options, prompt, format_item_fn, callback)
      local scripts = get_package_scripts(cwd, filter_options)
      
      if #scripts == 0 then
        vim.notify("No scripts found matching criteria", vim.log.levels.WARN)
        return
      end
      
      vim.ui.select(scripts, {
        prompt = prompt,
        format_item = format_item_fn or function(item)
          return item.name
        end,
      }, function(selected)
        if selected and callback then
          callback(selected)
        end
      end)
    end

    -- Quick debug command with filterable selector
    vim.api.nvim_create_user_command("DebugQuick", function(opts)
      local script = opts.args
      local cwd = vim.fn.getcwd()
      local pm = detect_package_manager(cwd)
      
      -- If script provided as argument, use it directly
      if script ~= "" then
        local runtime_args
        
        if pm == "bun" then
          runtime_args = { "--inspect-brk", "run", script }
        elseif pm == "yarn" then
          runtime_args = { script }
        else -- npm
          runtime_args = { "run", script }
        end
        
        local config = {
          name = "Debug " .. script .. " (" .. pm .. ")",
          type = "pwa-node",
          request = "launch",
          cwd = cwd,
          runtimeExecutable = pm,
          runtimeArgs = runtime_args,
          console = "integratedTerminal",
          sourceMaps = true,
          resolveSourceMapLocations = {
            cwd .. "/**",
            "!**/node_modules/**",
          },
        }
        
        dap.run(config)
        return
      end
      
      -- Show selector for available debug scripts
      pick_script(cwd, { debug_only = true }, "Quick debug script (" .. pm .. "):", function(item)
        return "🚀 " .. item.name
      end, function(selected_script)
        local runtime_args
        
        if pm == "bun" then
          runtime_args = { "--inspect-brk", "run", selected_script.name }
        elseif pm == "yarn" then
          runtime_args = { selected_script.name }
        else -- npm
          runtime_args = { "run", selected_script.name }
        end
        
        local config = {
          name = "Debug " .. selected_script.name .. " (" .. pm .. ")",
          type = "pwa-node",
          request = "launch",
          cwd = cwd,
          runtimeExecutable = pm,
          runtimeArgs = runtime_args,
          console = "integratedTerminal",
          sourceMaps = true,
          resolveSourceMapLocations = {
            cwd .. "/**",
            "!**/node_modules/**",
          },
        }
        
        dap.run(config)
      end)
    end, { nargs = "?", desc = "Quick debug current project script with selector" })

    -- RunScript command for executing scripts directly in terminal
    vim.api.nvim_create_user_command("RunScript", function()
      local cwd = vim.fn.getcwd()
      local pm = detect_package_manager(cwd)
      
      pick_script(cwd, {}, "Select script to run (" .. pm .. "):", function(item)
        local icon = "⚡"
        if item.name:match("^start:") then
          icon = "🚀"
        elseif item.name:match("^test:") then
          icon = "🧪"
        elseif item.name:match("^check:") or item.name:match("^fix:") then
          icon = "🔧"
        elseif item.name:match("^generate:") then
          icon = "⚙️"
        elseif item.name:match("^docker:") then
          icon = "🐳"
        end
        return icon .. " " .. item.name
      end, function(selected_script)
        local command
        if pm == "bun" then
          command = "bun run " .. selected_script.name
        elseif pm == "yarn" then
          command = "yarn " .. selected_script.name
        else -- npm
          command = "npm run " .. selected_script.name
        end
        
        -- Open in a horizontal split terminal
        vim.cmd('split')
        vim.cmd('term ' .. command)
        vim.cmd('startinsert')
      end)
    end, { desc = "Run a package script directly in terminal split" })

    -- Enhanced configurations for DAP menu
    dap.configurations.javascript = {
      {
        name = "🚀 Smart Script Debugger",
        type = "pwa-node",
        request = "launch",
        cwd = "${workspaceFolder}",
        runtimeExecutable = function()
          return detect_package_manager()
        end,
        runtimeArgs = function()
          local scripts = get_package_scripts(nil, { debug_only = true })
          if #scripts == 0 then
            vim.notify("No debuggable scripts found", vim.log.levels.WARN)
            return {}
          end
          
          local selected_script
          vim.ui.select(scripts, {
            prompt = "Select script to debug:",
            format_item = function(item)
              return "🚀 " .. item.name
            end,
          }, function(script)
            selected_script = script
          end)
          
          if not selected_script then return {} end
          
          local pm = detect_package_manager()
          if pm == "bun" then
            return { "--inspect-brk", "run", selected_script.name }
          elseif pm == "yarn" then
            return { selected_script.name }
          else -- npm
            return { "run", selected_script.name }
          end
        end,
        console = "integratedTerminal",
        sourceMaps = true,
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
      {
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
      },
      {
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
      },
    }

    -- Copy configurations for TypeScript
    dap.configurations.typescript = dap.configurations.javascript

    -- Set up adapters
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = 8123,
      executable = {
        command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
        args = { "8123" },
      },
    }

    -- Fallback to node2 adapter if js-debug-adapter is not available
    if not vim.fn.executable("js-debug-adapter") then
      dap.adapters["pwa-node"] = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
        },
      }
    end
  end,
}
