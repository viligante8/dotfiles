return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = false,
      undercurl = true,
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = true },
      statementStyle = { bold = true },
      typeStyle = {},
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      overrides = function(colors)
        local theme = colors.theme
        return {
          -- Make visual selection much more visible in tmux
          Visual = { bg = "#4a5568", fg = "NONE", bold = true },
          VisualNOS = { bg = "#4a5568", fg = "NONE", bold = true },
          -- Make search results visible when using * or /
          Search = { bg = "#d79921", fg = "#1d2021", bold = true },
          IncSearch = { bg = "#fe8019", fg = "#1d2021", bold = true },
        }
      end,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus"
      },
    })
    vim.cmd("colorscheme kanagawa")
  end,
}