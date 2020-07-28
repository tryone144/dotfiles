#
# BASH
# .bashrc with custom prompt (powerline-style)
# imports custom functions, supports launching into fish
#   needs: [powerline-fonts]
# 
# file: ~/.bashrc
# v1.8.2 / 2019.05.15
#
# (c) 2019 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# import custom functions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

export EDITOR="nvim"

# Fix wonky completion on default tool with 'bash-completion'
compopt -o bashdefault ls
compopt -o bashdefault rm
compopt -o bashdefault cp

# Colorized manpages
export LESS=-R      # Output ANSI escapes as-is
export LESS_TERMCAP_mb=$'\e[1;4;37m'        # begin blink
export LESS_TERMCAP_md=$'\e[1;38;5;197m'    # begin bold
export LESS_TERMCAP_me=$'\e[0m'             # end mode
export LESS_TERMCAP_so=$'\e[1;38;5;39m'     # begin standout
export LESS_TERMCAP_se=$'\e[0m'             # end standout
export LESS_TERMCAP_us=$'\e[1;38;5;220m'    # begin underline
export LESS_TERMCAP_ue=$'\e[0m'             # end underline

# Colorized GCC
export GCC_COLORS='error=1;35:warning=1;31:note=1;36:caret=1;32:locus=1:quote=1'

# The Fuck (command regeneration)
eval "$(thefuck --alias)"

# Le Prompts
#PS1='[\u@\h \W]\$ ' # Default Bash Prompt
__vte_urlencode() (
  # This is important to make sure string manipulation is handled
  # byte-by-byte.
  LC_ALL=C
  str="$1"
  while [ -n "$str" ]; do
    safe="${str%%[!a-zA-Z0-9/:_\.\-\!\'\(\)~]*}"
    printf "%s" "$safe"
    str="${str#"$safe"}"
    if [ -n "$str" ]; then
      printf "%%%02X" "'$str"
      str="${str#?}"
    fi
  done
)

__vte_osc7 () {
  printf "\033]7;file://%s%s\007" "${HOSTNAME:-}" "$(__vte_urlencode "${PWD}")"
}

function _fancy_ps1() {
    local exit_status="$?"
    local color_bg="\e[1;36m"
    local prompt_char="$"
    local prompt_col="\e[1;32m"
    local user_col="\e[1;32m"
    local host_col="\e[1m"
    local cwd_col="\e[1;37m"

    if [[ "$exit_status" -ne 0 ]]; then
        color_bg="\e[1;35m"
        prompt_char="%"
        prompt_col="\e[1;31m"
    fi

    if [[ "$UID" -eq 0 ]]; then
        user_col="\e[1;31m"
    fi

    if [[ -n "$SSH_CONNECTION" ]]; then
        host_col="\e[1;33m"
    fi

    local line_one="\[$color_bg\]┬─[\[$user_col\]\u\[\e[0m\]@\[$host_col\]\h\[\e[0m$color_bg\]]\[\e[0m\]:\[$color_bg\]<\[$cwd_col\]\w\[\e[0m$color_bg\]>\[\e[0m\]:‹›"
    local line_two="\[$color_bg\]└─›\[$prompt_col\] $prompt_char \[\e[0m\]"
    echo -e "$line_one\n$line_two"
}

function _update_ps1() {
    # export PS1="$( arrowline ${?} 2> /dev/null || echo 'arrowline failed! [\u@\h \W]\$ ' )"
    export PS1="$( _fancy_ps1 || echo '[\u@\h \W]\$ ' )"

    local pwd='~'
    [ "$PWD" != "$HOME" ] && pwd=${PWD/#$HOME\//\~\/}
    printf "\033]0;%s@%s:%s\007%s" "${USER}" "${HOSTNAME%%.*}" "${pwd}" "$(__vte_osc7)"
}
export PROMPT_COMMAND=_update_ps1

# Archey3 greeting (too cumbersome)
#if [[ ! -n ${NO_ARCHEY+found} ]] && [[ -n ${DISPLAY} || -n ${SSH_CONNECTION} || -n ${TMUX} ]]; then
#    archey3 --config=~/.config/archey3.cfg
#fi

# Change interactive shell to /bin/fish
if [[ -z "${NO_FISH+found}" ]] && [[ -z "${BASH_EXECUTION_STRING}" ]] && [[ -n "${DISPLAY}" || -n "${SSH_CONNECTION}" ]]; then
    exec /bin/fish
fi
