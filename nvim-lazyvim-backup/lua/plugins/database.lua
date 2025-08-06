-- Database UI with your custom <A-d> keymap (migrated from kickstart)
return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    -- Your custom <A-d> database UI keymap (migrated from kickstart)
    { "<A-d>t", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}
