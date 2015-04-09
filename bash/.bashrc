#
# BASH
# .bashrc with archey greeting and powerline-styled prompt
# declares custom functions
#   needs: [archey3]
#          [powerline-fonts]
# 
# file: ~/.bashrc
# v1.3.3 / 2015.04.09
#
# (c) 2015 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export EDITOR="vim"

# Disable GTK3 Window borders
export GTK_CSD=0

unset SSH_ASKPASS

# Aliase
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias clr='clear; archey3 --config=~/.config/archey3.cfg'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT1'

# Simple Stopwatch
function stopwatch() {
    date1=$(date +%s); 
    while true; do 
        echo -ne "$(date -u --date @$(($(date +%s) - ${date1})) +%H:%M:%S)\r"; sleep 0.1
    done
}

# Simple countdown timer
function countdown() {
    seconds=${1};
    if [ -z ${seconds} ]; then
        return
    fi
    date1=$(($(date +%s) + ${seconds})); 
    while [ "${date1}" -ne $(date +%s) ]; do 
        echo -ne "$(date -u --date @$((${date1} - $(date +%s) )) +%H:%M:%S)\r"; 
    done
    echo -e "BOOOOOOOMMMM!!!!!!"
}

if [[ -z "$DISPLAY" ]]; then
    # set powerline console font
    setfont ter-powerline-v16b
fi

# Le Prompts
#PS1='[\u@\h \W]\$ ' # Default Bash Prompt
prompt_escape() {
    echo "\[${1}\]"
}

host_fg=16
if [ "${EUID}" = 0 ]; then
    host_bg=203
elif [ -n "${SUDO_USER}" ]; then
    host_bg=221
else
    host_bg=47
fi
abs_fg=250
abs_bg=240
cwd_sep=245
cwd_fg=252
cwd_bg=240

host_color="$(prompt_escape '\e[0;38;5;${host_fg};48;5;${host_bg};1m')"
host_end_color="$(prompt_escape '\e[0;38;5;${host_bg};48;5;${abs_bg};22m')"
abs_color="$(prompt_escape '\e[0;38;5;${abs_fg};48;5;${abs_bg}m')"
abs_end_color="$(prompt_escape '\e[0;38;5;${cwd_sep};48;5;${abs_bg};22m')"
cwd_color="$(prompt_escape '\e[0;38;5;${cwd_fg};48;5;${cwd_bg};1m')"
cwd_end_color="$(prompt_escape '\e[0;38;5;${cwd_bg};49;22m')"

host_piece="${host_color} ${USER}@${HOSTNAME} ${host_end_color}"

prompt_gen() {
    working_dir="${PWD}"
    if [[ ${working_dir} == ${HOME}* ]]; then
        abs_piece="~"
    else
        abs_piece="/"
    fi
    working_dir="${working_dir/#${HOME}/}"
    working_dir="${working_dir/#\//}"

    if [ -n "${working_dir}" ]; then
        cwd_path="${abs_end_color}${abs_color}"
        slashes="${working_dir//[^\/]}"
        if ((${#slashes} > 0)); then
            if ((${#slashes} > 2)); then
                abs_piece="$((${#slashes}-2))"
                for i in $(seq 3 ${#slashes}); do
                    working_dir="${working_dir#*/}"
                done
            fi
            slashes="${working_dir//[^\/]}"
            for i in $(seq 1 ${#slashes}); do
                cwd_path="${cwd_path} $(echo "${working_dir}" | cut -d'/' -f$i) ${abs_end_color}${abs_color}"
            done
        fi
        cwd_last="${cwd_color}$(echo "${working_dir}" | cut -d'/' -f $((${#slashes}+1)))"
        cwd_piece="${abs_color} ${abs_piece} ${cwd_path} ${cwd_last} ${cwd_end_color}"
    else
        cwd_piece="${cwd_color} ${abs_piece} ${cwd_end_color}"
    fi
    
    pieces="${host_piece}${cwd_piece}"
    PS1="${pieces} \[\e[0m\]"
}

PROMPT_COMMAND=prompt_gen

#Archey3 greeting
archey3 --config=~/.config/archey3.cfg

