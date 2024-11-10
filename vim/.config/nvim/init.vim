"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   configuration entry point
"
" file: ~/.config/nvim/init.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

" Set classical vim compatible options
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Load original .vimrc
source ~/.vimrc

" nvim specific configuration (language server + autocomplete)
if is_nvim && !in_vscode
    lua require('diagnostic')
    lua require('lsp')
    lua require('treesitter')
endif

" vscode specific configuration (keybindings)
if is_nvim && in_vscode
    lua require('vscode')
endif
