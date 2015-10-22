#
# BASH
# .bashrc with archey greeting and custom prompt (powerline-style)
# imports custom functions
#   needs: [archey3]
#          [powerline-fonts]
# 
# file: ~/.bashrc
# v1.6.4 / 2015.10.20
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
alias clrmem="sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias update='yaourt -Syua'
alias webcam='mplayer tv:// -tv driver=v4l2 -vo gl'
alias rainbow='for i in {0..255}; do echo -e "\e[0;38;5;${i};49;22m${i}: COLOR RAINBOW \e[7m INVERT :D \e[0m"; done'
alias win7='_PWD_SAVE=${PWD}; cd /opt/kvm/; ./start_win7.sh -spice-client spicy; cd ${_PWD_SAVE}'

alias rublogin='sudo /etc/NetworkManager/dispatcher.d/20-rublogin eth0 up'
alias vpn-bussenet='PWD_SAVE=${PWD}; cd ~/.openvpn/busse-rs/; sudo openvpn --config ./OpenVPN_busse-rs.ovpn; cd ${_PWD_SAVE}'
alias vpn-rub='PWD_SAVE=${PWD}; cd ~/.openvpn/rub/; sudo openvpn --config ./OpenVPN_RUB.ovpn; cd ${_PWD_SAVE}'

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
archey3 --config=~/.config/archey3.cfg

