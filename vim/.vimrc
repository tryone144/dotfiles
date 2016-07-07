"
" VIM
" Personal Vim configuration
"   plugin-management with 'vim-plug'
"
" file: ~/.vimrc
" v1.1 / 2016.07.07
"
" (c) 2016 Bernd Busse
"

set nocompatible
set encoding=utf8
set ffs=unix,dos,mac
set autoread

" tab editing
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent

" appearance
set showmode
set showmatch
set number
set ruler
set hidden

set splitbelow
set splitright

set hlsearch
set incsearch
set wildmenu
set mouse=a
set laststatus=2
set timeoutlen=1000
set ttimeoutlen=0

set list
set listchars=tab:>-,trail:~,extends:>,precedes:<,
set whichwrap=""

set grepprg=grep\ -nH\ $*

" use system clipboard
set clipboard=unnamed
set clipboard+=unnamedplus

" reset last search
let @/ = ""

" handle filetypes
filetype plugin indent on
syntax on

if has('autocmd')
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif


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

" deoplete - auto complete (NeoVim)
Plug 'Shougo/deoplete.nvim', has('nvim') ? {} : { 'on': [] }

" syntastic - syntax checking
Plug 'scrooloose/syntastic'

" colorschemes
Plug 'easysid/mod8.vim'
Plug 'Lokaltog/vim-distinguished'
Plug 'w0ng/vim-hybrid'

call plug#end()

" airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0

" gitgutter
let g:gitgutter_map_keys = 0

" syntastic
let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'


" Key shortcuts
"=======================================

let mapleader = "\<Space>"

" buffer navigation
nmap <silent> <C-p> :bprevious <CR>
nmap <silent> <C-n> :bnext <CR>
nmap <silent> <leader>ba :enew <CR><C-o>
nmap <silent> <leader>bq :bdelete <CR>
nmap <silent> <leader><Tab> :bnext <CR>

" window navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" tags
nnoremap ü <C-]>
nnoremap Ü <C-O>

" search highlight
nnoremap <silent> <CR> :nohlsearch <CR><CR>

" NERDTree
nmap <silent> <C-o> :NERDTreeToggle .<CR>

" NVIM specific options
"=======================================
if has('nvim')
    " Use deoplete.
    let g:deoplete#enable_at_startup = 1
else
endif


" GUI options
"=======================================
if has("gui_running")
    " GUI - Theme
    set t_Co=256
    set background=dark
    colorscheme hybrid

    set guioptions-=T
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 10
    set lines=45
    set columns=132
else
    " Console - Theme
    if &t_Co == 8
        set t_Co=256
        colorscheme distinguished
    else
        set t_Co=256
        set background=dark
        colorscheme hybrid
        "highlight Normal ctermbg=black
    endif
endif

