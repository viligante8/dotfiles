return {
	-- Better clipboard management with maccy sync
	{
		"gbprod/yanky.nvim",
		lazy = false, -- Load immediately so maccy sync works on startup
		dependencies = { 
			"kkharji/sqlite.lua",
			"nvim-telescope/telescope.nvim"
		},
		config = function()
			require("yanky").setup({
				ring = {
					history_length = 10, -- Match maccy sync
					storage = "shada",
					storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db",
					sync_with_numbered_registers = true,
					cancel_event = "update",
					ignore_registers = { "_" },
					update_register_on_cycle = false,
					permanent_wrapper = nil,
				},
				picker = {
					select = {
						action = nil,
					},
					telescope = {
						use_default_mappings = true,
						mappings = nil,
					},
				},
				system_clipboard = {
					sync_with_ring = true,
					clipboard_register = nil,
				},
				highlight = {
					on_put = true,
					on_yank = true,
					timer = 500,
				},
				preserve_cursor_position = {
					enabled = true,
				},
				textobj = {
					enabled = false,
				},
			})
			
			-- Setup maccy sync immediately
			require("config.maccy").setup()
		end,
		keys = {
			-- Single clipboard history (yanky synced with maccy)
			{
				"<leader>p",
				function()
					require("telescope").extensions.yank_history.yank_history()
				end,
				desc = "📋 Clipboard History (Yanky + Maccy)",
			},
			
			-- Override default y/p behavior
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank to system clipboard" },
			{ "Y", "<Plug>(YankyYank)$", desc = "Yank line to system clipboard" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put from system clipboard" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put before from system clipboard" },
			-- Note: Visual mode 'p' is remapped in keymaps.lua to 'P' to preserve register content
			
			-- Yanky navigation (now includes maccy history)
			{ "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through clipboard history" },
			{ "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through clipboard history" },
			
			-- Internal register access if needed
			{ "gy", '"0p', desc = "Put from yank register (no clipboard sync)" },
			{ "gY", '"0P', desc = "Put before from yank register (no clipboard sync)" },
		},
	},
}
