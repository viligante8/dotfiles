return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "kanagawa",
      globalstatus = true,
      disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch" },
      lualine_c = {
        { "filename", path = 1 },
        { "diagnostics", sources = { "nvim_diagnostic" } },
        {
          function()
            local recording_register = vim.fn.reg_recording()
            if recording_register == "" then
              return ""
            else
              return "recording @" .. recording_register
            end
          end,
          color = { fg = "#ff9e64" }, -- Orange color to make it stand out
        },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}