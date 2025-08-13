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

		-- ASCII block letters for clock (your exact digits from dashboard)
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

		-- Live info section (clock + directory)
		local function get_live_info()
			local date = os.date("%A, %B %d, %Y")
			local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
			local session = vim.env.TMUX_SESSION or "main"
			
			local ascii_time = get_ascii_time()
			local info = {}
			
			-- Add ASCII clock
			for _, line in ipairs(ascii_time) do
				table.insert(info, line)
			end
			
			-- Add spacing and other info
			table.insert(info, "")
			table.insert(info, "📅 " .. date)
			table.insert(info, "📁 " .. cwd .. "  🖥️  " .. session)
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
			local recent_files = get_recent_files()
			
			return {
				{ type = "padding", val = 2 },
				dashboard.section.header,
				{ type = "padding", val = 1 },
				{ type = "text", val = live_info, opts = { hl = "Type", position = "center" } },
				{ type = "padding", val = 1 },
				dashboard.section.buttons,
				{ type = "padding", val = 1 },
				{ type = "text", val = recent_files, opts = { hl = "Keyword", position = "center" } },
				{ type = "padding", val = 1 },
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
