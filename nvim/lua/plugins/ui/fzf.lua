-- FZF support
return {
  {
    'junegunn/fzf',
    build = './install --bin',
  },
  {
    'junegunn/fzf.vim',
    dependencies = { 'junegunn/fzf' },
  },
}
