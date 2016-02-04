#!/bin/bash
#
# I3WM
# Cycle through screen modes when docked
#   needs: [xrandr]
#
# file: ~/.config/i3/scripts/beamer.sh
# v0.1 / 2016.02.04
#
# (c) 2016 Bernd Busse
#

# test for external screen
is_connected=$(xrandr | grep -E '^DP2-2\s+' | grep -E '\s+connected\s+' &> /dev/null; echo ${?})

if (( ${is_connected} == 0 )); then
    # screen is connected
    echo "screen is connected"
    internal_active=$(xrandr | grep -E '^eDP1\s+' | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?})
    external_active=$(xrandr | grep -E '^DP2-2\s+' | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?})
    if (( ${internal_active} == 0 && ${external_active} == 0 )); then
        xrandr --output eDP1 --off --output DP2-2 --preferred --right-of eDP1
    else if (( ${internal_active} != 0 && ${external_active} == 0 )); then
        xrandr --output eDP1 --preferred --output DP2-2 --off
    else
        xrandr --output eDP1 --preferred --output DP2-2 --preferred --right-of eDP1
    fi
    fi
    i3-msg -q -t command restart
fi

