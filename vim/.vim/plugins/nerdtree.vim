"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   plugin settings: airline
"
" file: ~/.vim/plugins/airline.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

let g:NERDTreeShowHidden = 1
let g:NERDTreeQuitOnOpen = 1

if has('autocmd')
    " close anyway if NERDTree is the last window
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
endif

"" vim:fdm=marker:fdl=0
