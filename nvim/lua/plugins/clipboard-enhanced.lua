return {
	-- LazyClip for the beautiful UI and clipboard management
	{
		"atiladefreitas/lazyclip",
		config = function()
			require("lazyclip").setup({
				max_history = 50, -- Reasonable history size
				items_per_page = 9, -- Show 9 items per page
				min_chars = 3, -- Lower minimum for short snippets

				window = {
					relative = "editor",
					width = 80, -- Wider for better readability
					height = 15, -- Taller for more items
					border = "rounded",
				},

				keymaps = {
					close_window = "q",
					prev_page = "h",
					next_page = "l",
					paste_selected = "<CR>",
					copy_selected = "y",
					move_up = "k",
					move_down = "j",
					delete_item = "d",
				},
			})
		end,
		keys = {
			{
				"<leader>y",
				function()
					require("lazyclip.ui").open_window()
				end,
				desc = "📋 Clipboard Manager",
			},
		},
		event = { "TextYankPost" },
	},

	-- Enhanced Maccy integration
	{
		"gbprod/yanky.nvim",
		dependencies = { "kkharji/sqlite.lua" },
		config = function()
			require("yanky").setup({
				ring = {
					history_length = 50,
					storage = "sqlite",
					sync_with_numbered_registers = true,
					cancel_event = "update",
					ignore_registers = { "_" },
				},
				picker = {
					select = {
						action = nil, -- Use LazyClip instead
					},
					telescope = {
						use_default_mappings = false, -- We'll use LazyClip
					},
				},
				system_clipboard = {
					sync_with_ring = true,
				},
				highlight = {
					on_put = true,
					on_yank = true,
					timer = 200,
				},
				preserve_cursor_position = {
					enabled = true,
				},
			})

			-- Enhanced Maccy sync with LazyClip integration
			local function sync_maccy_to_lazyclip()
				local maccy_db_path = os.getenv("HOME")
					.. "/Library/Containers/org.p0deje.Maccy/Data/Library/Application Support/Maccy/Storage.sqlite"

				if vim.fn.filereadable(maccy_db_path) == 0 then
					return
				end

				local sqlite = require("sqlite")
				local db = sqlite.open(maccy_db_path)

				if not db then
					return
				end

				-- Get recent items from Maccy
				local query = [[
          SELECT content_preview, created_at, is_pinned 
          FROM clipboard_item 
          WHERE content_preview IS NOT NULL 
          ORDER BY 
            CASE WHEN is_pinned = 1 THEN 0 ELSE 1 END,
            created_at DESC 
          LIMIT 20
        ]]

				local success, result = pcall(db.eval, db, query)
				if not success or not result then
					db:close()
					return
				end

				-- Add Maccy items to LazyClip state
				local lazyclip_state = require("lazyclip.state")

				for _, row in ipairs(result) do
					local content = row.content_preview

					-- Skip if content is not a string or too short
					if type(content) == "string" and content ~= "" and #content > 2 then
						-- Clean up the content
						local cleaned_content = content:gsub("^%s+", ""):gsub("%s+$", "")
						if cleaned_content ~= "" then
							-- Add to LazyClip (it will handle duplicates)
							lazyclip_state.add_item(cleaned_content)
						end
					end
				end

				db:close()
			end

			-- Sync Maccy items when nvim starts
			vim.defer_fn(sync_maccy_to_lazyclip, 1000)

			-- Periodic sync every 30 seconds
			local timer = vim.loop.new_timer()
			timer:start(30000, 30000, vim.schedule_wrap(sync_maccy_to_lazyclip))
		end,

		keys = {
			-- Yanky operations (but use LazyClip for browsing)
			{ "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
			{ "Y", "<Plug>(YankyYank)$", desc = "Yank to end of line" },
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n" }, desc = "Put yanked text after cursor" },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },

			-- Cycle through yanky ring
			{ "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
			{ "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },

			-- Clear yanky history
			-- { "<leader>yc", function() require("yanky.history").clear() end, desc = "🗑️ Clear yank history" },
		},
	},
}
