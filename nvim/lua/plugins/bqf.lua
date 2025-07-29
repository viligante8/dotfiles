-- Better quickfix window
return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  dependencies = {
    "junegunn/fzf",
  },
  config = function()
    -- Check if fzf is available before setting up filter
    local has_fzf = vim.fn.executable("fzf") == 1

    local config = {
      auto_enable = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
      },
      func_map = {
        vsplit = "",
        ptogglemode = "z,",
        stoggleup = "",
      },
    }

    -- Only add fzf filter if fzf is available
    if has_fzf then
      config.filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      }
    end

    require("bqf").setup(config)
  end,
}
