return {
	"dmmulroy/tsc.nvim",
	cmd = { "TSC" }, -- Load when TSC command is used
	ft = { "typescript", "typescriptreact" }, -- Only load for TypeScript files
	config = function()
		require("tsc").setup({
			auto_open_qflist = true,
			auto_close_qflist = false,
			auto_focus_qflist = false,
			use_trouble_qflist = true,
			use_diagnostics = true,
		})
	end,
	keys = {
		{ "<leader>tc", "<cmd>TSC<cr>", desc = "🔍 TypeScript Check" },
		{
			"<leader>tw",
			function()
				-- Manual watch mode using vim job
				vim.fn.jobstart("npx tsc --noEmit --watch", {
					on_stdout = function(_, data)
						if data then
							for _, line in ipairs(data) do
								if line ~= "" then
									print(line)
								end
							end
						end
					end,
				})
			end,
			desc = "👁️ TypeScript Watch Mode",
		},
	},
}
