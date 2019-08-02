#
# BASH
# .bash_profile to source .bashrc and start my graphical session
#
# file: ~/.bash_profile
# v1.0 / 2019.04.03
#
# (c) 2019 Bernd Busse
#

# source .profile
[[ -f ~/.profile ]] && . ~/.profile

# source .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# X autostart on vt1 [i3wm]
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 1 ]]; then
    export X_SESSION=i3
    exec startx
fi

# X autostart on vt2 [awesomewm]
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 2 ]]; then
    export X_SESSION=awesome
    exec startx
fi

# X autostart on vt3 [lxqt]
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 3 ]]; then
    export X_SESSION=lxqt
    exec startx
fi

# autostart tmux on tty4
if [[ -z ${TMUX} ]] && [[ -z ${DISPLAY} ]] && [[ -n ${XDG_VTNR} ]] && (( ${XDG_VTNR} == 4 )); then
    exec tmux
fi
