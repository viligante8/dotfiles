-- Debugging support
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    -- JavaScript/TypeScript debugging
    'mxsdev/nvim-dap-vscode-js',
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')
    local debug_configs = require('config.debug-configs')

    require('mason-nvim-dap').setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        'js-debug-adapter',
        'node-debug2-adapter',
      },
    })

    -- JavaScript/TypeScript/Bun debugging setup
    require('dap-vscode-js').setup({
      node_path = 'node',
      debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    })

    -- Configure DAP for Node.js/TypeScript using separated configs
    for _, language in ipairs({ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' }) do
      dap.configurations[language] = debug_configs.get_configurations()
    end

    -- Basic debugging keymaps
    vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Breakpoint' })

    -- Additional debug controls
    vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: Continue' })
    vim.keymap.set('n', '<leader>dr', dap.restart, { desc = 'Debug: Restart' })
    vim.keymap.set('n', '<leader>dx', dap.terminate, { desc = 'Debug: Terminate' })

    -- Quick debug selector
    vim.keymap.set('n', '<leader>S', debug_configs.select_debug_config, { desc = 'Debug: Select Configuration' })

    -- Setup project-specific keymaps (will be dynamically created based on current project)
    debug_configs.setup_keymaps()

    -- Dap UI setup
    dapui.setup({
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    })

    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: Toggle UI' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Auto-setup keymaps when changing directories (for project switching)
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = function()
        require('config.debug-configs').setup_keymaps()
      end,
    })
  end,
}
