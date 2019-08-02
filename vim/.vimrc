"
" VIM
" Personal Vim configuration
"   plugin-management with 'vim-plug'
"
" file: ~/.vimrc
" v1.4 / 2018.07.08
"
" (c) 2018 Bernd Busse
"

set nocompatible
set encoding=utf8
set ffs=unix,dos,mac
set autoread

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
    " enable ncm2 for all buffers
    augroup ncm2
        autocmd BufEnter * call ncm2#enable_for_buffer()
        autocmd User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
        autocmd User Ncm2PopupClose set completeopt=menuone
    augroup END

    " determine python linter depending on Shebang if not in venv
    autocmd FileType python if $VIRTUAL_ENV == "" |
        \ let b:ale_python_flake8_executable = BBParseShebang(expand('<afile>', 1))['exe'] |
        \ let b:ale_python_flake8_options = '-m flake8' | endif

    " set C source and header to plain c with doxygen docs
    autocmd BufRead,BufNewFile *.h,*.c,*.H,*.C let g:load_doxygen_syntax = 1 | set filetype=c

    " Hide loclist (lint-err) for LaTeX files
    autocmd BufRead,BufNewFile *.tex let g:ale_open_list = 0

    " show NERDTree if no files where specified on startup
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " close anyway if NERDTree is the last window
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " close anyway if QuickFix is the last window
    autocmd BufEnter * if (winnr("$") == 1 && &buftype ==# 'quickfix') | bd | q | endif

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
" }}}2

" Parse Shebang line (taken from syntastic utils) {{{2
function! BBParseShebang(buf) abort
    for lnum in range(1, 5)
        let line = get(getbufline(a:buf, lnum), 0, '')
        if line =~# '^#!'
            let line = substitute(line, '\v^#!\s*(\S+/env(\s+-\S+)*\s+)?', '', '')
            let exe = matchstr(line, '\m^\S*\ze')
            let args = split(matchstr(line, '\m^\S*\zs.*'))
            return { 'exe': exe, 'args': args }
        endif
    endfor

    return { 'exe': '', 'args': [] }
endfunction
" }}}2

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
" }}}2
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

" arm-syntax - armv7 syntax highlight
Plug 'ARM9/arm-syntax-vim'

" gitgutter - git status
Plug 'airblade/vim-gitgutter'

" fugitive - git diffing
Plug 'tpope/vim-fugitive'

" ncm2- auto completion
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc', has('nvim') ? { 'on': [] } : {}
" ncm2 provider
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'Shougo/neco-syntax'
Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'
" ncm2 LanguageServer client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" ale - async syntax checking and linting
Plug 'w0rp/ale'

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

" /* PLUGIN SETTINGS: ncm2 / LanguageClient */ {{{
"set completeopt=noinsert,menuone,noselect

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'stable', 'rls'],
    \ 'python': ['pyls'],
    \ }
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
            \ 'asm': [],
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

" /* MOVEMENT */ {{{2
" Vim. Live it!
"nnoremap <Up> <nop>
"vnoremap <Up> <nop>
"nnoremap <Down> <nop>
"vnoremap <Down> <nop>
"nnoremap <Left> <nop>
"vnoremap <Right> <nop>
"vnoremap <Left> <nop>
"nnoremap <Right> <nop>
" B-A-<start>

" or just use neo2 :)
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
inoremap <Home> <nop>
inoremap <End> <nop>

nnoremap <PageUp> <C-u>
nnoremap <PageDown> <C-d>
" }}}

" , as : is faster to reach
nmap , :
vmap , :

" no 'ex' mode
nmap Q <NOP>

" /* FILE SAVING */ {{{2
"nnoremap <C-s> :update<CR>
"inoremap <C-s> <C-o>:update<CR>
"vmap <C-s> <ESC>:update<CR>gv

nnoremap <leader>ss :update<CR>
nnoremap <leader>bs :update<CR>

" safer version of ZZ
nnoremap ZZ :confirm qa<CR>
" }}}

" /* WINDOW NAVIGATION */ {{{2
" nnoremap <C-h> <C-w><C-h>
" nnoremap <C-j> <C-w><C-j>
" nnoremap <C-k> <C-w><C-k>
" nnoremap <C-l> <C-w><C-l>
nnoremap <silent> <leader><Left> <C-w><C-h>
nnoremap <silent> <leader><Down> <C-w><C-j>
nnoremap <silent> <leader><Up> <C-w><C-k>
nnoremap <silent> <leader><Right> <C-w><C-l>
nnoremap <silent> <leader>wq :close<CR>
" }}}

" /* BUFFER NAVIGATION */ {{{2
"nmap <silent> <C-p> :bprevious<CR>
nmap <silent> <C-p> :bprevious<Bar>if &buftype ==# 'quickfix'<Bar>bprevious<Bar>endif<CR>
"nmap <silent> <C-n> :bnext<CR>
nmap <silent> <C-n> :bnext<Bar>if &buftype ==# 'quickfix'<Bar>bnext<Bar>endif<CR>
nmap <silent> <leader>bn <C-n>
nmap <silent> <leader>bp <C-p>
nmap <silent> <leader>br :e<CR>
nmap <silent> <leader>ba :enew<CR><C-o>
nmap <silent> <leader>bq :Bwipeout<CR>
nmap <silent> <leader><Tab> <C-n>
" }}}

" /* AUTOCLOMPLETION */ {{{2
" autocomplete (completefunc with ncm2) on CTRL-Space
inoremap <silent> <expr><C-Space> pumvisible()? "\<C-n>" : ncm2#manual_trigger()
" }}}

" fold navigation
nnoremap zJ :<C-u>call BBJumpNextClosedFold(v:count1, 'j')<CR>
nnoremap zK :<C-u>call BBJumpNextClosedFold(v:count1, 'k')<CR>

" tags
nnoremap ü <C-]>
nnoremap Ü <C-t>

" jumps
nnoremap ä <C-o>
nnoremap Ä <Tab>

" ale linter err/warn list
nnoremap <silent> <leader>ll :ALELint<CR>
nnoremap <silent> <leader>lo :lopen 5<CR>
nnoremap <silent> <leader>lc :lclose<CR>
nnoremap <silent> <leader>ln :ALENextWrap<CR>
nnoremap <silent> <leader>lp :ALEPreviousWrap<CR>

" reset search highlight
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" NERDTree
nnoremap <silent> <C-o> :call BBToggleNERDTree()<CR>

" FastFold
nmap <leader>zu <Plug>(FastFoldUpdate)

" help in vertical split
cabbrev vh vert help
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
