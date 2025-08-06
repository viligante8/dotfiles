return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = {"stylua"},
            javascript = {"eslint_d", "prettierd", "prettier"},
            typescript = {"eslint_d", "prettierd", "prettier"}
        },
        format_on_save = {
            lsp_fallback = true
        }
    }
}
