function update_colorscheme -d "(Re-)Set universal colorscheme variables"
    set -u fish_color_autosuggestion    white
    set -u fish_color_cancel            red
    set -u fish_color_command           green
    set -u fish_color_comment           yellow
    set -u fish_color_cwd               cyan
    set -u fish_color_cwd_root          red
    set -u fish_color_end               magenta
    set -u fish_color_error             red
    set -u fish_color_escape            yellow
    set -u fish_color_history_current   --bold
    set -u fish_color_host              yellow
    set -u fish_color_match             --background=brblue
    set -u fish_color_normal            normal
    set -u fish_color_operator          blue
    set -u fish_color_param             cyan
    set -u fish_color_quote             yellow
    set -u fish_color_redirection       magenta
    set -u fish_color_search_match      bryellow --background=brblack
    set -u fish_color_status            red
    set -u fish_color_user              green
    set -u fish_color_valid_path        --underline

    set -u fish_pager_color_completion  normal
    set -u fish_pager_color_description yellow
    set -u fish_pager_color_prefix      white --bold --underline
    set -u fish_pager_color_progress    brwhite --background=cyan
    set -u fish_pager_color_secondary   normal
end

