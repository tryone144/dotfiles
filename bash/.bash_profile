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

# autostart tmux on tty2 to tty6
if [[ -z ${TMUX} ]] && [[ -z ${DISPLAY} ]] && [[ -n ${XDG_VTNR} ]] && [[ "${XDG_VTNR}" != 1 ]]; then
    exec tmux
fi
