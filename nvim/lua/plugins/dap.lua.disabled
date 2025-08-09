return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = {
        {
          "microsoft/vscode-js-debug",
          build = "npm install --legacy-peer-deps && npm install -g @vscode/vsce && npx gulp vsDebugServerBundle && mv dist out",
        },
      },
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Setup DAP UI
    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    -- Setup vscode-js-debug
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    -- TypeScript/JavaScript configurations
    for _, language in ipairs({ "typescript", "javascript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch Bun File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "bun",
          runtimeArgs = { "--inspect-wait" },
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch API Server",
          program = "${workspaceFolder}/src/api/server.ts",
          cwd = "${workspaceFolder}",
          runtimeExecutable = "bun",
          runtimeArgs = { "--inspect-wait" },
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
          env = {
            NODE_ENV = "development",
          },
        },
      }
    end

    -- Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Keymaps (LazyVim style)
    vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
    vim.keymap.set("n", "<leader>da", dap.continue, { desc = "Run with Args" })
    vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
    vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
    vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })
    vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
    vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Breakpoint Condition" })
    vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Dap UI" })
    vim.keymap.set({ "n", "v" }, "<leader>de", dapui.eval, { desc = "Eval" })
  end,
}