return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Test adapters
      "nvim-neotest/neotest-jest",
      "nvim-neotest/neotest-vitest", 
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      "rouge8/neotest-rust",
      "lawrence-laz/neotest-zig",
    },
    config = function()
      -- Helper function to get test command using script-runner detection
      local function get_smart_test_command()
        local script_runner_ok, script_runner = pcall(require, "script-runner")
        if not script_runner_ok or not script_runner.has_package_json() then
          return "npm test"
        end
        
        -- Get the package manager from script-runner
        local manager = script_runner.get_package_manager()
        if manager == "unknown" then
          manager = "npm"
        end
        
        -- Get available scripts and find the best test script
        local scripts = script_runner.get_available_scripts()
        local test_script = nil
        
        -- Priority order for test scripts
        local test_priorities = { "test", "test:unit", "test:all", "test:run" }
        
        for _, priority_script in ipairs(test_priorities) do
          for _, script_name in ipairs(scripts) do
            if script_name == priority_script then
              test_script = script_name
              break
            end
          end
          if test_script then break end
        end
        
        -- If no exact match, find any script containing "test"
        if not test_script then
          for _, script_name in ipairs(scripts) do
            if script_name:match("test") then
              test_script = script_name
              break
            end
          end
        end
        
        -- Build the command
        if test_script then
          if manager == "bun" then
            return "bun run " .. test_script
          elseif manager == "pnpm" then
            return "pnpm run " .. test_script
          elseif manager == "yarn" then
            return "yarn run " .. test_script
          else
            return "npm run " .. test_script
          end
        else
          -- Fallback to basic test command
          if manager == "bun" then
            return "bun test"
          elseif manager == "pnpm" then
            return "pnpm test"
          elseif manager == "yarn" then
            return "yarn test"
          else
            return "npm test"
          end
        end
      end
      
      -- Defer setup to avoid fast event issues
      vim.defer_fn(function()
        local neotest = require("neotest")
        
        neotest.setup({
          adapters = {
            -- JavaScript/TypeScript with smart command detection
            require("neotest-jest")({
              jestCommand = get_smart_test_command(),
              jestConfigFile = function()
                local configs = {
                  "jest.config.js", "jest.config.ts", "jest.config.mjs",
                  "jest.config.json", ".jestrc.js", ".jestrc.json"
                }
                for _, config in ipairs(configs) do
                  if vim.fn.filereadable(vim.fn.getcwd() .. "/" .. config) == 1 then
                    return config
                  end
                end
                return nil
              end,
              env = { CI = true },
              cwd = function()
                return vim.fn.getcwd()
              end,
            }),
            
            require("neotest-vitest")({
              vitestCommand = get_smart_test_command(),
              filter_dir = function(name, rel_path, root)
                return name ~= "node_modules"
              end,
            }),
            
            -- Other adapters remain the same
            require("neotest-go")({
              experimental = { test_table = true },
              args = { "-count=1", "-timeout=60s" },
            }),
            
            require("neotest-python")({
              dap = { 
                justMyCode = false,
                console = "integratedTerminal",
              },
              args = { "--tb=short", "-v" },
              runner = "pytest",
            }),
            
            require("neotest-rust")({
              args = { "--no-capture" },
              dap_adapter = "lldb",
            }),
            
            require("neotest-zig"),
          },
          
          -- Enable discovery for better test detection
          discovery = { 
            enabled = true, 
            concurrent = 1,
            filter_dir = function(name, rel_path, root)
              -- Skip common non-test directories
              local skip_dirs = { "node_modules", ".git", "dist", "build", ".next", "coverage" }
              return not vim.tbl_contains(skip_dirs, name)
            end,
          },
          running = { concurrent = true },
          summary = { enabled = true, animated = false, follow = false, expand_errors = true },
          output = { enabled = true, open_on_run = "short" },
          output_panel = { enabled = true, open = "botright split | resize 15" },
          quickfix = { enabled = false, open = false },
          status = { enabled = true, virtual_text = false, signs = true },
          
          strategies = {
            integrated = { height = 40, width = 120 },
          },
          
          icons = {
            child_indent = "│", child_prefix = "├", collapsed = "─", expanded = "╮",
            failed = "✖", final_child_indent = " ", final_child_prefix = "╰",
            non_collapsible = "─", passed = "✓", running = "󰑮",
            running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
            skipped = "○", unknown = "?", watching = "👁",
          },
          
          floating = { border = "rounded", max_height = 0.6, max_width = 0.6, options = {} },
          diagnostic = { enabled = false, severity = vim.diagnostic.severity.ERROR },
        })
      end, 100)
    end,
    
    keys = {
      -- Standard neotest commands (now using smart detection)
      { "<leader>tt", function() require("neotest").run.run() end, desc = "🧪 Run Nearest Test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "🧪 Run Current File Tests" },
      { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "🧪 Run All Tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "🧪 Run Last Test" },
      
      -- Debug tests
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "🐛 Debug Nearest Test" },
      
      -- Test UI
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "📋 Show Test Output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "📋 Toggle Output Panel" },
      { "<leader>tS", function() require("neotest").summary.toggle() end, desc = "📊 Toggle Test Summary" },
      
      -- Test navigation
      { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "🧪 Next Failed Test" },
      { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "🧪 Previous Failed Test" },
      
      -- Test management
      { "<leader>tc", function() require("neotest").run.stop() end, desc = "⏹️ Stop Tests" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "👁 Watch Current File" },
      
      -- Script-runner backup (for when neotest doesn't work)
      {
        "<leader>trs",
        function()
          local script_runner_ok, script_runner = pcall(require, "script-runner")
          if script_runner_ok then
            script_runner.run_category("test")
          else
            vim.notify("Script-runner not available", vim.log.levels.WARN)
          end
        end,
        desc = "🎯 Run Test Scripts (Script-Runner Backup)"
      },
      
      -- Project info with test command detection
      {
        "<leader>ti",
        function()
          local cwd = vim.fn.getcwd()
          local info = {}
          
          -- Show what neotest will use
          local script_runner_ok, script_runner = pcall(require, "script-runner")
          if script_runner_ok and script_runner.has_package_json() then
            local manager = script_runner.get_package_manager()
            table.insert(info, "📦 Package Manager: " .. manager)
            
            local scripts = script_runner.get_available_scripts()
            local test_scripts = {}
            for _, script_name in ipairs(scripts) do
              if script_name:match("test") then
                table.insert(test_scripts, script_name)
              end
            end
            
            if #test_scripts > 0 then
              table.insert(info, "🧪 Test Scripts: " .. table.concat(test_scripts, ", "))
              
              -- Show what command neotest will use
              local test_cmd = "Unknown"
              if #test_scripts > 0 then
                if manager == "bun" then
                  test_cmd = "bun run " .. test_scripts[1]
                elseif manager == "pnpm" then
                  test_cmd = "pnpm run " .. test_scripts[1]
                elseif manager == "yarn" then
                  test_cmd = "yarn run " .. test_scripts[1]
                else
                  test_cmd = "npm run " .. test_scripts[1]
                end
              end
              table.insert(info, "⚡ Neotest Command: " .. test_cmd)
            else
              table.insert(info, "⚠️ No test scripts found")
            end
          else
            table.insert(info, "❌ No package.json found")
          end
          
          -- Detect project type
          if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
            table.insert(info, "🐹 Project Type: Go")
          elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
            table.insert(info, "🦀 Project Type: Rust")
          elseif vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
            table.insert(info, "🐍 Project Type: Python")
          elseif vim.fn.filereadable(cwd .. "/package.json") == 1 then
            table.insert(info, "📜 Project Type: Node.js")
          end
          
          if #info == 0 then
            table.insert(info, "ℹ️ No project detected")
          end
          
          vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Project Info" })
        end,
        desc = "ℹ️ Show Project & Test Info"
      },
    },
  },
}
