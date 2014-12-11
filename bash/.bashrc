#
# BASH
# .bashrc with archey greeting and default prompt
#   needs: [archey3]
# 
# file: ~/.bashrc
# v0.1 / 2014.12.10
#
# (c) 2014 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export EDITOR="vim"

# Aliase
alias ls='ls --color=auto'
alias clr='clear; archey3 --config=~/.config/archey3.cfg'

# Prompts
PS1='[\u@\h \W]\$ '

# Archey3 greeting
archey3 --config=~/.config/archey3.cfg

