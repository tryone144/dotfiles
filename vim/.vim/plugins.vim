"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   plugin loading using vim-plug
"
" file: ~/.vim/plugins.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

if !in_vscode
    call plug#begin('~/.vim/plugged')

    " ============ Syntax ============
    " gas - GNU assembler syntax highlight
    Plug 'Shirk/vim-gas/'

    " arm-syntax - armv7 syntax highlight
    Plug 'ARM9/arm-syntax-vim'

    " pug - Pug template highlight
    Plug 'digitaltoad/vim-pug'

    " astro - Astro components highlight
    Plug 'wuelnerdotexe/vim-astro', { 'for': ['astro'] }

    " ============ UI ============
    " colorschemes
    Plug 'Lokaltog/vim-distinguished'
    Plug 'morhetz/gruvbox'
    Plug 'kaicataldo/material.vim'

    " vim-airline - statusline
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " tmuxline - statusline for tmux
    Plug 'edkolev/tmuxline.vim'

    " nerdtree - file browsser
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTree', 'NERDTreeToggle', 'NERDTreeFind'] }

    " gitgutter - git status
    Plug 'airblade/vim-gitgutter'

    " fugitive - git diffing
    "Plug 'tpope/vim-fugitive'

    " FastFold - faster fold calculation
    Plug 'Konfekt/FastFold'

    " BBye - close buffers without closing windows
    Plug 'moll/vim-bbye'

    " auto-pairs - auto braces
    Plug 'jiangmiao/auto-pairs'

    " clang-format - support for clang-format formatting
    Plug 'rhysd/vim-clang-format', { 'for': ['c', 'cpp'] }

    " fzf - fuzzy search
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    if is_nvim
        " plenary.nvim - global utilities for lua scripting
        Plug 'nvim-lua/plenary.nvim'

        " nvim-lspconfig - language server configuration
        Plug 'neovim/nvim-lspconfig'

        " nvim-treesitter - advanced parsing and highlighting
        Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

        Plug 'saecki/crates.nvim', { 'tag': 'v0.4.0', 'on': ['BufRead Cargo.toml'] }

        " coq - fast autocomlete
        Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
        Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
        Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
    endif

    " ale - async syntax checking and linting
    "Plug 'dense-analysis/ale'

    " Codeium - AI powered autocomplete
    Plug 'Exafunction/codeium.vim'

    call plug#end()
endif

if !in_vscode

    " load plugin configurations
    source ~/.vim/plugins/airline.vim
    source ~/.vim/plugins/ale.vim
    source ~/.vim/plugins/autopairs.vim
    source ~/.vim/plugins/codeium.vim
    source ~/.vim/plugins/clang-format.vim
    source ~/.vim/plugins/gitgutter.vim
    source ~/.vim/plugins/material.vim
    source ~/.vim/plugins/nerdtree.vim

endif

"" vim:fdm=marker:fdl=0
