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

function _update_ps1() {
    export PS1="$( arrowline ${?} 2> /dev/null || echo 'arrowline failed! [\u@\h \W]\$ ' )"

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
