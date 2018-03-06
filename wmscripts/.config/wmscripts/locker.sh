#!/bin/bash
#
# WMScripts
# Helper to lock screen (and do the related stuff)
#   needs: [sxlock]
#
# file: ~/.config/wmscripts/locker.sh
# v1.2 / 2018.03.06
#
# (c) 2018 Bernd Busse
#

has_backlight="$( which xbacklight 2>/dev/null )"

# pause dunst notifications
killall -SIGUSR1 dunst

# dim screen
if [[ -n "${has_backlight}" ]]; then
    back_val="$(( $(xbacklight -get | cut -d '.' -f 1) + 1))"
    xbacklight -time 500 -steps 50 -set 1
fi

# mute audio
#is_muted=$(${I3_CONFIG}/scripts/volume.py get | grep -v "muted" &> /dev/null; echo ${?})
#${I3_CONFIG}/scripts/volume.py mute

# lock screen
#sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-hack-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'
sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-ubuntu mono-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'

############################################################

# resume dunst notifications
killall -SIGUSR2 dunst

# undim screen
if [[ -n "${has_backlight}" ]]; then
    xbacklight -time 500 -steps 50 -set ${back_val} &
fi

# unmute audio
#if (( $is_muted == 0 )); then
#    ${I3_CONFIG}/scripts/volume.py unmute
#fi

