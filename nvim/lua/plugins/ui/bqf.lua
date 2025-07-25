-- Better quickfix
return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  dependencies = {
    'junegunn/fzf',
    'junegunn/fzf.vim',
  },
  config = function()
    require('bqf').setup({
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = 'rounded',
      },
    })
  end,
}
