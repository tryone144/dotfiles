#!/bin/bash
#
# I3WM
# Helper to lock screen (and do the related stuff)
#   needs: [sxlock]
#
# file: ~/.config/i3/scripts/locker.sh
# v1.1 / 2015.04.30
#
# (c) 2015 Bernd Busse
#

# pause dunst notifications
killall -SIGUSR1 dunst

# mute audio
#is_muted=$(${I3_CONFIG}/scripts/volume.py get | grep -v "muted" &> /dev/null; echo ${?})
#${I3_CONFIG}/scripts/volume.py mute

# lock screen
sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-ubuntu mono-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'

############################################################

# resume dunst notifications
killall -SIGUSR2 dunst

# unmute audio
#if (( $is_muted == 0 )); then
#    ${I3_CONFIG}/scripts/volume.py unmute
#fi

