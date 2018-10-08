#
# BASH
# .bashrc with archey greeting and custom prompt (powerline-style)
# imports custom functions
#   needs: [archey3]
#          [powerline-fonts]
# 
# file: ~/.bashrc
# v1.7 / 2016.01.08
#
# (c) 2015 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# import custom functions
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export PATH="~/.cargo/bin:$PATH"
export EDITOR="nvim"

# Disable GTK3 Window borders
export GTK_CSD=0

unset SSH_ASKPASS
#export $(gnome-keyring-daemon -s)

# Colorized manpages
export LESS_TERMCAP_mb=$'\E[01;31m'         # begin blink
export LESS_TERMCAP_md=$'\E[01;38;5;196m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'             # end mode
export LESS_TERMCAP_so=$'\E[38;5;226m'      # begin standout
export LESS_TERMCAP_se=$'\E[0m'             # end standout
export LESS_TERMCAP_us=$'\E[04;38;5;63m'    # begin underline
export LESS_TERMCAP_ue=$'\E[0m'             # end underline

# Load tmuxinator completion
[[ -r ~/.local/share/bash-completion/tmuxinator.bash ]] && source ~/.local/share/bash-completion/tmuxinator.bash

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

#Archey3 greeting
if [[ ! -n ${NO_ARCHEY+found} ]] && [[ -n ${DISPLAY} || -n ${SSH_CONNECTION} || -n ${TMUX} ]]; then 
    archey3 --config=~/.config/archey3.cfg
fi

