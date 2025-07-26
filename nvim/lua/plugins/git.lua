-- LazyGit integration with your custom keymap (migrated from kickstart)
return {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    -- Your custom keymap (migrated from kickstart)
    { "<C-g>", "<cmd>LazyGit<cr>", desc = "LazyGit" },
  },
}
