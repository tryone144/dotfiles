#
# BASH
# .bash_profile to source .bashrc and start my graphical session
#
# file: ~/.bashrc
# v0.5 / 2018.02.15
#
# (c) 2018 Bernd Busse
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

# X autostart on vt2 [xmonad]
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 2 ]]; then
    export X_SESSION=xmonad
    exec startx
fi

# X autostart on vt3 [awesomewm]
if [[ -z ${DISPLAY} ]] && [[ "${XDG_VTNR}" == 3 ]]; then
    export X_SESSION=awesome
    exec startx
fi

# autostart tmux on tty5 and tty6
if [[ -z ${TMUX} ]] && [[ -z ${DISPLAY} ]] && [[ -n ${XDG_VTNR} ]] && (( ${XDG_VTNR} == 5 || ${XDG_VTNR} == 6 )); then
    exec tmux
fi
