-- Amazon Q LSP Client - Backend for amazon-q.nvim
return {
  {
    dir = "~/dev/personal/amazon-q-lsp.nvim",
    name = "amazon-q-lsp",
    lazy = false, -- Load immediately
    config = function()
      require('amazon-q-lsp').setup({
        -- AWS settings
        settings = {
          ['aws.q'] = {
            profile = 'emsi-company-micro',  -- Your AWS profile
            region = 'us-east-1',
          }
        },
        
        -- File types that trigger Amazon Q LSP
        filetypes = {
          'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
          'python', 'java', 'go', 'rust', 'cpp', 'c', 'csharp',
          'php', 'ruby', 'swift', 'kotlin', 'scala', 'lua',
          'json', 'yaml', 'toml', 'markdown', 'sql', 'sh', 'bash'
        },
        
        -- Auto-start when opening supported files
        autostart = true,
        single_file_support = true,
        
        -- Silent operation (UI plugin will handle user interaction)
        on_attach = function(client, bufnr)
          -- LSP is ready, but UI plugin handles user interaction
        end,
      })
    end,
    
    -- Health check commands
    cmd = { "AmazonQHealth", "AmazonQStatus", "AmazonQTest" },
  },
}
