return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Custom header with NEOVIM
		dashboard.section.header.val = {
			"",
			"",
			"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
			"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
			"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
			"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
			"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
			"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			"",
		}

		-- ASCII block letters for time (your exact digits from dashboard)
		local function get_ascii_time()
			local time = os.date("%H:%M:%S")
			local digits = {
				["0"] = {
					"███████╗",
					"██╔══██║",
					"██║  ██║",
					"██║  ██║",
					"╚█████╔╝",
				},
				["1"] = {
					"   ██╗  ",
					"   ██║  ",
					"   ██║  ",
					"   ██║  ",
					"   ██║  ",
				},
				["2"] = {
					"███████╗",
					"╚════██║",
					"██████╔╝",
					"██╔═══╝ ",
					"███████╗",
				},
				["3"] = {
					"███████╗",
					"╚════██║",
					"██████╔╝",
					"╚════██║",
					"██████╔╝",
				},
				["4"] = {
					"██╗  ██║",
					"██║  ██║",
					"███████║",
					"╚════██║",
					"     ██║",
				},
				["5"] = {
					"███████╗",
					"██╔═══╝ ",
					"███████╗",
					"╚════██║",
					"██████╔╝",
				},
				["6"] = {
					"███████╗",
					"██╔═══╝ ",
					"███████╗",
					"██╔══██║",
					"██████╔╝",
				},
				["7"] = {
					"███████╗",
					"╚════██║",
					"     ██║",
					"     ██║",
					"     ██║",
				},
				["8"] = {
					"███████╗",
					"██╔══██║",
					"███████║",
					"██╔══██║",
					"██████╔╝",
				},
				["9"] = {
					"███████╗",
					"██╔══██║",
					"╚██████║",
					"╚════██║",
					" █████╔╝",
				},
				[":"] = {
					"    ",
					" ██╗",
					" ╚═╝",
					" ██╗",
					" ╚═╝",
				},
			}

			local lines = { "", "", "", "", "" }
			for i = 1, #time do
				local char = time:sub(i, i)
				local digit = digits[char]
				if digit then
					for j = 1, 5 do
						lines[j] = lines[j] .. digit[j] .. "  "
					end
				end
			end

			return lines
		end

		-- ASCII block letters for date (your exact digits from dashboard)
		local function get_ascii_date()
			local day = os.date("%A"):upper()
			local date = os.date("%B %d"):upper()
			local digits = {
				["0"] = {
					"███████╗",
					"██╔══██║",
					"██║  ██║",
					"██║  ██║",
					"╚█████╔╝",
				},
				["1"] = {
					"   ██╗  ",
					"   ██║  ",
					"   ██║  ",
					"   ██║  ",
					"   ██║  ",
				},
				["2"] = {
					"███████╗",
					"╚════██║",
					"██████╔╝",
					"██╔═══╝ ",
					"███████╗",
				},
				["3"] = {
					"███████╗",
					"╚════██║",
					"██████╔╝",
					"╚════██║",
					"██████╔╝",
				},
				["4"] = {
					"██╗  ██║",
					"██║  ██║",
					"███████║",
					"╚════██║",
					"     ██║",
				},
				["5"] = {
					"███████╗",
					"██╔═══╝ ",
					"███████╗",
					"╚════██║",
					"██████╔╝",
				},
				["6"] = {
					"███████╗",
					"██╔═══╝ ",
					"███████╗",
					"██╔══██║",
					"██████╔╝",
				},
				["7"] = {
					"███████╗",
					"╚════██║",
					"     ██║",
					"     ██║",
					"     ██║",
				},
				["8"] = {
					"███████╗",
					"██╔══██║",
					"███████║",
					"██╔══██║",
					"██████╔╝",
				},
				["9"] = {
					"███████╗",
					"██╔══██║",
					"╚██████║",
					"╚════██║",
					" █████╔╝",
				},
				[":"] = {
					"    ",
					" ██╗",
					" ╚═╝",
					" ██╗",
					" ╚═╝",
				},
				["M"] = {
					"██╗  ██║ ",
					"███████║ ",
					"██╔█╔██║ ",
					"██║╚╝██║ ",
					"██║  ██║ ",
				},
				["O"] = {
					"██████╗  ",
					"██╔══██║ ",
					"██║  ██║ ",
					"██║  ██║ ",
					"╚█████╔╝ ",
				},
				["N"] = {
					"██╗  ██║ ",
					"███╗ ██║ ",
					"██╔█╗██║ ",
					"██║ ███║ ",
					"██║ ╚██║ ",
				},
				["D"] = {
					"██████╗  ",
					"██╔══██║ ",
					"██║  ██║ ",
					"██║  ██║ ",
					"█████╔╝  ",
				},
				["A"] = {
					"╔█████╗  ",
					"██╔══██║ ",
					"███████║ ",
					"██╔══██║ ",
					"██║  ██║ ",
				},
				["Y"] = {
					"██╗  ██║ ",
					"██║  ██║ ",
					"╚█████╔╝ ",
					" ╚██╔╝   ",
					"  ██║    ",
				},
				["T"] = {
					"███████╗ ",
					"╚══██╔═╝ ",
					"   ██║   ",
					"   ██║   ",
					"   ██║   ",
				},
				["U"] = {
					"██╗  ██║ ",
					"██║  ██║ ",
					"██║  ██║ ",
					"██║  ██║ ",
					"╚█████╔╝ ",
				},
				["E"] = {
					"███████╗ ",
					"██╔═══╝  ",
					"█████╗   ",
					"██╔══╝   ",
					"███████╗ ",
				},
				["S"] = {
					"███████╗ ",
					"██╔═══╝  ",
					"███████╗ ",
					"╚════██║ ",
					"██████╔╝ ",
				},
				["W"] = {
					"██╗   ██╗",
					"██║   ██║",
					"██║██ ██║",
					"██║██╔██║",
					"╚██╔╝██╔╝",
				},
				["H"] = {
					"██╗  ██║ ",
					"██║  ██║ ",
					"███████║ ",
					"██╔══██║ ",
					"██║  ██║ ",
				},
				["R"] = {
					"██████╗  ",
					"██╔══██║ ",
					"██████╔╝ ",
					"██╔══██╗ ",
					"██║  ╚██╗",
				},
				["I"] = {
					" ██████╗ ",
					" ╚═██╔═╝ ",
					"   ██║   ",
					"   ██║   ",
					"╔██████╗ ",
				},
				["F"] = {
					"███████╗",
					"██╔═══╝ ",
					"█████╗  ",
					"██╔══╝  ",
					"██║     ",
				},
				["L"] = {
					"██╗     ",
					"██║     ",
					"██║     ",
					"██║     ",
					"███████╗",
				},
				["G"] = {
					"███████╗",
					"██╔═══╝ ",
					"██║ ███╗",
					"██║  ██║",
					"╚█████╔╝",
				},
				["C"] = {
					"███████╗",
					"██╔═══╝ ",
					"██║     ",
					"██║     ",
					"╚██████╗",
				},
				["B"] = {
					"███████╗",
					"██╔══██║",
					"██████╔╝",
					"██╔══██╗",
					"██████╔╝",
				},
				["V"] = {
					"██╗  ██║",
					"██║  ██║",
					"██║  ██║",
					"╚██╗██╔╝",
					" ╚███╔╝ ",
				},
				["J"] = {
					"███████╗",
					"╚═══██╔╝",
					"    ██║ ",
					"    ██║ ",
					"█████╔╝ ",
				},
				["K"] = {
					"██╗  ██║",
					"██║ ██╔╝",
					"████╔╝  ",
					"██╔██╗  ",
					"██║ ╚██╗",
				},
				["Q"] = {
					"╔██████╗",
					"██╔═══██",
					"██║   ██",
					"██║██╔██",
					"╚████╔█ ",
				},
				["X"] = {
					"██╗  ██║",
					" ██╗██╔╝",
					"  ███╔╝ ",
					" ██╔██╗ ",
					"██╔╝╚██╗",
				},
				["Z"] = {
					"███████╗",
					"╚═══██╔╝",
					"  ██╔╝  ",
					" ██╔╝.  ",
					"███████╗",
				},
			}

			local full_text = day .. " " .. date
			local lines = { "", "", "", "", "" }
			for i = 1, #full_text do
				local char = full_text:sub(i, i)
				local digit = digits[char]
				if digit then
					for j = 1, 5 do
						lines[j] = lines[j] .. digit[j] .. "  "
					end
				elseif char == " " then
					for j = 1, 5 do
						lines[j] = lines[j] .. "      "
					end
				end
			end

			return lines
		end

		-- Create manual left-right layout with padding
		local function get_time_date_layout()
			local time_lines = get_ascii_time()
			local date_lines = get_ascii_date()
			local combined = {}

			-- Manual spacing - adjust this number to control separation
			local spacing = string.rep(" ", 20)

			-- Combine time (left) and date (right) with fixed spacing
			for i = 1, 5 do
				local time_line = time_lines[i] or ""
				local date_line = date_lines[i] or ""
				table.insert(combined, time_line .. spacing .. date_line)
			end

			return combined
		end

		-- Live info section - just time on top
		local function get_live_info()
			local time_lines = get_ascii_time()

			local info = {}

			-- Add ASCII time
			for _, line in ipairs(time_lines) do
				table.insert(info, line)
			end

			table.insert(info, "")

			return info
		end

		-- Centered directory and branch info
		local function get_dir_info()
			local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			local info = {}

			-- Directory
			table.insert(info, "📁 " .. cwd)

			-- Get git branch with better error handling
			local git_branch = ""
			local git_result = vim.fn.system("git branch --show-current 2>/dev/null")
			if vim.v.shell_error == 0 and git_result then
				git_branch = git_result:gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
			end
			
			-- Fallback: try git symbolic-ref if --show-current fails
			if git_branch == "" then
				local symbolic_ref = vim.fn.system("git symbolic-ref --short HEAD 2>/dev/null")
				if vim.v.shell_error == 0 and symbolic_ref then
					git_branch = symbolic_ref:gsub("\n", ""):gsub("^%s*(.-)%s*$", "%1")
				end
			end
			
			-- Only add branch info if we successfully got it
			if git_branch ~= "" then
				table.insert(info, "🌿 " .. git_branch)
			end

			-- Get tmux session name
			local tmux_session = vim.fn.system("tmux display-message -p '#S' 2>/dev/null"):gsub("\n", "")
			if tmux_session and tmux_session ~= "" then
				table.insert(info, "🖥️ " .. tmux_session)
			end

			table.insert(info, "")

			return info
		end

		-- Date section for bottom
		local function get_date_footer()
			local date_lines = get_ascii_date()
			local info = { "" }

			-- Add ASCII date
			for _, line in ipairs(date_lines) do
				table.insert(info, line)
			end

			table.insert(info, "")

			return info
		end

		-- Buttons/shortcuts
		dashboard.section.buttons.val = {
			dashboard.button("f", "  Find File", "<cmd>lua require('telescope.builtin').find_files()<CR>"),
			dashboard.button("r", "  Recent Files", "<cmd>lua require('telescope.builtin').oldfiles()<CR>"),
			dashboard.button("g", "  Find Text", "<cmd>lua require('telescope.builtin').live_grep()<CR>"),
			dashboard.button("n", "  New File", "<cmd>enew<CR>"),
			dashboard.button(
				"d",
				"  Dotfiles",
				"<cmd>lua require('telescope.builtin').find_files({cwd = '~/.dotfiles'})<CR>"
			),
			dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<CR>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}

		-- Recent files section as buttons
		local function get_recent_files_section()
			local oldfiles = vim.v.oldfiles or {}
			local buttons = {}
			local max_files = 5
			local count = 0

			-- Cool file type icons
			local function get_file_icon(filename)
				local ext = filename:match("^.+%.(.+)$")
				if not ext then
					return "📄"
				end

				local icons = {
					-- Programming languages
					lua = "🌙",
					py = "🐍",
					js = "⚡",
					ts = "🔷",
					jsx = "⚛️",
					tsx = "⚛️",
					go = "🐹",
					rs = "🦀",
					java = "☕",
					cpp = "⚙️",
					c = "⚙️",
					cs = "🔷",
					php = "🐘",
					rb = "💎",
					swift = "🦉",
					kt = "🎯",
					dart = "🎯",

					-- Web
					html = "🌐",
					css = "🎨",
					scss = "🎨",
					sass = "🎨",
					vue = "💚",
					svelte = "🧡",

					-- Config files
					json = "📋",
					yaml = "📋",
					yml = "📋",
					toml = "📋",
					xml = "📋",
					ini = "⚙️",
					conf = "⚙️",
					config = "⚙️",

					-- Documentation
					md = "📝",
					txt = "📄",
					rst = "📝",

					-- Data
					csv = "📊",
					sql = "🗃️",
					db = "🗃️",

					-- Images
					png = "🖼️",
					jpg = "🖼️",
					jpeg = "🖼️",
					gif = "🖼️",
					svg = "🎨",

					-- Others
					pdf = "📕",
					zip = "📦",
					tar = "📦",
					gz = "📦",
					log = "📜",
					sh = "🐚",
					zsh = "🐚",
					bash = "🐚",
					fish = "🐠",
					vim = "💚",
					nvim = "💚",
				}

				return icons[ext:lower()] or "📄"
			end

			for i = 1, #oldfiles do
				if count >= max_files then
					break
				end

				local file = oldfiles[i]
				if file and file ~= "" then
					local filename = vim.fn.fnamemodify(file, ":t")
					local dir = vim.fn.fnamemodify(file, ":h:t")

					-- Check if file exists and is readable
					if filename ~= "" and vim.fn.filereadable(file) == 1 then
						count = count + 1
						local icon = get_file_icon(filename)
						local display = string.format("%d  %s %s/%s", count, icon, dir, filename)
						local cmd = "<cmd>edit " .. vim.fn.fnameescape(file) .. "<CR>"
						local button = dashboard.button(tostring(count), display, cmd)
						table.insert(buttons, button)
					end
				end
			end

			-- Create a section similar to dashboard.section.buttons
			local section = {
				type = "group",
				val = buttons,
				opts = {
					spacing = 1,
				},
			}

			return section
		end

		-- Custom layout
		local function create_layout()
			local live_info = get_live_info()
			local dir_info = get_dir_info()
			local recent_files_section = get_recent_files_section()
			local date_footer = get_date_footer()

			-- Adjust padding based on screen height
			local screen_height = vim.o.lines
			local top_padding = screen_height > 30 and 2 or 1
			local section_padding = screen_height > 25 and 1 or 0

			local layout = {
				{ type = "padding", val = top_padding },
				dashboard.section.header,
				{ type = "padding", val = section_padding },
				{ type = "text", val = live_info, opts = { hl = "Type", position = "center" } },
				{ type = "text", val = dir_info, opts = { hl = "Comment", position = "center" } },
				{ type = "padding", val = section_padding },
				dashboard.section.buttons,
			}

			-- Only add recent files if we have enough screen space
			if recent_files_section.val and #recent_files_section.val > 0 and screen_height > 20 then
				table.insert(layout, { type = "padding", val = section_padding })
				table.insert(
					layout,
					{ type = "text", val = { "Recent Files:" }, opts = { hl = "Keyword", position = "center" } }
				)
				table.insert(layout, { type = "padding", val = section_padding })
				table.insert(layout, recent_files_section)
			end

			-- Only add date footer if we have enough space
			if screen_height > 25 then
				table.insert(layout, { type = "padding", val = section_padding })
				table.insert(layout, { type = "text", val = date_footer, opts = { hl = "Type", position = "center" } })
			end

			return layout
		end

		-- Set up the dashboard
		dashboard.config.layout = create_layout()

		-- Auto-refresh for live clock
		local timer = vim.loop.new_timer()
		timer:start(
			0,
			1000,
			vim.schedule_wrap(function()
				if vim.bo.filetype == "alpha" then
					dashboard.config.layout = create_layout()
					alpha.redraw()
				end
			end)
		)

		-- Refresh alpha dashboard when git branch changes
		vim.api.nvim_create_autocmd({"BufEnter", "FocusGained"}, {
			callback = function()
				if vim.bo.filetype == "alpha" then
					-- Small delay to ensure git operations are complete
					vim.defer_fn(function()
						dashboard.config.layout = create_layout()
						alpha.redraw()
					end, 100)
				end
			end,
		})

		-- Setup alpha
		alpha.setup(dashboard.config)

		-- Disable folding and scrolling on alpha buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				local buf = vim.api.nvim_get_current_buf()
				local win = vim.api.nvim_get_current_win()

				-- Window-local options
				vim.wo[win].foldenable = false
				vim.wo[win].scrolloff = 0
				vim.wo[win].scrollbind = false

				-- Buffer-local options
				vim.bo[buf].modifiable = false
				vim.bo[buf].swapfile = false
				vim.bo[buf].bufhidden = "wipe"
				vim.bo[buf].buftype = "nofile"

				-- Keys used by alpha dashboard buttons - DON'T disable these
				local button_keys = { "f", "r", "g", "n", "d", "s", "l", "m", "q", "1", "2", "3", "4", "5" }

				-- Disable all scrolling keys (but preserve button keys)
				local keys_to_disable = {
					"j",
					"k",
					"<Up>",
					"<Down>",
					"<C-u>",
					"<C-d>",
					"<C-f>",
					"<C-b>",
					"<PageUp>",
					"<PageDown>",
					"<S-Up>",
					"<S-Down>",
					"<C-y>",
					"<C-e>",
					"gg",
					"G",
					"<Home>",
					"<End>",
					-- Horizontal scrolling
					"h",
					"l",
					"<Left>",
					"<Right>",
					"0",
					"$",
					"^",
					"<S-Left>",
					"<S-Right>",
					"zh",
					"zl",
					"zH",
					"zL",
				}

				-- Helper function to check if key is a button key
				local function is_button_key(key)
					for _, button_key in ipairs(button_keys) do
						if key == button_key then
							return true
						end
					end
					return false
				end

				-- Only disable keys that aren't button keys
				for _, key in ipairs(keys_to_disable) do
					if not is_button_key(key) then
						vim.keymap.set("n", key, "<Nop>", { buffer = buf, silent = true })
					end
				end

				-- Disable mouse scrolling
				vim.keymap.set("n", "<ScrollWheelUp>", "<Nop>", { buffer = buf, silent = true })
				vim.keymap.set("n", "<ScrollWheelDown>", "<Nop>", { buffer = buf, silent = true })
			end,
		})
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
