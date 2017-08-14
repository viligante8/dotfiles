let mapleader=" "

noremap <leader>so :so ~/.vimrc<cr>
noremap <leader>w :wincmd w<cr>
noremap <leader>s :w<cr>
noremap <leader>- :vertical resize -5<cr>
noremap <leader>= :vertical resize +5<cr>
noremap <leader>n :vsp .<cr>

noremap <leader>yy "*yy
noremap <leader>y "*y
noremap <leader>dd "*dd
noremap <leader>d "*d
noremap <leader>p "*p
noremap <leader>P "*P

noremap <leader>j :%!python -m json.tool<cr>

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

function! OpenFileBrowserDrawer()
  :vsp . <cr> 
  :vertical resize 30<cr>
endfunc


set nocompatible              " be iMproved, required
filetype off                  " required
if has("autocmd")
  filetype indent plugin on
endif
"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif
call vundle#end()            " required
filetype plugin indent on

set number
set relativenumber
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
set mouse=a
set noswapfile

set path=$PWD/**
set background=dark
color gruvbox

set backspace=indent,eol,start
set tags=$PWD/.git/tags

set rtp+=~/.fzf
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
