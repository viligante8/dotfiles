return {
  -- Mason: LSP installer
  {
    'williamboman/mason.nvim',
    config = true,
  },

  -- Mason LSP config bridge
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'mason.nvim' },
  },

  -- LSP Configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason.nvim',
      'mason-lspconfig.nvim',
    },
    config = function()
      -- LSP keymaps (applied when LSP attaches to buffer)
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', vim.lsp.buf.definition, 'Go to Definition')
          map('gr', vim.lsp.buf.references, 'Go to References')
          map('gi', vim.lsp.buf.implementation, 'Go to Implementation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>cr', vim.lsp.buf.rename, 'Rename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format')
        end,
      })

      -- Enhanced capabilities for completion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if pcall(require, 'blink.cmp') then
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
      end

      -- Setup function for LSP servers
      local function setup_server(server_name)
        local opts = { capabilities = capabilities }
        
        -- Special configs for specific servers
        if server_name == 'lua_ls' then
          opts.settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          }
        end
        
        require('lspconfig')[server_name].setup(opts)
      end
      
      -- Setup mason-lspconfig with handlers
      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          setup_server, -- Default handler for all servers
        },
      })
    end,
  },
}