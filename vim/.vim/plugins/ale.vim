"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   plugin settings: ale
"
" file: ~/.vim/plugins/airline.vim
" v2.0 / 2023.05.24
"
" (c) 2023 Bernd Busse
"

" TODO: add linter with virtual text for files who are missing language servers
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_open_list = 0
let g:ale_list_window_size = 5

"let g:ale_echo_msg_error_str = 'EE'
"let g:ale_echo_msg_warning_str = 'WW'
"let g:ale_echo_msg_format = '%severity%: [%linter%] %s'

let g:ale_linters_explicit = 1
"let g:ale_linters = {
"            \ 'c': ['gcc', 'flawfinder'],
"            \ 'asm': [],
"            \ 'python': [],
"            \ 'rust': [],
"            \ }

"let g:ale_c_parse_makefile = 1
"let g:ale_c_clangtidy_checks = ['-*', 'bugprone-*', 'cert-*-c', 'misc-*', 'mpi-*',
"            \ 'clang-analyzer-*', '-clang-analyzer-cplusplus.*', '-clang-analyzer-optin.*', '-clang-analyzer-osx.*',
"            \ 'modernize-*', 'performance-*', 'readability-*']

"" vim:fdm=marker:fdl=0
