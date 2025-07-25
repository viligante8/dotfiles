-- REPL integration
return {
  'pappasam/nvim-repl',
  opts = {
    filetype_commands = {
      javascript = { cmd = 'node', filetype = 'javascript' },
      typescript = { cmd = 'ts-node -O \'{"module": "commonjs"}\'', filetype = 'typescript' },
    },
    default = { cmd = 'bash', filetype = 'zsh' },
    open_window_default = '25 split new',
  },
}
