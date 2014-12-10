#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export EDITOR="vim"

alias ls='ls --color=auto'
alias clr='clear; archey3 --config=~/.config/archey3.cfg'
PS1='[\u@\h \W]\$ '

archey3 --config=~/.config/archey3.cfg

