function pcat --wraps pygmentize --description 'alias pcat=pygmentize -O style=monokai,bg=dark -F codetagify'
    pygmentize -O style=monokai,bg=dark -F codetagify $argv;
end
