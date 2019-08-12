function rcd --description 'Change CWD with ranger'
    # Choose dir with ranger
    ranger --choosedir=$HOME/.cache/rangertarget $argv
    if test $status -ne 0
        return $status
    end

    # Change current working directory
    set target ( cat $HOME/.cache/rangertarget )
    if test -n $target
        cd $target
    end
end
