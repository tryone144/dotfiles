#!/bin/bash
#
# I3WM
# Helper to lock screen (and do the related stuff)
#   needs: [sxlock]
#
# file: ~/.config/i3/scripts/screenlock.sh
# v1.0 / 2014.12.24
#
# (c) 2014 Bernd Busse
#

killall -SIGUSR1 dunst # pause dunst

sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-ubuntu mono-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'

killall -SIGUSR2 dunst # resume dunst

