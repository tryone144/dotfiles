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

# commands        
EXTERNAL_ONLY="xrandr --output eDP1 --off --output DP2-2 --preferred --right-of eDP1 --primary"
INTERNAL_ONLY="xrandr --output eDP1 --preferred --primary --output DP2-2 --off"
BOTH="xrandr --output eDP1 --preferred --primary --output DP2-2 --preferred --right-of eDP1"

# test for external screen
is_connected=$(xrandr | grep -E '^DP2-2\s+' | grep -E '\s+connected\s+' &> /dev/null; echo ${?})

if (( ${is_connected} == 0 )); then
    # screen is connected
    internal_active=$(xrandr | grep -E '^eDP1\s+' | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?})
    external_active=$(xrandr | grep -E '^DP2-2\s+' | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?})
    if [[ "${1}" == "external" ]]; then
        ${EXTERNAL_ONLY}
    elif [[ "${1}" == "internal" ]]; then
        ${INTERNAL_ONLY}
    else
        if (( ${internal_active} == 0 && ${external_active} == 0 )); then
            ${EXTERNAL_ONLY}
        else if (( ${internal_active} != 0 && ${external_active} == 0 )) || [[ "${1}" == "internal" ]]; then
            ${INTERNAL_ONLY}
        else
            ${BOTH}
        fi
        fi
    fi
    i3-msg -q -t command restart
fi

