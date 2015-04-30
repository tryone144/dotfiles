#!/bin/bash
#
# I3WM
# Flip screen with xrandr and aling mouse movement
#   needs: [xrandr]
#          [xinput]
#
# file: ~/.config/i3/scripts/xrotate.sh
# v0.9 / 2015.04.30
#
# (c) 2015 Bernd Busse
#

# RULES
PROP_SCROLL_EMU='Evdev Wheel Emulation Axes'
PROP_SCROLL_DELTA='Synaptics Scrolling Distance'
PROP_ROT_MATRIX='Coordinate Transformation Matrix'

ROT_SCROLL_EMU=("6 7 4 5"
                "4 5 7 6"
                "7 6 5 4"
                "5 4 6 7")
ROT_SCROLL_DELTA=("-116 -116"
                  "-116 -116"
                  " 116  116"
                  " 116  116")
ROT_MATRIX=(" 1  0  0,  0  1  0, 0 0 1"
            " 0 -1  1,  1  0  0, 0 0 1"
            "-1  0  1,  0 -1  1, 0 0 1"
            " 0  1  0, -1  0  1, 0 0 1")

# do the stuff for pointer alignment
function align_pointer() {
    # go for all slave pointer devices
    for dev in $(xinput list | grep "slave\s*pointer" | sed -e 's/^.*id=//' | awk '{print $1}'); do

        # check for TrackPoint (remap scrollaxes)
        [[ "$(xinput list --name-only "${dev}")" == *TrackPoint* ]] &&
                [[ -n "$(xinput list-props "${dev}" | grep "${PROP_SCROLL_EMU}")" ]] &&
                is_trackpoint=1 || is_trackpoint=0

        # check for TouchPad (remap scrolldeltas)
        [[ "$(xinput list --name-only "${dev}")" == *TouchPad* ]] &&
                [[ -n "$(xinput list-props "${dev}" | grep "${PROP_SCROLL_DELTA}")" ]] &&
                is_touchpad=1 || is_touchpad=0

        if [[ "${1}" == "normal" ]]; then
            ind=0
        else
            ind=2
        fi

        # do matrix transformation
        xinput set-prop "${dev}" "${PROP_ROT_MATRIX}" ${ROT_MATRIX[${ind}]}

        # scroll direction remapping
        if (( ${is_trackpoint} == 1 )); then
            xinput set-prop "${dev}" "${PROP_SCROLL_EMU}" ${ROT_SCROLL_EMU[${ind}]}
        fi

        if (( ${is_touchpad} == 1 )); then
            xinput set-prop "${dev}" "${PROP_SCROLL_DELTA}" ${ROT_SCROLL_DELTA[${ind}]}
        fi
    done
}

# do stuff for i3 key remapping
function remap_keys() {
    return
}

# test for inversion
is_normal=$(xrandr | grep -E '\s+primary\s+' | grep -E '\s+inverted\s+\(' &> /dev/null; echo ${?})

if (( ${is_normal} != 0 )); then
    # is normal ==> inverted
    xrandr -o inverted
    align_pointer inverted
else
    # not normal, is inverted ==> normal
    xrandr -o normal
    align_pointer normal
fi

