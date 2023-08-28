"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   gui configuration (colorscheme, escape sequences, font)
"
" file: ~/.vim/startup/gui.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

" FIXME: neovim assumes 256colors on linux console, this breaks all colorschemes

" enable TrueColor if supported
if has('termguicolors')
    " TrueColor escape sequences
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    " Undercurl escape sequences
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

"" vim:fdm=marker:fdl=0
