return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal in Neo-tree" },
  },
  init = function()
    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    
    -- Auto-open neo-tree when starting with a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function(data)
        -- Check if we opened a directory
        local directory = vim.fn.isdirectory(data.file) == 1
        if directory then
          -- Open neo-tree
          require("neo-tree.command").execute({ action = "show" })
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    window = {
      position = "right",
      width = 40,  -- Increased base width
      auto_expand_width = true,  -- Automatically expand for long filenames
      mappings = {
        ["<cr>"] = "open",
        ["<2-LeftMouse>"] = "open", 
        ["l"] = "open",
        ["h"] = "close_node",
        ["<space>"] = "none",
        ["t"] = "open_tabnew",  -- Disable tab opening
        ["T"] = "none",         -- Disable tab opening
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
  },
}