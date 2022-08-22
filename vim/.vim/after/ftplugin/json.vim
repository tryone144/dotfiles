" Vim filetype plugin file -- better JSON defaults
" Language:             JSON
" Latest Change:        2020 Jan 05
" Maintainer:           Bernd Busse @tryone144
" Previous Maintainer:  David Barnett <daviebdawg+vim@gmail.com>

if exists('b:did_after_ftplugin') | finish | endif
let b:did_after_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

let b:undo_ftplugin = 'setlocal shiftwidth< tabstop< comments< commentstring<'

setlocal shiftwidth=2 tabstop=2
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=/*%s*/

let &cpo = s:cpo_save
unlet s:cpo_save

