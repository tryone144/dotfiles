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
export EDITOR="vim"

# Disable GTK3 Window borders
export GTK_CSD=0

unset SSH_ASKPASS
export $(gnome-keyring-daemon -s)

# Colorized manpages
export LESS_TERMCAP_mb=$'\E[01;31m'         # begin blink
export LESS_TERMCAP_md=$'\E[01;38;5;196m'   # begin bold
export LESS_TERMCAP_me=$'\E[0m'             # end mode
export LESS_TERMCAP_so=$'\E[38;5;226m'      # begin standout
export LESS_TERMCAP_se=$'\E[0m'             # end standout
export LESS_TERMCAP_us=$'\E[04;38;5;63m'    # begin underline
export LESS_TERMCAP_ue=$'\E[0m'             # end underline

# The Fuck (command regeneration)
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'

# Le Prompts
#PS1='[\u@\h \W]\$ ' # Default Bash Prompt
function _update_ps1() {
    export PS1="$( arrowline ${?} 2> /dev/null || echo 'arrowline failed! [\u@\h \W]\$ ' )"
}
export PROMPT_COMMAND=_update_ps1

#Archey3 greeting
[[ -n ${DISPLAY} || -n ${SSH_CONNECTION} ]] && archey3 --config=~/.config/archey3.cfg

