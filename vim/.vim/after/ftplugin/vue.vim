" Vim filetype plugin file -- better Vue defaults
" Language:             Vue
" Latest Change:        2020 Feb 24
" Maintainer:           Bernd Busse @tryone144

if exists('b:did_after_ftplugin') | finish | endif
let b:did_after_ftplugin = 1

let b:undo_ftplugin = 'setlocal shiftwidth< tabstop<'

setlocal shiftwidth=2 tabstop=2
