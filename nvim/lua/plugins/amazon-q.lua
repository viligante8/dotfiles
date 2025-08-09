return {
  {
    dir = "~/dev/personal/amazon-q.nvim",
    name = "amazon-q",
    dependencies = {
      "MunifTanjim/nui.nvim",           -- Required for advanced UI
      "nvim-lua/plenary.nvim",          -- Required for file operations
      {
        "HakonHarnes/img-clip.nvim",    -- Optional for image support
        optional = true,
        config = function()
          -- Configure img-clip for Amazon Q integration
          require("img-clip").setup({
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
            },
            filetypes = {
              AmazonQInput = {
                url_encode_path = false,
                template = "![Image]($FILE_PATH)",
              },
            },
          })
        end,
      },
    },
    config = function()
      require("amazon-q").setup({
        ui_mode = "advanced_sidebar", -- Use the new advanced sidebar UI
        debug = true, -- Enable debug logging
        agentic_mode = {
          enabled = false, -- Start with agentic mode disabled for safety
          auto_approve = false, -- Never auto-approve by default
          prompt_for_approval = true, -- Always prompt for file changes
          allowed_tools = {"fs_read", "fs_write", "execute_bash"},
          backup_files = true, -- Create backups before modifying files
          prefer_buffer_edits = true, -- Apply changes to open buffers (smoother!)
        },
        sidebar = {
          width = 60,
          position = "right",
          border = "rounded",
          title = " 🤖 Amazon Q ",
          input_height = 4,
        },
        -- Advanced UI features (inspired by Avante.nvim)
        advanced_ui = {
          enabled = true, -- Enable for testing
          containers = {
            status = { height = 1 },
            result = { height = "60%" },
            context = { height = "20%" },
            files = { height = "15%" },
            input = { height = 3 },
          },
          window_management = {
            auto_adjust = true,
            conflict_resolution = true,
          },
        },
        -- Image support (inspired by Avante.nvim)
        image_support = {
          enabled = true, -- Enable for testing
          storage_path = nil, -- Will use default
          prompt_for_filename = false,
          format = "file_path", -- Amazon Q CLI format
          paste_key = "<C-v>",
          max_size_mb = 10,
          cleanup_days = 30,
        },
        terminal = {
          height = 15,
          position = "split",
          reuse = true,
        },
        context = {
          auto_add_current_file = true,
          auto_add_workspace = false, -- Let's be more selective
          custom_paths = {},
        },
        keymaps = {
          enabled = true,
          ask_with_context = "<leader>ac",
          ask_simple = "<leader>as",
          toggle_sidebar = "<leader>aa",
          add_all_buffers = "<C-a>",
          add_selection = "<leader>av",
        },
      })
    end,
    keys = {
      { "<leader>aa", desc = "Toggle Amazon Q sidebar" },
      { "<leader>ac", desc = "Amazon Q with context" },
      { "<leader>as", desc = "Amazon Q simple" },
      { "<leader>av", desc = "Add selection to Q context", mode = "v" },
      { "<leader>ag", desc = "Toggle Amazon Q agentic mode" },
    },
  },
}
