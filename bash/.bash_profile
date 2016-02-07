#
# BASH
# .bash_profile to source .bashrc
# 
# file: ~/.bashrc
# v0.4 / 2016.01.08
#
# (c) 2015 Bernd Busse
#

# source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# X autostart on vt1
[[ -z ${DISPLAY} ]] && (( ${XDG_VTNR} == 1 )) && exec startx || return 0

