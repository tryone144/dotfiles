" Vim filetype plugin file -- better YAML defaults
" Language:             YAML (YAML Ain't Markup Language)
" Latest Change:        2020 Jan 05
" Maintainer:           Bernd Busse @tryone144
" Previous Maintainer:  Nikolai Weibull <now@bitwi.se>

if exists('b:did_after_ftplugin') | finish | endif
let b:did_after_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = 'setlocal shiftwidth< tabstop<'

setlocal shiftwidth=2 tabstop=2

let &cpo = s:cpo_save
unlet s:cpo_save
