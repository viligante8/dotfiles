--[[
DAP (Debug Adapter Protocol) Configuration with LazyVim Integration

This configuration provides comprehensive debugging support for JavaScript/TypeScript projects,
following LazyVim conventions with lazy-loaded, filetype-specific keymaps.

Keymaps Overview:
=================

Standard DAP Keymaps (Global):
- <leader>dB    Breakpoint Condition
- <leader>db    Toggle Breakpoint  
- <leader>dc    Continue
- <leader>da    Run with Args
- <leader>dC    Run to Cursor
- <leader>dg    Go to line (no execute)
- <leader>di    Step Into
- <leader>dj    Down
- <leader>dk    Up
- <leader>dl    Run Last
- <leader>do    Step Out
- <leader>dO    Step Over
- <leader>dp    Pause
- <leader>dr    Toggle REPL
- <leader>ds    Session
- <leader>dt    Terminate
- <leader>dw    Widgets
- <leader>dh    Hover Variables
- <leader>df    Show Frames
- <leader>dx    Show Scopes

DAP UI Keymaps:
- <leader>du    Toggle DAP UI
- <leader>de    Eval (normal/visual)
- <leader>dE    Evaluate Input
- <leader>dU    Toggle DAP UI Layout 1
- <leader>dv    Toggle DAP UI Layout 2

Telescope DAP Integration:
- <leader>dsc   DAP Commands
- <leader>dsC   DAP Configurations
- <leader>dsb   List Breakpoints
- <leader>dsv   DAP Variables
- <leader>dsf   DAP Frames

Custom JS/TS Keymaps (Filetype-specific):
- <leader>dQ    Debug Quick (Smart Script Debugger)
- <leader>dR    Run Script (Terminal Split)

Custom Commands:
- :DebugQuick   Smart script debugger with package manager detection
- :RunScript    Package.json script runner with picker interface
--]]

return {
  -- DAP configuration following LazyVim's standard pattern
  -- The dap.core and lang.typescript extras are imported in lazy.lua
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          -- Mason DAP will automatically install these adapters
          ensure_installed = {
            "js-debug-adapter",
            "node-debug2-adapter",
          },
          -- Automatic setup via LazyVim extras
          automatic_installation = true,
        },
      },
    },
    keys = {
      -- Standard DAP keymaps (these are provided by LazyVim's dap.core extra, but we ensure they're here)
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { 
        "<leader>da", 
        function() 
          local dap = require("dap")
          dap.continue({ 
            before = function(config)
              local args = vim.fn.input('Arguments: ')
              config.args = vim.split(args, " +")
              return config
            end 
          }) 
        end, 
        desc = "Run with Args" 
      },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      
      -- Additional useful DAP keymaps
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", mode = { "n", "v" } },
      { "<leader>df", function() 
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end, desc = "Show Frames" },
      { "<leader>dx", function() 
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end, desc = "Show Scopes" },
      
      -- Custom keymaps for JavaScript/TypeScript debugging (lazy-loaded and filetype-specific)
      { 
        "<leader>dQ", 
        function() vim.cmd("DebugQuick") end, 
        desc = "Debug Quick (Smart Script Debugger)",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      },
      { 
        "<leader>dR", 
        function() vim.cmd("RunScript") end, 
        desc = "Run Script (Terminal Split)",
        ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      },
    },
    config = function()
      -- Configuration is handled by LazyVim's dap.core extra
      -- TypeScript/JavaScript debugging is handled by lang.typescript extra
      
      -- Add our custom DAP configuration with enhanced JS/TS support
      local dap = require("dap")
      local debug_configs = require("utils.debug-configs")
      
      -- Setup improved JavaScript/TypeScript debugging with proper adapters
      debug_configs.setup_dap(dap)
      
      -- Custom Commands Integration
      -- These commands leverage the existing utility modules to provide
      -- consistent interfaces while maintaining user compatibility
      
      -- Create DebugQuick command
      vim.api.nvim_create_user_command('DebugQuick', function()
        -- Use the smart script debugger from debug-configs
        local js_configs = debug_configs.get_javascript_configs()
        local smart_debugger = nil
        
        -- Find the smart script debugger configuration
        for _, config in ipairs(js_configs) do
          if config.name and config.name:match("Smart Script Debugger") then
            smart_debugger = config
            break
          end
        end
        
        if smart_debugger then
          -- Start debugging with the smart debugger
          dap.run(smart_debugger)
        else
          vim.notify("Smart Script Debugger not found", vim.log.levels.ERROR)
        end
      end, {
        desc = "Debug Quick (Current Project) - Uses smart script debugger with package manager detection"
      })
      
      -- Create RunScript command
      vim.api.nvim_create_user_command('RunScript', function()
        local package_scripts = require("utils.package-scripts")
        local package_manager = require("utils.package-manager")
        local picker = require("utils.picker")
        
        -- Get all available scripts (excluding lifecycle scripts by default)
        local scripts, error = package_scripts.get_package_scripts(nil, {
          exclude_lifecycle = true,
          exclude_debug = false,  -- Include debug scripts for running
        })
        
        if not scripts then
          vim.notify("Error getting scripts: " .. (error or "unknown error"), vim.log.levels.ERROR)
          return
        end
        
        if #scripts == 0 then
          vim.notify("No runnable scripts found in package.json", vim.log.levels.WARN)
          return
        end
        
        -- Use picker to select script
        picker.pick_script(scripts, {
          prompt = "Select script to run:",
          format_item = function(item)
            return item.icon .. " " .. item.name .. " (" .. item.category .. ")"
          end,
        }, function(selected_script)
          if not selected_script then
            return
          end
          
          -- Detect package manager and build command
          local pm = package_manager.detect_package_manager()
          local command
          
          if pm == "bun" then
            command = "bun run " .. selected_script.name
          elseif pm == "yarn" then
            command = "yarn " .. selected_script.name
          else -- npm
            command = "npm run " .. selected_script.name
          end
          
          -- Run the script in a terminal split
          vim.cmd("split")
          vim.cmd("resize 15")
          vim.cmd("terminal " .. command)
          vim.cmd("startinsert")
          
          vim.notify("Running: " .. command, vim.log.levels.INFO)
        end)
      end, {
        desc = "Run Script (Terminal Split) - Select and run package.json scripts in terminal"
      })
      
      -- Custom signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "🔶", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "🚫", texthl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped" })
      
      -- Enhanced DAP settings for better TypeScript debugging
      dap.defaults.fallback.terminal_win_cmd = "50vsplit new"
      dap.defaults.fallback.focus_terminal = true
      
      -- Log DAP messages for debugging
      if vim.fn.has('nvim-0.8') == 1 then
        require('dap').set_log_level('TRACE')
      end
    end,
  },

  -- DAP UI for better debugging experience
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
      -- Additional DAP UI keymaps following LazyVim patterns
      { "<leader>dE", function() require("dapui").eval(vim.fn.input("[DAP] Expression > ")) end, desc = "Evaluate Input" },
      { "<leader>dU", function() require("dapui").toggle({ layout = 1 }) end, desc = "Toggle DAP UI Layout 1" },
      { "<leader>dv", function() require("dapui").toggle({ layout = 2 }) end, desc = "Toggle DAP UI Layout 2" },
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- Virtual text for DAP
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },

  -- Telescope DAP integration for better navigation
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
    keys = {
      { "<leader>dsc", function() require("telescope").extensions.dap.commands({}) end, desc = "DAP Commands" },
      { "<leader>dsC", function() require("telescope").extensions.dap.configurations({}) end, desc = "DAP Configurations" },
      { "<leader>dsb", function() require("telescope").extensions.dap.list_breakpoints({}) end, desc = "List Breakpoints" },
      { "<leader>dsv", function() require("telescope").extensions.dap.variables({}) end, desc = "DAP Variables" },
      { "<leader>dsf", function() require("telescope").extensions.dap.frames({}) end, desc = "DAP Frames" },
    },
    config = function()
      require("telescope").load_extension("dap")
    end,
  },
}
