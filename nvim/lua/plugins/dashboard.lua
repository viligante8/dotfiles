return {
	"nvimdev/dashboard-nvim",
	enabled = false, -- Disabled in favor of alpha-nvim
	event = "VimEnter",
	config = function()


		local function center_text(text, width)
			local padding = math.max(0, math.floor((width - #text) / 2))
			return string.rep(" ", padding) .. text
		end

		local function get_header()
			local header = { "", "" }

			-- Add Neovim logo
			local logo = {
				"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
				"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
				"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
				"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
				"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
				"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
			}

			-- Center logo
			for _, line in ipairs(logo) do
				table.insert(header, center_text(line, 80))
			end

			table.insert(header, "")
			table.insert(header, "")

			return header
		end

		local opts = {
			theme = "doom",
			config = {
				vertical_center = true,
				header = get_header(),
				center = {
					{
						icon = " ",
						desc = "Find File",
						key = "f",
						action = function()
							require("telescope.builtin").find_files()
						end,
					},
					{
						icon = " ",
						desc = "Recent Files",
						key = "r",
						action = function()
							require("telescope.builtin").oldfiles()
						end,
					},
					{
						icon = " ",
						desc = "Find Text",
						key = "g",
						action = function()
							require("telescope.builtin").live_grep()
						end,
					},
					{ icon = " ", desc = "New File", key = "n", action = "enew" },
					{
						icon = " ",
						desc = "Config",
						key = "c",
						action = function()
							require("telescope.builtin").find_files({ cwd = "~/.config/nvim" })
						end,
					},
					{
						icon = " ",
						desc = "Dotfiles",
						key = "d",
						action = function()
							require("telescope.builtin").find_files({ cwd = vim.fn.fnamemodify(vim.fn.stdpath("config"), ":h") })
						end,
					},
					{
						icon = " ",
						desc = "Restore Session",
						key = "s",
						action = function()
							require("persistence").load()
						end,
					},
					{ icon = "󰒲 ", desc = "Lazy", key = "l", action = "Lazy" },
					{ icon = " ", desc = "Mason", key = "m", action = "Mason" },
					{ icon = " ", desc = "Quit", key = "q", action = "qa" },
				},
				footer = function()
					local function center_text(text, width)
						local padding = math.max(0, math.floor((width - #text) / 2))
						return string.rep(" ", padding) .. text
					end

					local function ascii_date()
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

					local footer = { "", "" }
					local date_lines = ascii_date()
					-- Center date
					for _, line in ipairs(date_lines) do
						table.insert(footer, center_text(line, 80))
					end

					table.insert(footer, "")
					table.insert(footer, "")
					table.insert(footer, "")
					return footer
				end,
			},
		}

		require("dashboard").setup(opts)
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
