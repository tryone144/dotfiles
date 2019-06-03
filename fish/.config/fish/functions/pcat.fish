function pcat --description 'alias pcat=pygmentize -O style=monokai,bg=dark -F codetagify'
    pygmentize -O style=monokai,bg=dark -F codetagify $argv;
end
