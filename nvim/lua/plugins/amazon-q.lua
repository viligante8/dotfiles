-- Amazon Q Neovim Plugin - Beautiful UI/UX
return {
  {
    dir = "~/dev/personal/amazon-q.nvim",
    name = "amazon-q",
    lazy = false, -- Load immediately
    dependencies = {
      "amazon-q-lsp", -- Our LSP backend
    },
    config = function()
      require("amazon-q").setup({
        -- AWS settings (passed to amazon-q-lsp.nvim)
        aws_profile = 'emsi-company-micro',
        aws_region = 'us-east-1',
        
        -- Beautiful chat UI
        chat = {
          window_type = 'floating',
          width = 80,
          height = 24,
          border = 'rounded',
          title = '🤖 Amazon Q Chat',
        },
        
        -- Agentic mode (file modification)
        agentic_mode = {
          enabled = false, -- Start disabled for safety
          auto_approve = false, -- Always prompt
          backup_files = true,
          show_diff = true,
        },
        
        -- Context settings
        context = {
          auto_add_current_file = true,
          auto_add_selection = true,
          max_context_lines = 1000,
          show_context_preview = true,
        },
        
        -- Keymaps
        keymaps = {
          enabled = true,
          open_chat = '<leader>qc',
          toggle_chat = '<leader>qt',
          send_message = '<CR>',
          close_chat = '<Esc>',
          clear_chat = '<leader>qx',
          toggle_agentic = '<leader>qa',
        },
      })
    end,
    
    -- Key mappings
    keys = {
      { "<leader>qc", desc = "Open Amazon Q Chat" },
      { "<leader>qt", desc = "Toggle Amazon Q Chat" },
      { "<leader>qa", desc = "Toggle Agentic Mode" },
      { "<leader>qx", desc = "Clear Chat History" },
    },
    
    -- Commands
    cmd = { "AmazonQChat", "AmazonQToggle" },
  },
}
