-- Nvim-tree file explorer
return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup({
      sort = {
        sorter = 'case_sensitive',
      },
      view = {
        side = 'right',
        width = 50,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      actions = {
        expand_all = {
          exclude = {
            '.git',
            'node_modules',
          },
        },
      },
    })
  end,
}
