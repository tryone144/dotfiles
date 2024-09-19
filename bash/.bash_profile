#
# BASH
# .bash_profile to source .profile and .bashrc
#
# file: ~/.bash_profile
# v2.0 / 2024.07.20
#
# (c) 2024 Bernd Busse
#

# source .profile
[[ -f ~/.profile ]] && . ~/.profile

# source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc
