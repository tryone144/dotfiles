#!/bin/sh
#
# XINIT
# source relevant files before Xsession execution (namely .xprofile)
# set specific x-settings and run wm
# (not sourced by lightdm)
#
# file: ~/.xinitrc
# v1.2 / 2018.02.14
#
# (c) 2018 Bernd Busse
#

# Executed by startx (run your window manager from here)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# check windowmanager
session=${1:-i3}
exe="$( which ${session} )"
case ${session} in
    "awesomewm")
        export DESKTOP_SESSION="awesomewm"
        export WM_EXEC="${exe:-/usr/bin/awesomewm}"
        ;;
    "herbstluft")
        export DESKTOP_SESSION="herbstluftwm"
        export WM_EXEC="${exe:-/usr/bin/herbstluftwm}"
        ;;
    "i3")
        export DESKTOP_SESSION="i3"
        export WM_EXEC="${exe:-/usr/bin/i3}"
        ;;
    "spectrwm")
        export DESKTOP_SESSION="spectrwm"
        export WM_EXEC="${exe:-/usr/bin/spectrwm}"
        ;;
    *)
        unset DESKTOP_SESSION
        export WM_EXEC="${exe:-${1}}"
esac

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

# run command
echo "Starting ${DESKTOP_SESSION}: ${WM_EXEC}"
exec "${WM_EXEC}"

