#!/bin/sh
#
# XINIT
# source relevant files before Xsession execution (namely .xprofile)
# set specific x-settings and run wm
# (not sourced by lightdm)
#
# file: ~/.xinitrc
# v1.0 / 2015.01.03
#
# (c) 2015 Bernd Busse
#

# Executed by startx (run your window manager from here)
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Make sure this is before the 'exec' command or it won't be sourced.
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

# run command
exec "${@}"

