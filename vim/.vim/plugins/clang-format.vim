"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   plugin settings: clang-format
"
" file: ~/.vim/plugins/airline.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

let g:clang_format#code_style = 'llvm'
let g:clang_format#detect_style_file = 1
let g:clang_format#auto_format = 0
let g:clang_format#auto_format_on_insert_leave = 0

"" vim:fdm=marker:fdl=0
