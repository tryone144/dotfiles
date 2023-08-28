"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   keybindings
"
" file: ~/.vim/startup/keybindings.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

let mapleader = "\<Space>"

" /* MOVEMENT */ {{{
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

" goto byte in file
nnoremap <silent> gc :<C-u>if ! BB_GotoCharacter(v:count1 - 1)<Bar>echoerr 'No such position'<Bar>endif<Bar><CR>

" , is faster than : on neo2
nmap , :
vmap , :

" no 'ex' mode
nmap Q <NOP>

" /* FILE SAVING */ {{{
nnoremap <leader>ss :update<CR>
nnoremap <leader>bs :update<CR>

" safer version of ZZ
nnoremap ZZ :confirm qa<CR>
" }}}

" /* WINDOW NAVIGATION */ {{{
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

" /* BUFFER NAVIGATION */ {{{
nmap <silent> <C-p> :bprevious<Bar>if &buftype ==# 'quickfix'<Bar>bprevious<Bar>endif<CR>
nmap <silent> <C-n> :bnext<Bar>if &buftype ==# 'quickfix'<Bar>bnext<Bar>endif<CR>
nmap <silent> <leader>bn <C-n>
nmap <silent> <leader>bp <C-p>
nmap <silent> <leader>br :e<CR>
nmap <silent> <leader>ba :enew<CR><C-o>
nmap <silent> <leader>bq :Bwipeout<CR>
nmap <silent> <leader><Tab> <C-n>
" }}}

" /* AUTOCLOMPLETION */ {{{
" use <c-space>for trigger completion
inoremap <silent> <expr><C-Space> pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>"
" close with <esc>, accept with <cr>
inoremap <silent> <expr><CR> pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>" ) : "\<CR>"
inoremap <silent> <expr><Esc> pumvisible() ? "\<C-e><Esc>": "\<Esc>"
" keep <bs> working
inoremap <silent> <expr><BS> pumvisible() ? "\<C-e><BS>" : "\<BS>"

" codeium trigger
nnoremap <silent> <expr><C-c> codeium#Enabled() ? "\<Cmd>CodeiumDisable<CR>" : "\<Cmd>CodeiumEnable<CR>"
inoremap <silent> <C-c> <Cmd>call codeium#CycleOrComplete()<CR>
inoremap <silent> <C-x> <Cmd>call codeium#Clear()<CR>
inoremap <silent> <expr><Tab> codeium#Enabled() ? codeium#Accept() : "\<Tab>"


" function! s:ExpandSnippetOrClosePum(accept) abort
"    if pumvisible()
"        if !empty(v:completed_item)
"            return a:accept ? asyncomplete#close_popup() : asyncomplete#cancel_popup()
"        else
"            return asyncomplete#close_popup() . (a:accept ? "\<CR>" : "\<Esc>")
"        endif
"    else
"        return a:accept ? "\<CR>" : "\<Esc>"
"    endif
"endfunction
"inoremap <silent> <expr><CR> <SID>ExpandSnippetOrClosePum(1)
"inoremap <silent> <expr><Esc> <SID>ExpandSnippetOrClosePum(0)
" }}}

" loclist (err/warn list)
nnoremap <silent> <leader>lo :lopen 5<CR>
nnoremap <silent> <leader>lc :lclose<CR>

" reset search highlight
nnoremap <silent> <CR> :nohlsearch<CR><CR>

" autopairs
nnoremap <buffer><silent> <expr><leader>pp AutoPairsToggle()

" NERDTree
nnoremap <silent> <C-o> :call BB_ToggleNERDTree()<CR>

" FastFold
nmap <leader>zu <Plug>(FastFoldUpdate)

" help in vertical split
cabbrev vh vert help

"" vim:fdm=marker:fdl=0
