return {
	"ray-x/go.nvim",
	ft = { "go", "gomod" },
	dependencies = {
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		lsp_cfg = false,
		lsp_keymaps = false,
		dap_debug = false,
		dap_debug_keymap = false,
		textobject = false,
	},
	config = function(_, opts)
		require("go").setup(opts)
	end,
}
