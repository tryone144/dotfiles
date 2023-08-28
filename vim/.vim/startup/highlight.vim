"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   colorscheme modifications
"
" file: ~/.vim/startup/highlight.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

" /* ADITIONAL COLORSCHEME HIGHLIGHTS */
function! BB_UpdateColorschemeHighlights()
    " more visible line numbers
    highlight LineNr guifg=#8bc34a ctermfg=2
    highlight CursorLineNr guifg=#ffeb3b ctermfg=3

    " diagnostic highlights
    highlight DiagnosticUnderlineError guisp=#ad1457 gui=undercurl cterm=undercurl term=undercurl
    highlight DiagnosticError guifg=#ad1457 guibg=NONE gui=NONE,bold,italic ctermfg=5 ctermbg=NONE cterm=NONE,bold,italic term=NONE,bold,italic

    highlight DiagnosticUnderlineWarn guisp=#ffa74d gui=undercurl cterm=undercurl term=undercurl
    highlight DiagnosticWarn guifg=#ffa74d guibg=NONE gui=NONE,bold,italic ctermfg=9 ctermbg=NONE cterm=NONE,bold,italic term=NONE,bold,italic

    highlight DiagnosticUnderlineInfo guisp=#fff176 gui=undercurl cterm=undercurl term=undercurl
    highlight DiagnosticInfo guifg=#fff176 guibg=NONE gui=NONE,italic ctermfg=11 ctermbg=NONE cterm=NONE,italic term=NONE,italic

    highlight DiagnosticUnderlineHint guisp=#37474f gui=undercurl cterm=undercurl term=undercurl
    highlight DiagnosticHint guifg=#37474f guibg=NONE gui=NONE,italic ctermfg=8 ctermbg=NONE cterm=NONE,italic term=NONE,italic
endfunction
"

" set highlights on startup
call BB_UpdateColorschemeHighlights()

" update after ColorScheme change
autocmd ColorScheme * call BB_UpdateColorschemeHighlights()

"" vim:fdm=marker:fdl=0
