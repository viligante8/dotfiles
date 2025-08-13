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
			local session = vim.env.TMUX_SESSION or "main"
			
			-- Get git branch
			local branch = ""
			local git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
			if git_branch and git_branch ~= "" then
				branch = "  " .. git_branch
			end
			
			return {
				"📁 " .. cwd .. "  🖥️  " .. session .. branch,
				"",
			}
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
			dashboard.button("f", "  Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
			dashboard.button("g", "  Find Text", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("n", "  New File", "<cmd>enew<CR>"),
			dashboard.button("c", "  Config", "<cmd>Telescope find_files cwd=~/.config/nvim<CR>"),
			dashboard.button("d", "  Dotfiles", "<cmd>Telescope find_files cwd=~/.dotfiles<CR>"),
			dashboard.button("s", "  Restore Session", "<cmd>lua require('persistence').load()<CR>"),
			dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<CR>"),
			dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
			dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
		}

		-- Recent files section
		local function get_recent_files()
			local oldfiles = vim.v.oldfiles
			local recent = {}
			local max_files = 5
			
			table.insert(recent, "Recent Files:")
			table.insert(recent, "")
			
			for i = 1, math.min(max_files, #oldfiles) do
				local file = oldfiles[i]
				local filename = vim.fn.fnamemodify(file, ":t")
				local dir = vim.fn.fnamemodify(file, ":h:t")
				if filename ~= "" then
					table.insert(recent, string.format("  %s  %s/%s", "📄", dir, filename))
				end
			end
			
			return recent
		end

		-- Custom layout
		local function create_layout()
			local live_info = get_live_info()
			local dir_info = get_dir_info()
			local recent_files = get_recent_files()
			local date_footer = get_date_footer()
			
			return {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 1 },
				{ type = "text", val = live_info, opts = { hl = "Type", position = "center" } },
				{ type = "text", val = dir_info, opts = { hl = "Comment", position = "center" } },
				{ type = "padding", val = 1 },
				dashboard.section.buttons,
				{ type = "padding", val = 1 },
				{ type = "text", val = recent_files, opts = { hl = "Keyword", position = "center" } },
				{ type = "padding", val = 1 },
				{ type = "text", val = date_footer, opts = { hl = "Type", position = "center" } },
			}
		end

		-- Set up the dashboard
		dashboard.config.layout = create_layout()

		-- Auto-refresh for live clock
		local timer = vim.loop.new_timer()
		timer:start(0, 1000, vim.schedule_wrap(function()
			if vim.bo.filetype == "alpha" then
				dashboard.config.layout = create_layout()
				alpha.redraw()
			end
		end))

		-- Setup alpha
		alpha.setup(dashboard.config)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
