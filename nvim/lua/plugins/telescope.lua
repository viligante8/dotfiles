return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		-- Files
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		-- Search
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
		-- Git
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
		{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = { "truncate" },
				file_ignore_patterns = {
					"%.git/",
					"node_modules/",
					"%.DS_Store",
					"%.pyc",
					"__pycache__/",
				},
				mappings = {
					i = {
						["<C-CR>"] = actions.to_fuzzy_refine,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-c>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-u>"] = actions.preview_scrolling_up,
						["<C-d>"] = actions.preview_scrolling_down,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
					n = {
						["<C-CR>"] = actions.to_fuzzy_refine,
						["<esc>"] = actions.close,
						["<CR>"] = actions.select_default,
						["<C-x>"] = actions.select_horizontal,
						["<C-v>"] = actions.select_vertical,
						["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
					},
				},
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				sorting_strategy = "ascending",
			},
			pickers = {
				find_files = {
					theme = "dropdown",
					previewer = false,
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
				buffers = {
					theme = "dropdown",
					previewer = false,
					initial_mode = "normal",
				},
				oldfiles = {
					theme = "dropdown",
					previewer = false,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		pcall(telescope.load_extension, "ui-select")

		-- ui-select extension handles vim.ui.select automatically
	end,
}

