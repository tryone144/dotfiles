"
" VIM
" Personal Vim configuration
"   custom functions
"
" file: ~/.vim/startup/functions.vim
" v1.9 / 2020.01.05
"
" (c) 2020 Bernd Busse
"

" NERDTree - open tree, highlight current Buffer in open tree or close tree
function! BB_ToggleNERDTree()
    if &diff | return | endif
    if (exists("b:NERDTree") && b:NERDTree.isTabTree()) | NERDTreeClose
    elseif (exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)) | NERDTreeFind
    else | NERDTreeFind
    endif
endfunction
"

" Parse Shebang line (taken from syntastic utils)
function! BB_ParseShebang(buf) abort
    for l:lnum in range(1, 5)
        let l:line = get(getbufline(a:buf, l:lnum), 0, '')
        if l:line =~# '^#!'
            let l:line = substitute(l:line, '\v^#!\s*(\S+/env(\s+-\S+)*\s+)?', '', '')
            let l:exe = matchstr(l:line, '\m^\S*\ze')
            let l:args = split(matchstr(l:line, '\m^\S*\zs.*'))
            return { 'exe': l:exe, 'args': l:args }
        endif
    endfor

    return { 'exe': '', 'args': [] }
endfunction
"

" Jump to next closed fold
function! BB_JumpNextClosedFold(cnt, dir)
    let l:cmd = 'norm!z' . a:dir
    let l:view = winsaveview()
    let [l:c, l:l0, l:l, l:open] = [1, 0, l:view.lnum, 1]
    while l:l != l:l0 && l:open
        exe l:cmd
        let [l:l0, l:l] = [l:l, line('.')]
        let l:open = foldclosed(l:l) < 0
        " FIXME: a:cnt > max possible jumps doesn't work when last fold is open
        if !l:open && l:c < a:cnt && l:l != l:l0
            let l:c = l:c+1
            let l:open = 1
        endif
    endwhile

    if l:open | call winrestview(l:view) | endif
endfunction
"

" Goto character offset in current buffer
function! BB_GotoCharacter(cnt)
    let l:saved_view = winsaveview()
    let l:old_virtualedit = &virtualedit

    try
        let [l:jumpStart, l:searchExpr, l:searchFlags] = ['gg0', '\%#\_.\{' . (a:cnt + 1) . '}', 'ceW']
        silent! execute 'normal' l:jumpStart

        if search(l:searchExpr, l:searchFlags) == 0
            " can't reach target destination, reset...
            execute "normal! \<C-\>\<C-n>\<Esc>" | " Beep.
            call winrestview(l:saved_view)
            return 0
        else
            return 1
        endif
    finally
        let &virtualedit = l:old_virtualedit
    endtry
endfunction

nnoremap <silent> gc :<C-u>if ! BB_GotoCharacter(v:count1 - 1)<Bar>echoerr 'No such position'<Bar>endif<Bar><CR>
command! -nargs=0 -count=0 -bar GoChar :call BB_GotoCharacter("<count>" - 1)
"

" Create / Update TmuxLine config
function! BB_UpdateTmuxlineConfig(overwrite)
    let l:old_theme = g:airline_theme
    let l:tmuxline_config = expand('~/.tmux-tmuxline.conf')

    execute 'AirlineTheme night_owl'
    let g:tmuxline_theme = 'airline'
    let g:tmuxline_preset = {
                \ 'a': ['#S', '#(wemux status_users)'],
                \ 'b': '#F',
                \ 'c': '#W',
                \ 'win': ['#I', '#W'],
                \ 'cwin': ['#I', '#W'],
                \ 'x': '%a',
                \ 'y': ['%b %d', '%R'],
                \ 'z': '#H'
                \ }
    Tmuxline | execute 'TmuxlineSnapshot' . (a:overwrite ? '! ' : ' ') . l:tmuxline_config
    execute 'AirlineTheme ' . l:old_theme
endfunction

if strlen($TMUX) && executable('tmux')
    command! -nargs=0 -bang -bar TmuxlineUpdateConfig :call BB_UpdateTmuxlineConfig(strlen("<bang>"))
endif
"

"" vim:fdm=marker:fdl=0
