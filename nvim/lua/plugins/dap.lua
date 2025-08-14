return {
	-- Debug Adapter Protocol client implementation for Neovim
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- Creates a beautiful debugger UI
			"rcarriga/nvim-dap-ui",
			-- Required dependency for nvim-dap-ui
			"nvim-neotest/nvim-nio",
		},
		keys = function(_, keys)
			local dap = require("dap")
			local dapui = require("dapui")
			return {
				-- Basic debugging keymaps
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
					"<leader>dc",
					function()
						dap.continue()
					end,
					desc = "Continue",
				},
				{
					"<leader>da",
					function()
						dap.continue({ before = get_args })
					end,
					desc = "Run with Args",
				},
				{
					"<leader>dC",
					function()
						dap.run_to_cursor()
					end,
					desc = "Run to Cursor",
				},
				{
					"<leader>dg",
					function()
						dap.goto_()
					end,
					desc = "Go to Line (No Execute)",
				},
				{
					"<leader>di",
					function()
						dap.step_into()
					end,
					desc = "Step Into",
				},
				{
					"<leader>dj",
					function()
						dap.down()
					end,
					desc = "Down",
				},
				{
					"<leader>dk",
					function()
						dap.up()
					end,
					desc = "Up",
				},
				{
					"<leader>dl",
					function()
						dap.run_last()
					end,
					desc = "Run Last",
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
					"<leader>dp",
					function()
						dap.pause()
					end,
					desc = "Pause",
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

				-- DAP UI keymaps
				{
					"<leader>du",
					function()
						dapui.toggle({})
					end,
					desc = "Dap UI",
				},
				{
					"<leader>de",
					function()
						dapui.eval()
					end,
					desc = "Eval",
					mode = { "n", "v" },
				},

				-- VS Code launch configurations
				{
					"<leader>dv",
					function()
						require("dap.ext.vscode").load_launchjs(nil, { bun = { "typescript", "javascript" } })
					end,
					desc = "Load VS Code launch.json",
				},

				-- Integration with script-runner for debugging scripts
				{
					"<leader>drs",
					function()
						require("dap-script-runner").debug_script()
					end,
					desc = "Debug Script (with script-runner)",
				},
				{
					"<leader>drl",
					function()
						require("dap-script-runner").debug_last_script()
					end,
					desc = "Debug Last Script",
				},
			}
		end,
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Dap UI setup
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})

			-- Change breakpoint icons
			vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)

			-- Automatically open UI
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			-- Configure vscode-js-debug adapter
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				}
			}

			-- Simple attach adapter for existing Node.js processes
			dap.adapters.node = {
				type = "server",
				host = "127.0.0.1",
				port = 9229,
			}

			-- Load VS Code launch.json configurations automatically
			require("dap.ext.vscode").load_launchjs(nil, {
				["pwa-node"] = { "typescript", "javascript" },
				node = { "typescript", "javascript" },
			})

			-- Manual configuration for Node.js/tsx debugging
			dap.configurations.typescript = {
				{
					type = "node",
					request = "attach",
					name = "Attach to Node.js",
					port = 9229,
					host = "localhost",
					sourceMaps = true,
					localRoot = "${workspaceFolder}",
					remoteRoot = "${workspaceFolder}",
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
					-- Add path mapping for TypeScript aliases
					pathMappings = {
						{
							localRoot = "${workspaceFolder}/src",
							remoteRoot = "${workspaceFolder}/src"
						}
					},
					-- Better source map resolution
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**"
					}
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch API Server",
					program = "${workspaceFolder}/node_modules/.bin/tsx",
					args = { "--inspect", "src/api/server.ts" },
					cwd = "${workspaceFolder}",
					env = {
						NODE_ENV = "development",
					},
					sourceMaps = true,
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**"
					}
				},
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug pullLatestSkillMappings",
					program = "${workspaceFolder}/node_modules/.bin/tsx",
					args = { "--inspect", "src/automations/pullLatestSkillMappings/main.ts" },
					cwd = "${workspaceFolder}",
					env = {
						AWS_PROFILE = "emsi-company-micro",
						NODE_ENV = "development",
					},
					sourceMaps = true,
					skipFiles = { "<node_internals>/**", "**/node_modules/**" },
					resolveSourceMapLocations = {
						"${workspaceFolder}/**",
						"!**/node_modules/**"
					}
				},
			}

			-- Copy the same configurations for JavaScript
			dap.configurations.javascript = dap.configurations.typescript

			-- Auto-load VS Code configurations on startup if in a project with launch.json
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					if vim.fn.filereadable(".vscode/launch.json") == 1 then
						require("dap.ext.vscode").load_launchjs(nil, {
							["pwa-node"] = { "typescript", "javascript" },
							node = { "typescript", "javascript" },
						})
					end
				end,
			})
		end,
	},
}
