"
" NEOVIM
" Personal nvim configuration
"   based on the main vim configuration
"   plugin-management with 'vim-plug'
"
" file: ~/.config/nvim/init.vim
" v0.9 / 2018.03.26
"
" (c) 2018 Bernd Busse
"

" Set classical vim compatible options
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" Load original .vimrc
source ~/.vimrc

