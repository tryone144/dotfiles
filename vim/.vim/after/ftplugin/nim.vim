" Vim filetype plugin file -- better NIM defaults
" Language:             NIM
" Latest Change:        2026 Jan 23
" Maintainer:           Bernd Busse @tryone144

if exists('b:did_after_ftplugin') | finish | endif
let b:did_after_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = 'setlocal shiftwidth< tabstop<'

setlocal shiftwidth=2 tabstop=2

let &cpo = s:cpo_save
unlet s:cpo_save
