"
" ~/.vimrc
" Personal Vim configuration
" 
" file: ~/.vimrc
" v0.1 / 2014.12.10
"
" © 2014 Bernd Busse
"

set nocompatible
set encoding=utf8
set ffs=unix,dos,mac
set autoread

set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

set showmode
set showmatch
set incsearch
set whichwrap=""
set number
set ruler
set wildmenu
set omnifunc=syntaxcomplete#Complete
"if has("mouse")
"    set mouse=a
"endif

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_MultipleCompileFormats='dvi,pdf'

if has("gui_running")
    set guioptions-=T
    set t_Co=256
    colorscheme desert256
    set lines=45
    set columns=132
else
    set t_Co=256
    colorscheme tir_black
endif

map <leader>ss :setlocal spell!<cr>
map <leader>sen :set spelllang=en spell
map <leader>sde :set spelllang=de spell
map <leader>ses :set spelllang=es spell

filetype plugin indent on
syntax on
autocmd FileType python set omnifunc=pythoncomplete#Complete
let g:pydiction_location='/usr/share/pydiction/complete-dict'

