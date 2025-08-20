return {
	dir = "~/dev/personal/maccy.nvim", -- Use local dev folder
	-- 'viligante8/maccy.nvim',
	config = function()
		require("maccy").setup({
			integration = {
				which_key = true,
			},
		})
	end,
	keys = {
		{ "<leader>y" },
	},
}
