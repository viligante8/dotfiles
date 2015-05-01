let mapleader=" "

noremap <leader>so :so ~/.vimrc<cr>
noremap <leader>w :wincmd w<cr>
noremap <leader>- :vertical resize -5<cr>
noremap <leader>= :vertical resize +5<cr>
noremap <leader>n :NERDTree<cr>

let g:vimfiler_as_default_explorer = 1

set nocompatible " be iMproved, required
filetype off " required

if has("autocmd")
  filetype indent plugin on
endif

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

call vundle#end() " required
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
color monokai
