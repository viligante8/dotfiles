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
			local vscode = require("dap.ext.vscode")

			-- Make dap config & process selection use Telescope dropdown
			require("telescope").setup({
				extensions = {
					["ui-select"] = { require("telescope.themes").get_dropdown() },
				},
			})
			require("telescope").load_extension("ui-select")

			-- DAP UI setup
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
		end,
	},
}
