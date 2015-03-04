"
" VIM
" Personal Vim configuration
" 
" file: ~/.vimrc
" v0.2 / 2015.03.04
"
" (c) 2015 Bernd Busse
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
"if has("mouse")
"    set mouse=a
"endif

set grepprg=grep\ -nH\ $*

" LaTeX - Suite
let g:tex_flavor = "latex"
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_MultipleCompileFormats = 'dvi,pdf'

if has("gui_running")
    " GUI - Theme
    set guioptions-=T
    set t_Co=256
    colorscheme desert256
    set lines=45
    set columns=132
    
    " SuperTab - Completion
    let g:SuperTabMappingForward='<c-space>'
    let g:SuperTabMappingBackward='<s-c-space>'
else
    " Console - Theme
    set t_Co=256
    colorscheme tir_black
    
    " SuperTab - Completion
    let g:SuperTabMappingForward='<nul>'
    let g:SuperTabMappingBackward='<s-nul>'
endif

filetype plugin indent on
syntax on
let g:pydiction_location='/usr/share/pydiction/complete-dict'

