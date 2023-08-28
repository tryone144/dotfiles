"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   plugin settings: fastfold
"
" file: ~/.vim/plugins/airline.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x', 'X', 'a', 'A', 'o', 'O', 'c', 'C', 'r', 'R', 'm', 'M']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']

"" vim:fdm=marker:fdl=0
