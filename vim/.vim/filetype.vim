"
" VIM / NEOVIM
" Personal (neo)vim configuration
"   additional filetype detection
"
" file: ~/.vim/filetype.vim
" v2.0 / 2023.12.11
"
" (c) 2023 Bernd Busse
"

if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  "au! BufRead,BufNewFile *.mdx setfiletype mdx
  au! BufRead,BufNewFile *.mdx setfiletype markdown
augroup END
