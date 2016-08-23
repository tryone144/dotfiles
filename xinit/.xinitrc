#!/bin/sh
#
# XINIT
# source relevant files before Xsession execution (namely .xprofile)
# set specific x-settings and run wm
# (not sourced by lightdm)
#
# file: ~/.xinitrc
# v1.1 / 2016.08.23
#
# (c) 2016 Bernd Busse
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
case ${session} in
    "i3")
        export DESKTOP_SESSION="i3"
        export WM_EXEC="/usr/bin/i3"
        ;;
    "herbstluft")
        export DESKTOP_SESSION="herbstluftwm"
        export WM_EXEC="/usr/bin/herbstluftwm"
        ;;
    "spectrwm")
        export DESKTOP_SESSION="spectrwm"
        export WM_EXEC="/usr/bin/spectrwm"
        ;;
    *)
        unset DESKTOP_SESSION
        export WM_EXEC="${1}"
esac

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

# run command
echo "Starting ${DESKTOP_SESSION}"
exec "${WM_EXEC}"

