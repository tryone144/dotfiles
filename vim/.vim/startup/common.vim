"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   common configuration between vim and neovim
"
" file: ~/.vim/common.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

set nocompatible
set encoding=utf8
set ffs=unix,dos,mac
set autoread

set undodir=~/.vim/undobuffer
set undofile

set secure

" /* TAB EDITING */ {{{
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
setlocal indentkeys+=0
" }}}

" /* APPEARANCE */ {{{
" UI
set noshowmode
set showmatch
set number
set relativenumber
set ruler
set hidden
set scrolloff=5

set wildmenu
set mouse=a
set laststatus=0
set cmdheight=2
set timeoutlen=1000
set ttimeoutlen=0
set updatetime=400
set shortmess=aFc

set hlsearch
set incsearch
" reset last search
let @/ = ""

" Folds
set foldmethod=syntax
set foldnestmax=10
"set nofoldenable
set foldlevelstart=20

" Windows / Splits
set splitbelow
set splitright
let g:netrw_fastbrowse = 0

" Highlight
set list
set listchars=tab:>-,trail:~,extends:»,precedes:«,nbsp:␣
set whichwrap=""
" }}}

" /* EXTERNAL TOOLS */ {{{
set path=**
set grepprg=rg\ -nH\ $*
" }}}

" /* USE SYSTEM CLIPBOARD */ {{{
set clipboard=unnamed
set clipboard+=unnamedplus
" }}}

" /* FILETYPES HANDLING */ {{{
filetype plugin indent on
syntax on
" }}}

if has('autocmd')

    " set filetype for non-autodetected files
    augroup ftdetect
        autocmd!
        " set C source and header to plain c with doxygen docs
        autocmd BufRead,BufNewFile *.h,*.c,*.H,*.C let g:load_doxygen_syntax = 1 | set filetype=c
        autocmd BufRead,BufNewFile *.sage,*.spyx,*.pyx set filetype=python
        " detect WebGPU Shading Language
        autocmd BufRead,BufNewFile *.wgsl set filetype=wgsl
    augroup END

    if !in_vscode
        " close anyway if QuickFix is the last window
        autocmd BufEnter * if (winnr("$") == 1 && &buftype ==# 'quickfix') | bd | q | endif

        " close scratch window when leaving insert or completion
        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

        " toggle between absolute and relative line numbers
        augroup numbertoggle
            autocmd!
            autocmd BufEnter,FocusGained,InsertLeave * if (&buftype !=# 'nofile') | set relativenumber | endif
            autocmd BufLeave,FocusLost,InsertEnter * if (&buftype !=# 'nofile') | set number norelativenumber | endif
        augroup END

    endif
endif

"" vim:fdm=marker:fdl=0
