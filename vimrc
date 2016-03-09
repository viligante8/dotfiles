let mapleader=" "

noremap <leader>so :so ~/.vimrc<cr>
noremap <leader>w :wincmd w<cr>
noremap <leader>s :w<cr>
noremap <leader>- :vertical resize -5<cr>
noremap <leader>= :vertical resize +5<cr>
noremap <leader>n :e.<cr>

if exists('+relativenumber')
  nnoremap <expr> <C-N> CycleLNum()
  xnoremap <expr> <C-N> CycleLNum()
  onoremap <expr> <C-N> CycleLNum()

  function! CycleLNum()
    if &l:rnu
      setlocal nonu nornu
    elseif &l:nu
      setlocal nu rnu
    else
      setlocal nu
    endif
    redraw
    return ""
  endfunc
endif

let g:vimfiler_as_default_explorer = 1

set nocompatible " be iMproved, required
filetype off " required

if has("autocmd")
  filetype indent plugin on
endif

filetype plugin indent on

set relativenumber
set number
set ruler
set laststatus=2
set title
set hlsearch

syntax on

set wildmenu
set wildmode=longest:full,full
set expandtab

set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent

set noswapfile

set path=$PWD/**
set background=dark
color elflord

set backspace=indent,eol,start
set tags=$PWD/.git/tags

set rtp+=~/.fzf
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
