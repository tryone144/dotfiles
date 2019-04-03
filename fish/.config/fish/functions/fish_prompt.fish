function _prompt_user
    switch (id -u)
        case 0
            set_color red -o
        case '*'
            set_color green -o
    end

    echo -n "$USER"
    set_color normal

    if set -q SSH_CONNECTION
        echo -n "@"
        set_color yellow -o
        echo -n (prompt_hostname)
        set_color normal
    end
end

function _prompt_pwd
    set_color cyan -o
    echo -n (prompt_pwd)
    set_color normal
end

function _prompt_git
    if not set -q __prompt_git_init
        set -g __fish_git_prompt_show_informative_status 1
        set -g __fish_git_prompt_hide_untrackedfiles 1
        set -g __fish_git_prompt_showcolorhints 1
        set -g __fish_git_prompt_color "brblue"
        set -g __fish_git_prompt_color_prefix "normal"
        set -g __fish_git_prompt_color_suffix "brblue"
        set -g __fish_git_prompt_color_cleanstate "green"
        set -g __fish_git_prompt_char_untrackedfiles
        set -g __fish_git_prompt_char_dirtystate "∩"
        set -g __fish_git_prompt_char_stagedstate "∪"

        set -g __prompt_git_init 1
    end

    if not set -q __prompt_gitfmt
        set -g __prompt_gitfmt "∷"(set_color brblue)"⟨%s⟩"
    end

    echo -n (__fish_git_prompt "$__prompt_gitfmt")
end

function fish_prompt -d "Print the input prompt"
    # Cache last exit status
    set -l exit_status $status

    # Cache fixed values over runtime
    if not set -q __prompt_segment_user
        set -g __prompt_segment_user (_prompt_user)
    end

    # Set colors
    set -l pc_border (set_color blue)
    set -l pc_prompt (set_color green -o)
    set -l pc_sep (set_color normal)

    set -l prompt_char "λ"

    if test $exit_status -ne 0
        set pc_border (set_color magenta)
        set pc_prompt (set_color red -o)

        set prompt_char "✘"
    end

    set -l fmt_l1 "$pc_border╦═⟪%s$pc_border⟫$pc_sep∷$pc_border⟨%s$pc_border⟩%s$pc_sep∷❮❯"(set_color normal)
    printf "$fmt_l1\n" "$__prompt_segment_user" (_prompt_pwd) (_prompt_git)

    set -l fmt_l2 "$pc_border╚═❯"(set_color normal)" $pc_prompt%s"(set_color normal)" "
    printf "$fmt_l2" "$prompt_char"
end

