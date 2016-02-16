#
# BASH
# .bash_profile to source .bashrc
# 
# file: ~/.bashrc
# v0.4 / 2016.02.11
#
# (c) 2015 Bernd Busse
#

# source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# X autostart on vt1
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 1 ]]; then
    exec startx
fi

