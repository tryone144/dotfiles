"
" VIM
" Personal Vim configuration
"
" file: ~/.vimrc
" v1.9 / 2020.01.05
"
" (c) 2019 Bernd Busse
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
set updatetime=300
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

" /* CUSTOM FUNCTIONS */
source ~/.vim/startup/functions.vim


" /* GLOBAL AUTOCOMMANDS */ {{{
if has('autocmd')
    " determine python linter depending on Shebang if not in venv
    "autocmd FileType python if $VIRTUAL_ENV == "" |
    "    \ let b:ale_python_flake8_executable = BB_ParseShebang(expand('<afile>', 1))['exe'] |
    "    \ let b:ale_python_flake8_options = '-m flake8' | endif
    "autocmd FileType python if $VIRTUAL_ENV == "" |
    "    \ call coc#config('coc.preferences', {
    "        \ 'python.pythonPath': BB_ParseShebang(expand('<afile>', 1))['exe']
    "        \ }) | endif

    " set filetype for non-autodetected files
    augroup ftdetect
        autocmd!
        " set C source and header to plain c with doxygen docs
        autocmd BufRead,BufNewFile *.h,*.c,*.H,*.C let g:load_doxygen_syntax = 1 | set filetype=c
        autocmd BufRead,BufNewFile *.sage,*.spyx,*.pyx set filetype=python
    augroup END

    " Hide loclist (lint-err) for LaTeX files
    "autocmd BufRead,BufNewFile *.tex let g:ale_open_list = 0

    " enable LanguageClient only for languages that have the server registered
    augroup lsp_enable
        autocmd!
        "autocmd FileType c,python,rust call lsp#enable()
        autocmd FileType c,cpp,cuda,objc,python,rust,vue LanguageClientStart
    augroup END

    " show NERDTree if no files where specified on startup
    "autocmd StdinReadPre * let s:std_in=1
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
    " close anyway if NERDTree is the last window
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " close anyway if Vista is the last window
    autocmd BufEnter * if (winnr("$") == 1 && vista#sidebar#IsOpen()) | q | endif

    " close anyway if QuickFix is the last window
    autocmd BufEnter * if (winnr("$") == 1 && &buftype ==# 'quickfix') | bd | q | endif

    " close scratch window when leaving insert or completion
    autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

    " toggle between absolute and relative line numbers
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * if (&buftype !=# 'nofile') | set relativenumber | endif
        autocmd BufLeave,FocusLost,InsertEnter * if (&buftype !=# 'nofile') | set number norelativenumber | endif
        "autocmd BufEnter,FocusGained,InsertLeave * if (bufname('%') !=# '__LanguageClient__') | set relativenumber | endif
        "autocmd BufLeave,FocusLost,InsertEnter * if (bufname('%') !=# '__LanguageClient__') | set number norelativenumber | endif
    augroup END
endif
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

" rust - rust support
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" vue-plugin - vue.js support
Plug 'leafoftree/vim-vue-plugin', { 'for': 'vue' }

" clang-format - support for clang-format formatting
Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }

" gas - GNU assembler syntax highlight
Plug 'Shirk/vim-gas/'

" arm-syntax - armv7 syntax highlight
Plug 'ARM9/arm-syntax-vim'

" pug - Pug template highlight
Plug 'digitaltoad/vim-pug'

" gitgutter - git status
Plug 'airblade/vim-gitgutter'

" fugitive - git diffing
"Plug 'tpope/vim-fugitive'

" fzf - fuzzy search
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" vista - lsp aware tagbar
Plug 'liuchengxu/vista.vim'

" coc - lsp auto completion
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-neco', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-rls', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-vimtex', {'do': 'yarn install --frozen-lockfile'}
"Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}

" LanguageClient - async LanguageServer client
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

" autocompletion sources
Plug 'Shougo/neco-syntax'
Plug 'Shougo/neco-vim'

" asyncomplete - async autocompletion
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-necosyntax.vim'
Plug 'prabirshrestha/asyncomplete-necovim.vim'

Plug 'file://' . expand('~/proj/vim-plugins/asyncomplete-LanguageClient.vim')

" vim-lsp - async LanguageServer client
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'

" ale - async syntax checking and linting
"Plug 'w0rp/ale'

" FastFold - faster fold calculation
Plug 'Konfekt/FastFold'

" BBye - close buffers without closing windows
Plug 'moll/vim-bbye'

" colorschemes
Plug 'Lokaltog/vim-distinguished'
Plug 'morhetz/gruvbox'
Plug 'kaicataldo/material.vim'

call plug#end()
" }}}

" /* PLUGIN SETTINGS: airline */ {{{
let g:airline_powerline_fonts = 1
let g:airline_theme = 'zenburn'

let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#languageclient#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0
" }}}

" /* PLUGIN SETTINGS: material */ {{{
let g:material_terminal_italics = 1
let g:material_theme_style = 'palenight'
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

" /* PLUGIN SETTINGS: gitgutter */ {{{
let g:gitgutter_map_keys = 0
" }}}

" /* PLUGIN SETTINGS: vim-clang-format /* {{{
let g:clang_format#code_style = 'llvm'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0
let g:clang_format#auto_format_on_insert_leave = 0
" }}}

" /* PLUGIN SETTINGS: LanguageClient */ {{{
let g:LanguageClient_autoStart = 0
let g:LanguageClient_settingsPath = expand('~/.vim/lc-settings.json')
let g:LanguageClient_serverCommands = {
            \ 'c': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'cpp': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'cuda': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'objc': ['ccls', '--log-file=/tmp/ccls.log'],
            \ 'python': ['pyls'],
            \ 'rust': ['rls'],
            \ 'vue': ['vls'],
            \ }
let g:LanguageClient_rootMarkers = {
            \ 'c': ['.ccls', 'compile_commands.json', '.vim/', '.git/', '.hg/'],
            \ }

let g:LanguageClient_changeThrottle = 0.2
let g:LanguageClient_signatureHelpOnCompleteDone = 0

" TODO: Add CodeLens once implemented

let g:LanguageClient_diagnosticsEnable = 1
"let g:LanguageClient_virtualTextPrefix = ' ¬ '
let g:LanguageClient_virtualTextPrefix = ' ◉ '
let g:LanguageClient_diagnosticsDisplay = {
            \ 1: {'name': 'Error', 'texthl': 'LspErrorHighlight', 'signText': '✘', 'signTexthl': 'LspErrorText', 'virtualTexthl': 'LspErrorText'},
            \ 2: {'name': 'Warning', 'texthl': 'LspWarningHighlight', 'signText': '‼', 'signTexthl': 'LspWarningText', 'virtualTexthl': 'LspWarningText'},
            \ 3: {'name': 'Information', 'texthl': 'LspInformationHighlight', 'signText': 'ℹ', 'signTexthl': 'LspInformationText', 'virtualTexthl': 'LspInformationText'},
            \ 4: {'name': 'Hint', 'texthl': 'LspHintHighlight', 'signText': '▸', 'signTexthl': 'LspHintText', 'virtualTexthl': 'LspHintText'},
            \ }
"let g:LanguageClient_loggingFile = expand('~/vim-lc.log')
"let g:LanguageClient_loggingLevel = 'DEBUG'

augroup LanguageClient_setup
    autocmd!
    " keep track if the language server is running
    autocmd BufEnter * let b:Plugin_LanguageClient_started = 0
    autocmd User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
    autocmd User LanguageClientStopped let b:Plugin_LanguageClient_started = 0
    " show LanguageClient signature help on insert
    autocmd InsertEnter,CursorMovedI * if b:Plugin_LanguageClient_started | echo "" | silent call LanguageClient#textDocument_signatureHelp({}, 's:HandleOutputNothing') | endif
augroup END


command! -nargs=0 -count=0 BBcodeAction :call LanguageClient#textDocument_codeAction()
command! -nargs=0 -count=0 BBcodeLens :call LanguageClient#textDocument_codeLens()
command! -nargs=0 -count=0 BBcodeFormat :call LanguageClient#textDocument_formatting()
" }}}

" /* PLUGIN SETTINGS: asyncomplete /* {{{
"let g:asyncomplete_log_file = expand('~/vim-ac.log')

" TODO: Add filter to remove duplicates

" Activate additional completion sources
augroup asyncomplete_install
    autocmd!
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
                \ 'name': 'necovim',
                \ 'whitelist': ['vim'],
                \ 'completor': function('asyncomplete#sources#necovim#completor'),
                \ }))
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necosyntax#get_source_options({
                \ 'name': 'necosyntax',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#necosyntax#completor'),
                \ }))
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
                \ 'name': 'buffer',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#buffer#completor'),
                \ 'config': {
                \    'max_buffer_size': 5000000,
                \ },
                \ }))
    au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
                \ 'name': 'file',
                \ 'whitelist': ['*'],
                \ 'priority': 10,
                \ 'completor': function('asyncomplete#sources#file#completor')
                \ }))
augroup END
" }}}

" /* PLUGIN SETTINGS: vim-lsp */ {{{
let g:lsp_auto_enable = 0
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_virtual_text_enabled = 1
"let g:lsp_virtual_text_prefix = ' ¬ '
let g:lsp_virtual_text_prefix = ' ◉ '

let g:lsp_highlight_references_enabled = 1
let g:lsp_peek_alignment = 'center'

let g:lsp_signs_error = {'text': '✘'}
let g:lsp_signs_warning = {'text': '‼'}
let g:lsp_signs_information = {'text': 'ℹ'}
let g:lsp_signs_hint = {'text': '▸'}
let g:lsp_signs_priority_map = {
                \ 'LspError': 20,
                \ 'LspWarning': 12,
                \ 'LspInformation': 9,
                \ 'LspHint': 5,
                \ }

" c, cpp, cuda, objc ccls config
if executable('ccls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'ccls',
                \ 'cmd': {server_info->['ccls', '--log-file=/tmp/ccls.log']},
                \ 'whitelist': ['c', 'cpp', 'cuda', 'objc'],
                \ 'workspace_config': {
                \   'ccls': {
                \     'initializationOptions': {
                \       'cache': {'directory': '/tmp/ccls'},
                \     },
                \   },
                \ },
                \ })
endif

" python pyls config
if executable('pyls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'pyls',
                \ 'cmd': {server_info->['pyls']},
                \ 'whitelist': ['python'],
                \ 'workspace_config': {
                \   'pyls': {
                \     'configurationSources': ['flake8'],
                \     'plugins': {
                \       'autopep8': {'enabled': v:false},
                \       'flake8': {'enabled': v:true},
                \       'folding': {'enabled': v:false},
                \       'jedi_completion': {'enabled': v:true},
                \       'jedi_definiton': {'enabled': v:true},
                \       'jedi_highlight': {'enabled': v:true},
                \       'jedi_hover': {'enabled': v:true},
                \       'jedi_references': {'enabled': v:true},
                \       'jedi_signature_help': {'enabled': v:true},
                \       'jedi_symbols': {'enabled': v:true},
                \       'mccabe': {'enabled': v:false},
                \       'pycodestyle': {'enabled': v:false},
                \       'pydocstyle': {'enabled': v:false},
                \       'pyflakes': {'enabled': v:false},
                \       'pylint': {'enabled': v:false},
                \       'rope_completion': {'enabled': v:false},
                \       'rope_rename': {'enabled': v:false},
                \       'yapf': {'enabled': v:true},
                \     },
                \   },
                \ },
                \ })
endif

" rust rls config
if executable('rls')
    au User lsp_setup call lsp#register_server({
                \ 'name': 'rls',
                \ 'cmd': {server_info->['rls']},
                \ 'whitelist': ['rust'],
                \ 'workspace_config': {
                \   'rust': {
                \     'clippy_preference': 'on',
                \   },
                \ },
                \ })
endif
" }}}

" /* PLUGIN SETTINGS: ale */ {{{
" TODO: add linter with virtual text for files who are missing language servers
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_list_window_size = 5

"let g:ale_echo_msg_error_str = 'EE'
"let g:ale_echo_msg_warning_str = 'WW'
"let g:ale_echo_msg_format = '%severity%: [%linter%] %s'

let g:ale_linters_explicit = 1
"let g:ale_linters = {
"            \ 'c': ['gcc', 'flawfinder'],
"            \ 'asm': [],
"            \ 'python': [],
"            \ 'rust': [],
"            \ }

"let g:ale_c_parse_makefile = 1
"let g:ale_c_clangtidy_checks = ['-*', 'bugprone-*', 'cert-*-c', 'misc-*', 'mpi-*',
"            \ 'clang-analyzer-*', '-clang-analyzer-cplusplus.*', '-clang-analyzer-optin.*', '-clang-analyzer-osx.*',
"            \ 'modernize-*', 'performance-*', 'readability-*']
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
" use <c-space>for trigger completion
inoremap <silent> <expr><C-Space> pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
function! s:ExpandSnippetOrClosePum(accept) abort
    if pumvisible()
        if !empty(v:completed_item)
            return a:accept ? asyncomplete#close_popup() : asyncomplete#cancel_popup()
        else
            return asyncomplete#close_popup() . (a:accept ? "\<CR>" : "\<Esc>")
        endif
    else
        return a:accept ? "\<CR>" : "\<Esc>"
    endif
endfunction
inoremap <silent> <expr><CR> <SID>ExpandSnippetOrClosePum(1)
inoremap <silent> <expr><Esc> <SID>ExpandSnippetOrClosePum(0)


"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
"
"nmap <silent> ll :CocList diagnostics<CR>
"nmap <silent> ln <Plug>(coc-diagnostic-next)
"nmap <silent> lp <Plug>(coc-diagnostic-prev)
"
"nmap <silent> lf <Plug>(coc-fix-current)
"vmap <silent> lf <Plug>(coc-format-selected)
" }}}

" fold navigation
nnoremap zn zj
nnoremap zp zk
nnoremap zN :<C-u>call BB_JumpNextClosedFold(v:count1, 'j')<CR>
nnoremap zP :<C-u>call BB_JumpNextClosedFold(v:count1, 'k')<CR>

" tags
nnoremap ü <C-]>
nnoremap Ü <C-t>

" jumps
nnoremap ä <C-o>
nnoremap Ä <Tab>

" ale linter err/warn list
"nnoremap <silent> <leader>ll :ALELint<CR>
nnoremap <silent> <leader>lo :lopen 5<CR>
nnoremap <silent> <leader>lc :lclose<CR>

" reset search highlight
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" NERDTree
nnoremap <silent> <C-o> :call BB_ToggleNERDTree()<CR>

" FastFold
nmap <leader>zu <Plug>(FastFoldUpdate)

" help in vertical split
cabbrev vh vert help
" }}}


" /* GUI OPTIONS (color-scheme) */ {{{
"=======================================
" FIXME: neovim assumes 256colors on linux console, this breaks all colorschemes

" enable TrueColor if supported
if has('termguicolors')
    " TrueColor escape sequences for vim
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " Undercurl escape sequences for vim
    let &t_Cs = "\<Esc>[4:3m"
    let &t_Ce = "\<Esc>[4:0m"
    " enable gui support in terminal
    set termguicolors
endif

" set colorscheme
set background=dark

if has("gui_running")
    " GUI - Theme
    colorscheme material

    set guioptions-=T
    set guifont=Hack\ 10
    set lines=45
    set columns=132
else
    " Console - Theme
    if &t_Co == 8
        " FIXME: neovim assumes 256colors even on linux console
        set t_Co=256
        colorscheme distinguished
    else
        colorscheme material
        "highlight Normal ctermbg=black
    endif
endif

" load custom colorscheme overrides
source ~/.vim/startup/highlight.vim
" }}}

"" vim:fdm=marker:fdl=0
