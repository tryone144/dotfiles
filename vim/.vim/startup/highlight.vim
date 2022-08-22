"
" VIM
" Personal Vim configuration
"   colorscheme modifications
"
" file: ~/.vim/startup/highlight.vim
" v1.9 / 2020.01.05
"
" (c) 2020 Bernd Busse
"

" /* ADITIONAL COLORSCHEME HIGHLIGHTS */
function! BB_UpdateColorschemeHighlights()
    " more visible line numbers
    highlight LineNr guifg=#8bc34a ctermfg=2
    highlight CursorLineNr guifg=#ffeb3b ctermfg=3

    " vim-lsp / LanguageClient diagnostic highlights
    highlight LspErrorHighlight guisp=#ad1457 gui=undercurl cterm=undercurl term=undercurl
    highlight LspErrorText guifg=#ad1457 guibg=NONE gui=NONE,bold,italic ctermfg=5 ctermbg=NONE cterm=NONE,bold,italic term=NONE,bold,italic
    highlight clear LspErrorLine

    highlight LspWarningHighlight guisp=#ffa74d gui=undercurl cterm=undercurl term=undercurl
    highlight LspWarningText guifg=#ffa74d guibg=NONE gui=NONE,bold,italic ctermfg=9 ctermbg=NONE cterm=NONE,bold,italic term=NONE,bold,italic
    highlight clear LspWarningLine

    highlight clear lspInformationHighlight
    highlight LspInformationText guifg=#fff176 guibg=NONE gui=NONE,italic ctermfg=11 ctermbg=NONE cterm=NONE,italic term=NONE,italic
    highlight clear LspInformationLine

    highlight clear LspHintHighlight
    highlight LspHintText guifg=#37474f guibg=NONE gui=NONE,italic ctermfg=8 ctermbg=NONE cterm=NONE,italic term=NONE,italic
    highlight clear LspHintLine
endfunction
"

" set highlights on startup
call BB_UpdateColorschemeHighlights()

" update after ColorScheme change
autocmd ColorScheme * call BB_UpdateColorschemeHighlights()

"" vim:fdm=marker:fdl=0
