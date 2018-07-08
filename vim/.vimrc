"
" VIM
" Personal Vim configuration
"   plugin-management with 'vim-plug'
"
" file: ~/.vimrc
" v1.3 / 2018.05.23
"
" (c) 2018 Bernd Busse
"

set nocompatible
set encoding=utf8
set ffs=unix,dos,mac
set autoread

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
set showmode
set showmatch
set number
set relativenumber
set ruler
set hidden
set scrolloff=5

set wildmenu
set mouse=a
set laststatus=2
set timeoutlen=1000
set ttimeoutlen=0

set hlsearch
set incsearch
" reset last search
let @/ = ""

" Windows / Splits
set splitbelow
set splitright

" Highlight
set list
set listchars=tab:>-,trail:~,extends:»,precedes:«,nbsp:␣
set whichwrap=""
" }}}

" /* EXTERNAL TOOLS */ {{{
set path=**
set grepprg=grep\ -nH\ $*
" }}}

" /* USE SYSTEM CLIPBOARD */ {{{
set clipboard=unnamed
set clipboard+=unnamedplus
" }}}

" /* FILETYPES HANDLING */ {{{
filetype plugin indent on
syntax on
" }}}

" /* AUTOCOMMANDS */ {{{
if has('autocmd')
    " set C source and header to plain c with doxygen docs
    autocmd BufRead,BufNewFile *.h,*.c,*.H,*.C let g:load_doxygen_syntax = 1 | set filetype=c
    autocmd BufRead,BufNewFile *.tex let g:ale_open_list = 0 "| let g:deoplete#omni#input_patterns.tex = g:vimtex#re#deoplete

    " show NERDTree if no files where specified on startup
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " close anyway if NERDTree is the last window
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " close scratch window when leaving insert or completion
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " toggle between absolute and relative line numbers
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter * set number norelativenumber
    augroup END
endif
" }}}

" /* CUSTOM FUNCTIONS */ {{{
"=======================================
" NERDTree - open tree, highlight current Buffer in open tree or close tree {{{2
function! BBToggleNERDTree()
    if &diff | return | endif
    if (exists("b:NERDTree") && b:NERDTree.isTabTree()) | NERDTreeClose
    elseif (exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)) | NERDTreeFind
    else | NERDTreeFind
    endif
endfunction
" }}}

" Jump to next closed fold {{{2
function! BBJumpNextClosedFold(cnt, dir)
    echo "Count: " . a:cnt
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [c, l0, l, open] = [1, 0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
        " FIXME: a:cnt > max possible jumps doesn't work when last fold is
        " open
        if !open && c < a:cnt && l != l0
            let c = c+1
            let open = 1
        endif
    endwhile
    if open | call winrestview(view) | endif
endfunction
" }}}
" }}}


" /* PLUGIN SETUP (VIM-PLUG) */ {{{
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
Plug 'lervag/vimtex', { 'for': ['tex', 'latex'] }

" rust - rust support
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" typescript - typescript support
Plug 'leafgarland/typescript-vim'

" gitgutter - git status
Plug 'airblade/vim-gitgutter'

" completion-manager - auto complete (NeoVim)
Plug 'roxma/nvim-completion-manager', has('nvim') ? {} : { 'on': [] }

" ale - async syntax checking and linting
Plug 'w0rp/ale'

" syntastic - syntax checking
" Plug 'scrooloose/syntastic'

" clippy - syntax checking with cargo-clippy
" Plug 'wagnerf42/vim-clippy', { 'for': 'rust' }

" FastFold - faster fold calculation
Plug 'Konfekt/FastFold'

" BBye - close buffers without closing windows
Plug 'moll/vim-bbye'

" colorschemes
Plug 'easysid/mod8.vim'
Plug 'Lokaltog/vim-distinguished'
Plug 'w0ng/vim-hybrid'

call plug#end()
" }}}

" /* PLUGIN SETTINGS: airline */ {{{
let g:airline_powerline_fonts = 1

let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#vimtex#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tmuxline#enabled = 0
" }}}

" /* PLUGIN SETTINGS: nerdtree */ {{{
let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1
" }}}

" /* PLUGIN SETTINGS: auto-pairs */ {{{
let g:AutoPairsShortcutToggle = '<C-c>'
let g:AutoPairsShortcutFastWrap = '<C-w>'
let g:AutoPairsShortcutJump = '<C-a>'
let g:AutoPairsShortcutBackInsert = '<C-b>'
" }}}

" /* PLUGIN SETTINGS: vimtex */ {{{
let g:vimtex_enabled = 1
let g:vimtex_compiler_enabled = 0
let g:tex_flavor = 'latex'
let g:tex_fold_enabled = 1
" }}}

" /* PLUGIN SETTINGS: gitgutter */ {{{
let g:gitgutter_map_keys = 0
" }}}

" /* PLUGIN SETTINGS: ale */ {{{
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 1
let g:ale_list_window_size = 5

let g:ale_echo_msg_error_str = 'EE'
let g:ale_echo_msg_warning_str = 'WW'
let g:ale_echo_msg_format = '%severity%: [%linter%] %s'

let g:ale_linters = {
            \ 'c': ['gcc', 'clangtidy', 'flawfinder'],
            \ }

let g:ale_c_parse_makefile = 1
let g:ale_c_clangtidy_checks = ['-*', 'bugprone-*', 'cert-*-c', 'misc-*', 'mpi-*',
            \ 'clang-analyzer-*', '-clang-analyzer-cplusplus.*', '-clang-analyzer-optin.*', '-clang-analyzer-osx.*',
            \ 'modernize-*', 'performance-*', 'readability-*']
" }}}

" /* PLUGIN SETTINGS: syntastic */ {{{
"let g:syntastic_check_on_open = 0
"let g:syntastic_check_on_wq = 0
"let g:clang_c_options = '-std=gnu11'
"let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_python_checkers = ['python', 'flake8']
"let g:syntastic_rust_checkers = ['rustc', 'clippy']
" }}}

" /* PLUGIN SETTINGS: FastFold */ {{{
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C', 'r', 'R', 'm', 'M']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
" }}}


" /* CUSTOM KEYMAP */ {{{
"=======================================
let mapleader = "\<Space>"

" Vim. Live it!
" or just use neo2 :)
"inoremap <Up> <nop>
"vnoremap <Up> <nop>
"inoremap <Down> <nop>
"vnoremap <Down> <nop>
"inoremap <Left> <nop>
"vnoremap <Right> <nop>
"vnoremap <Left> <nop>
"inoremap <Right> <nop>
" B-A-<start>

"nnoremap <Up> <nop>
"nnoremap <Down> <nop>
"nnoremap <Left> <nop>
"nnoremap <Right> <nop>

" save shortcut (only works with disabled flow-control)
nnoremap <C-s> :update<CR>
inoremap <C-s> <C-o>:update<CR>
vmap <C-s> <ESC>:update<CR>gv

" buffer navigation
nmap <silent> <C-p> :bprevious <CR>
nmap <silent> <C-n> :bnext <CR>
nmap <silent> <leader>bn :bnext <CR>
nmap <silent> <leader>bp :bprevious <CR>
nmap <silent> <leader>br :e <CR>
nmap <silent> <leader>ba :enew <CR><C-o>
nmap <silent> <leader>bq :Bwipeout <CR>
nmap <silent> <leader><Tab> :bnext <CR>

" window navigation
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" fold navigation
nnoremap zJ :<C-u>call BBJumpNextClosedFold(v:count1, 'j')<CR>
nnoremap zK :<C-u>call BBJumpNextClosedFold(v:count1, 'k')<CR>

" tags
nnoremap ü <C-]>
nnoremap Ü <C-t>

" jumps
nnoremap ä <C-o>
nnoremap Ä <Tab>

" reset search highlight
nnoremap <silent> <CR> :nohlsearch <CR><CR>

" NERDTree
nnoremap <silent> <C-o> :call BBToggleNERDTree()<CR>

" FastFold
nmap <leader>zu <Plug>(FastFoldUpdate)
" }}}


" /* NVIM SPECIFIC OPTIONS */ {{{
"=======================================
if has('nvim')
else
endif
" }}}


" /* GUI OPTIONS (color-scheme) */ {{{
"=======================================
if has("gui_running")
    " GUI - Theme
    set t_Co=256
    set background=dark
    colorscheme hybrid
    highlight LineNr ctermfg=green

    set guioptions-=T
    set guifont=Source\ Code\ Pro\ for\ Powerline\ 10
    set lines=45
    set columns=132
else
    " Console - Theme
    if &t_Co == 8
        set t_Co=256
        colorscheme distinguished
        highlight LineNr ctermfg=green
    else
        set t_Co=256
        set background=dark
        colorscheme hybrid
        "highlight Normal ctermbg=black
        highlight LineNr ctermfg=green
    endif
endif
" }}}

"" vim:fdm=marker:fdl=0
