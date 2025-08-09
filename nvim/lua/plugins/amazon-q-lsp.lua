-- Amazon Q LSP Client - Production-ready standalone LSP client
return {
  {
    dir = "~/dev/personal/amazon-q-lsp.nvim", -- Use local dev folder
    name = "amazon-q-lsp",
    lazy = false, -- Load immediately for testing
    dependencies = {
      "neovim/nvim-lspconfig", -- Optional but recommended
    },
    config = function()
      -- Try to setup silently, don't spam startup
      local setup_ok, setup_err = pcall(function()
        require('amazon-q-lsp').setup({
          -- File types that trigger Amazon Q LSP
          filetypes = {
            'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
            'python', 'java', 'go', 'rust', 'cpp', 'c', 'csharp',
            'php', 'ruby', 'swift', 'kotlin', 'scala', 'lua',
            'json', 'yaml', 'toml', 'markdown', 'sql', 'sh', 'bash'
          },
          
          -- Auto-start when opening supported files
          autostart = true,
          
          -- Single file support (no workspace required)
          single_file_support = true,
          
          -- AWS-specific settings
          settings = {
            ['aws.q'] = {
              profile = 'emsi-company-micro',  -- Your AWS profile
              region = 'us-east-1',
            }
          },
          
          -- Custom keymaps and functionality
          on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, silent = true }
            
            -- Chat with Amazon Q
            vim.keymap.set('n', '<leader>qc', function()
              require('amazon-q-lsp').send_chat("Help me with this code")
            end, opts)
            
            -- Explain selected code
            vim.keymap.set('v', '<leader>qe', function()
              local text = require('amazon-q-lsp').util.get_visual_selection()
              if text then
                require('amazon-q-lsp').send_chat("Explain this code: " .. text)
              end
            end, opts)
            
            -- Security scan
            vim.keymap.set('n', '<leader>qs', function()
              require('amazon-q-lsp').run_security_scan()
            end, opts)
            
            vim.notify("Amazon Q LSP ready!", vim.log.levels.INFO)
          end,
          
          -- Custom chat response handler
          on_chat_response = function(response)
            if response.message then
              vim.notify('Amazon Q: ' .. response.message, vim.log.levels.INFO)
            end
          end,
          
          -- Custom initialization (silent)
          on_init = function(client, initialize_result)
            -- Only log if user wants to see it
            -- print("Amazon Q LSP initialized")
          end,
          
          -- Custom exit handler (silent)
          on_exit = function(code, signal, client_id)
            -- Only notify on unexpected exits
            if code ~= 0 then
              vim.notify("Amazon Q LSP exited unexpectedly", vim.log.levels.WARN)
            end
          end,
        })
      end)
      
      -- Only show message if user explicitly checks
      -- Don't spam startup!
    end,
    
    -- Key mappings for the plugin (always available)
    keys = {
      { "<leader>qh", function() require('amazon-q-lsp').checkhealth() end, desc = "Amazon Q Health Check", mode = "n" },
      { "<leader>qt", function() require('amazon-q-lsp').test() end, desc = "Amazon Q Test", mode = "n" },
      { "<leader>qc", desc = "Amazon Q Chat", mode = "n" },
      { "<leader>qe", desc = "Amazon Q Explain Code", mode = "v" },
      { "<leader>qs", desc = "Amazon Q Security Scan", mode = "n" },
    },
    
    -- Commands are now always available (created in main module)
    cmd = { "AmazonQHealth", "AmazonQStatus", "AmazonQTest" },
  },
}
