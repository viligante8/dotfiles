return {
	{
		"williamboman/mason.nvim",
		config = true,
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		keys = function(_, keys)
			local dap = require("dap")
			local dapui = require("dapui")
			return {
				{
					"<leader>dB",
					function()
						dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
					end,
					desc = "Breakpoint Condition",
				},
				{
					"<leader>db",
					function()
						dap.toggle_breakpoint()
					end,
					desc = "Toggle Breakpoint",
				},
				{
					"<leader>dd",
					function()
						dap.continue()
					end,
					desc = "Continue",
				},
				{
					"<leader>di",
					function()
						dap.step_into()
					end,
					desc = "Step Into",
				},
				{
					"<leader>do",
					function()
						dap.step_out()
					end,
					desc = "Step Out",
				},
				{
					"<leader>dO",
					function()
						dap.step_over()
					end,
					desc = "Step Over",
				},
				{
					"<leader>dr",
					function()
						dap.repl.toggle()
					end,
					desc = "Toggle REPL",
				},
				{
					"<leader>ds",
					function()
						dap.session()
					end,
					desc = "Session",
				},
				{
					"<leader>dt",
					function()
						dap.terminate()
					end,
					desc = "Terminate",
				},
				{
					"<leader>dw",
					function()
						require("dap.ui.widgets").hover()
					end,
					desc = "Widgets",
				},
				{
					"<leader>du",
					function()
						dapui.toggle({})
					end,
					desc = "DAP UI",
				},
				{
					"<leader>de",
					function()
						dapui.eval()
					end,
					desc = "Eval",
					mode = { "n", "v" },
				},
			}
		end,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Make dap config & process selection use Telescope dropdown
			require("telescope").setup({
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			require("telescope").load_extension("ui-select")

			-- DAP UI
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- Install js-debug-adapter
			require("mason-nvim-dap").setup({
				ensure_installed = { "js-debug-adapter" },
				automatic_installation = true,
			})

			-- Path to js-debug-adapter installed by Mason
			local js_debug_path = vim.fn.stdpath("data")
				.. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = { js_debug_path, "${port}" },
				},
			}

			-- Debug configurations
			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch API (tsx)",
					runtimeExecutable = "node",
					runtimeArgs = { "--inspect-brk", "./node_modules/.bin/tsx" },
					args = { "src/api/server.ts" },
					cwd = "${workspaceFolder}",
					sourceMaps = true,
					protocol = "inspector",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug Vitest",
					runtimeExecutable = "node",
					runtimeArgs = { "--inspect-brk", "./node_modules/.bin/vitest", "run" },
					cwd = "${workspaceFolder}",
					console = "integratedTerminal",
					internalConsoleOptions = "neverOpen",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
				},
			}

			dap.configurations.javascript = dap.configurations.typescript
		end,
	},
}
