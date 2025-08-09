-- Amazon Q LSP Client - Production-ready standalone LSP client
return {
  {
    "viligante8/amazon-q-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig", -- Optional but recommended
    },
    config = function()
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
          
          -- Health check
          vim.keymap.set('n', '<leader>qh', function()
            require('amazon-q-lsp').checkhealth()
          end, opts)
          
          vim.notify("Amazon Q LSP attached to buffer", vim.log.levels.INFO)
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
          vim.notify("Amazon Q LSP initialized successfully!", vim.log.levels.INFO)
          
          -- Log server capabilities for debugging
          if initialize_result.capabilities then
            print("Amazon Q Server capabilities:", vim.inspect(initialize_result.capabilities))
          end
        end,
        
        -- Custom exit handler
        on_exit = function(code, signal, client_id)
          if code ~= 0 then
            vim.notify('Amazon Q LSP exited with code: ' .. code, vim.log.levels.WARN)
          else
            vim.notify('Amazon Q LSP stopped', vim.log.levels.INFO)
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
          vim.notify('Amazon Q LSP is running (' .. #clients .. ' clients)', vim.log.levels.INFO)
          for _, client in ipairs(clients) do
            print('Client ID:', client.id, 'Root dir:', client.config.root_dir)
          end
        else
          vim.notify('Amazon Q LSP is not running', vim.log.levels.WARN)
        end
      end, { desc = 'Check Amazon Q LSP status' })
    end,
    
    -- Key mappings for the plugin
    keys = {
      { "<leader>qc", desc = "Amazon Q Chat", mode = "n" },
      { "<leader>qe", desc = "Amazon Q Explain Code", mode = "v" },
      { "<leader>qs", desc = "Amazon Q Security Scan", mode = "n" },
      { "<leader>qh", desc = "Amazon Q Health Check", mode = "n" },
    },
    
    -- Commands for easy access
    cmd = { "AmazonQHealth", "AmazonQStart", "AmazonQStatus" },
  },
}
