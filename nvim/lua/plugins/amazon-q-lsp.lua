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
      -- Add startup diagnostics
      print("🚀 Loading Amazon Q LSP from local dev folder...")
      
      -- Run quick health check on startup
      vim.defer_fn(function()
        local ok, amazon_q = pcall(require, 'amazon-q-lsp')
        if ok then
          print("✅ Amazon Q LSP module loaded successfully")
          
          -- Quick authentication test
          local auth_ok, auth = pcall(function() return amazon_q.auth end)
          if auth_ok and auth then
            local cred_req = auth.get_credentials_request('emsi-company-micro')
            if cred_req and cred_req.metadata and cred_req.metadata.sso then
              print("🎯 SSO Bearer Token detected - AWS_PROFILE issue FIXED!")
            elseif cred_req then
              print("ℹ️ IAM credentials detected")
            else
              print("⚠️ No credentials available")
            end
          end
        else
          print("❌ Failed to load Amazon Q LSP:", amazon_q)
        end
      end, 500)
      
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
          
          print("🔗 Amazon Q LSP attached to:", vim.api.nvim_buf_get_name(bufnr))
          
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
          
          -- Health check
          vim.keymap.set('n', '<leader>qh', function()
            require('amazon-q-lsp').checkhealth()
          end, opts)
          
          -- Quick test keymap
          vim.keymap.set('n', '<leader>qt', function()
            print("🧪 Testing Amazon Q LSP...")
            require('amazon-q-lsp').checkhealth()
          end, opts)
          
          vim.notify("Amazon Q LSP ready!", vim.log.levels.INFO)
        end,
        
        -- Custom chat response handler
        on_chat_response = function(response)
          -- For now, just show in notification
          -- Later we can integrate with a proper UI
          if response.message then
            vim.notify('Amazon Q: ' .. response.message, vim.log.levels.INFO)
          end
        end,
        
        -- Custom initialization
        on_init = function(client, initialize_result)
          print("🎉 Amazon Q LSP initialized successfully!")
          
          -- Log server info
          if initialize_result.serverInfo then
            print("  Server:", initialize_result.serverInfo.name, initialize_result.serverInfo.version)
          end
        end,
        
        -- Custom exit handler
        on_exit = function(code, signal, client_id)
          if code ~= 0 then
            print("⚠️ Amazon Q LSP exited with code:", code)
          else
            print("👋 Amazon Q LSP stopped cleanly")
          end
        end,
      })
      
      -- Set up health check command
      vim.api.nvim_create_user_command('AmazonQHealth', function()
        require('amazon-q-lsp').checkhealth()
      end, { desc = 'Run Amazon Q LSP health check' })
      
      -- Set up manual start command (for testing)
      vim.api.nvim_create_user_command('AmazonQStart', function()
        local clients = vim.lsp.get_clients({ name = 'amazon-q' })
        if #clients > 0 then
          vim.notify('Amazon Q LSP already running', vim.log.levels.INFO)
        else
          print("🚀 Manually starting Amazon Q LSP...")
          -- Manually start the LSP
          require('amazon-q-lsp').setup({
            settings = {
              ['aws.q'] = {
                profile = 'emsi-company-micro',
              }
            }
          })
        end
      end, { desc = 'Manually start Amazon Q LSP' })
      
      -- Set up status command
      vim.api.nvim_create_user_command('AmazonQStatus', function()
        local clients = vim.lsp.get_clients({ name = 'amazon-q' })
        if #clients > 0 then
          print('✅ Amazon Q LSP is running (' .. #clients .. ' clients)')
          for _, client in ipairs(clients) do
            print('  Client ID:', client.id, 'Root dir:', client.config.root_dir or 'none')
          end
        else
          print('❌ Amazon Q LSP is not running')
        end
      end, { desc = 'Check Amazon Q LSP status' })
      
      -- Quick test command
      vim.api.nvim_create_user_command('TestAmazonQ', function()
        print("=== Amazon Q LSP Quick Test ===")
        local amazon_q = require('amazon-q-lsp')
        amazon_q.checkhealth()
        
        -- Test authentication
        local auth = amazon_q.auth
        local cred_req = auth.get_credentials_request('emsi-company-micro')
        if cred_req and cred_req.metadata and cred_req.metadata.sso then
          print("🎯 SUCCESS: SSO Bearer Token authentication working!")
        end
      end, { desc = 'Quick test of Amazon Q LSP' })
    end,
    
    -- Key mappings for the plugin
    keys = {
      { "<leader>qc", desc = "Amazon Q Chat", mode = "n" },
      { "<leader>qe", desc = "Amazon Q Explain Code", mode = "v" },
      { "<leader>qs", desc = "Amazon Q Security Scan", mode = "n" },
      { "<leader>qh", desc = "Amazon Q Health Check", mode = "n" },
      { "<leader>qt", desc = "Amazon Q Quick Test", mode = "n" },
    },
    
    -- Commands for easy access
    cmd = { "AmazonQHealth", "AmazonQStart", "AmazonQStatus", "TestAmazonQ" },
  },
}
