return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tto", "<cmd>ToggleTerm<cr>", desc = "Toggle Terminal" },
    { "<leader>ttf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float Terminal" },
    { "<leader>tth", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal Terminal" },
    { "<leader>ttv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical Terminal" },
  },
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
}