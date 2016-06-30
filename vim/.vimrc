"
" VIM
" Personal Vim configuration
"   plugin-management with 'vim-plug'
" 
" file: ~/.vimrc
" v1.0 / 2016.06.30
"
" (c) 2016 Bernd Busse
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
set laststatus=2
set mouse-=a

set listchars=tab:>-,trail:~,extends:>,precedes:<,space:·
set list

set grepprg=grep\ -nH\ $*

filetype plugin indent on
syntax on

" Plugin setup (vim-plug)
"=======================================
call plug#begin('~/.vim/plugged')

" vim-airline - statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" tmuxline - statusline for tmux
Plug 'edkolev/tmuxline.vim'

" nerdtree - file browsser
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" auto-pairs - auto braces
Plug 'jiangmiao/auto-pairs'

" vimtex - latex tools
Plug 'lervag/vimtex'

" gitgutter - git status
Plug 'airblade/vim-gitgutter'

" syntastic - syntax checking
Plug 'scrooloose/syntastic'

" colorschemes
Plug 'easysid/mod8.vim'
Plug 'Lokaltog/vim-distinguished'
Plug 'whatyouhide/vim-gotham'
Plug 'w0ng/vim-hybrid'

call plug#end()

" airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0

" syntastic
let g:pydiction_location='/usr/share/pydiction/complete-dict'
let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

" Key shortcuts
"=======================================
:map <c-n> :NERDTreeToggle .<CR>
:map <c-h> :bprevious <CR>
:map <c-l> :bnext <CR>

" NVIM options
"=======================================
if has('nvim')
else
endif

" GUI options
"=======================================
if has("gui_running")
    " GUI - Theme
    set guioptions-=T
    set t_Co=256
    set background=dark
    colorscheme gotham256
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 10
    set lines=45
    set columns=132
else
    " Console - Theme
    set t_Co=256
    set background=dark
    colorscheme gotham256
endif

