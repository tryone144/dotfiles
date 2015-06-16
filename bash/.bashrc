#
# BASH
# .bashrc with archey greeting and custom prompt (powerline-style)
# imports custom functions
#   needs: [archey3]
#          [powerline-fonts]
# 
# file: ~/.bashrc
# v1.6.2 / 2015.06.01
#
# (c) 2015 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# import custom functions
[[ -f ~/.shrc ]] && . ~/.shrc

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export EDITOR="vim"

# Disable GTK3 Window borders
export GTK_CSD=0

unset SSH_ASKPASS
export $(gnome-keyring-daemon -s)

# Aliase
alias ls='ls --color=auto -h'
alias grep='grep --color=auto'
alias clr='clear; archey3 --config=~/.config/archey3.cfg'
alias update='yaourt -Syua'
alias webcam='mplayer tv:// -tv driver=v4l2 -vo gl'
alias rainbow='for i in {0..255}; do echo -e "\e[0;38;5;${i};49;22m${i}: COLOR RAINBOW\e[0m"; done'
alias win7='_PWD_SAVE=${PWD}; cd /opt/kvm/; ./start_win7.sh -spice-client spicy; cd ${_PWD_SAVE}'

# The Fuck (command regeneration)
alias fuck='eval $(thefuck $(fc -ln -1)); history -r'

# Le Prompts
#PS1='[\u@\h \W]\$ ' # Default Bash Prompt
function _update_ps1() {
    export PS1="$(arrowline ${?} 2> /dev/null)"
}
export PROMPT_COMMAND=_update_ps1

if [[ -z "$DISPLAY" ]]; then
    # set powerline console font
    setfont ter-powerline-v16b
fi

#Archey3 greeting
archey3 --config=~/.config/archey3.cfg

