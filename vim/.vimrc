"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   main configuration
"
" file: ~/.vimrc
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

let is_vim = !has('nvim')
let is_nvim = has('nvim')
let in_vscode = exists('g:vscode')

" shared base configuration
source ~/.vim/startup/common.vim

" load plugins with configuration
source ~/.vim/plugins.vim

if !in_vscode

    source ~/.vim/startup/functions.vim

    " custom keymap and rebinds
    source ~/.vim/startup/keybindings.vim

    " UI configuration (colorscheme, etc.)
    source ~/.vim/startup/gui.vim

endif

" " /* GLOBAL AUTOCOMMANDS */ {{{
" if has('autocmd')
"     " determine python linter depending on Shebang if not in venv
"     "autocmd FileType python if $VIRTUAL_ENV == "" |
"     "    \ let b:ale_python_flake8_executable = BB_ParseShebang(expand('<afile>', 1))['exe'] |
"     "    \ let b:ale_python_flake8_options = '-m flake8' | endif
"     "autocmd FileType python if $VIRTUAL_ENV == "" |
"     "    \ call coc#config('coc.preferences', {
"     "        \ 'python.pythonPath': BB_ParseShebang(expand('<afile>', 1))['exe']
"     "        \ }) | endif
" 
"     " enable LanguageClient only for languages that have the server registered
"     augroup lsp_enable
"         autocmd!
"         "autocmd FileType c,python,rust call lsp#enable()
"         autocmd FileType c,cpp,cuda,objc,python,rust,vue LanguageClientStart
"     augroup END
" endif
" " }}}
" 
" " /* PLUGIN SETTINGS: LanguageClient */ {{{
" let g:LanguageClient_changeThrottle = 0.2
" let g:LanguageClient_signatureHelpOnCompleteDone = 0
" 
" " TODO: Add CodeLens once implemented
" 
" augroup LanguageClient_setup
"     autocmd!
"     " keep track if the language server is running
"     autocmd BufEnter * let b:Plugin_LanguageClient_started = 0
"     autocmd User LanguageClientStarted let b:Plugin_LanguageClient_started = 1
"     autocmd User LanguageClientStopped let b:Plugin_LanguageClient_started = 0
"     " show LanguageClient signature help on insert
"     autocmd InsertEnter,CursorMovedI * if b:Plugin_LanguageClient_started | echo "" | silent call LanguageClient#textDocument_signatureHelp({}, 's:HandleOutputNothing') | endif
" augroup END
" 
" 
" command! -nargs=0 -count=0 BBcodeAction :call LanguageClient#textDocument_codeAction()
" command! -nargs=0 -count=0 BBcodeLens :call LanguageClient#textDocument_codeLens()
" command! -nargs=0 -count=0 BBcodeFormat :call LanguageClient#textDocument_formatting()
" " }}}
" 

"" vim:fdm=marker:fdl=0
