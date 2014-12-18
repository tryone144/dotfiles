#!/bin/sh
#
# XINIT
# source relevant files before Xsession execution (namely .xprofile)
# set specific x-settings and run wm
#
# file: ~/.xinitrc
# v0.2 / 2014.12.18
#
# (c) 2014 Bernd Busse
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

# set primary display, if not allready set
xrandr -d ${DISPLAY} --query | grep -e 'primary' &> /dev/null
if (( ${?} == 1 )); then
    monitor="$(xrandr -d ${DISPLAY} --query | grep -e ' connected '| cut -d' ' -f1)"
    xrandr --output ${monitor} --primary
fi

# Log executable
_date="$(date +'%b %d %H:%M:%S')"
echo -e "\[${_date}\] ${@}" >> ~/.logincmd.log

# run command
exec "${@}"

