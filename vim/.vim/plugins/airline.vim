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

let g:airline_powerline_fonts = 1
let g:airline_theme = 'zenburn'

let g:airline#extensions#ale#enabled = 0
let g:airline#extensions#coc#enabled = 0
let g:airline#extensions#languageclient#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#tmuxline#enabled = 0

" additional section for codeium
let g:airline_section_y = '%3{codeium#GetStatusString()}'

"" vim:fdm=marker:fdl=0
