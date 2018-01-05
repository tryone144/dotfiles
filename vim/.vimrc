"
" VIM
" Personal Vim configuration
"   plugin-management with 'vim-plug'
"
" file: ~/.vimrc
" v1.2 / 2017.10.09
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
setlocal indentkeys+=0

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

set scrolloff=5

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
    " show NERDTree if no files where specified on startup
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " close anyway if NERDTree is the last window
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
Plug 'scrooloose/nerdtree', { 'on':  ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind'] }

" auto-pairs - auto braces
Plug 'jiangmiao/auto-pairs'

" vimtex - latex tools
Plug 'lervag/vimtex'

" rust-lang - rust support
Plug 'rust-lang/rust.vim'

" typescript - typescript support
Plug 'leafgarland/typescript-vim'

" rust - syntax and stuff for the rust language
Plug 'rust-lang/rust.vim'

" gitgutter - git status
Plug 'airblade/vim-gitgutter'

" deoplete - auto complete (NeoVim)
Plug 'Shougo/deoplete.nvim', has('nvim') ? {} : { 'on': [] }

" syntastic - syntax checking
Plug 'scrooloose/syntastic'

" FastFold - faster fold calculation
Plug 'Konfekt/FastFold'

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

" NERDTree - open tree, highlight current Buffer in open tree or close tree
function! BBToggleNERDTree()
    if &diff | return | endif
    if (exists("b:NERDTree") && b:NERDTree.isTabTree()) | NERDTreeClose
    elseif (exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)) | NERDTreeFind
    else | NERDTreeFind
    endif
endfunction

" auto-pairs
let g:AutoPairsShortcutToggle = 'w'
let g:AutoPairsShortcutFastWrap = '<C-w>'

" vimtex
let g:tex_flavor = 'latex'
let g:tex_fold_enabled = 1

" gitgutter
let g:gitgutter_map_keys = 0

" syntastic
let g:clang_c_options = '-std=gnu11'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'

" FastFold
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

" Key shortcuts
"=======================================

let mapleader = "\<Space>"

" buffer navigation
nmap <silent> <C-p> :bprevious <CR>
nmap <silent> <C-n> :bnext <CR>
nmap <silent> <leader>br :e <CR>
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

" jumps
nnoremap ä <C-o>
nnoremap Ä <Tab>

" search highlight
nnoremap <silent> <CR> :nohlsearch <CR><CR>

" NERDTree
nnoremap <silent> <C-o> :call BBToggleNERDTree()<CR>

" FastFold
nmap <leader>zu <Plug>(FastFoldUpdate)

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

