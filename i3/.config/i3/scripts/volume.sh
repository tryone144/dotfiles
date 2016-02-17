#!/bin/bash
#
# I3WM
# Helper to change volume of default alsa device (pulseaudio)
#   needs: [alsa] / [amixer]
#          [pactl]
#
# file: ~/.config/i3/scripts/volume.sh
# v0.1 / 2016.02.16
#
# (c) 2016 Bernd Busse
#

usage() {
    echo "usage: ${0} {{mute|unmute|toggle|get} | {lower|raise} [STEP]}" >&2
    exit 1
}

#MIXER='alsa'
#CONTROL='Master'
MIXER='pulse'
CONTROL='combined'

STEP="5"

case ${1} in
    "g"|"get")
        output="$( amixer -D ${MIXER} -- sget ${CONTROL} | tail -n 1 )"
        enabled="$( echo "${output}" | grep -wo 'on' )"
        volume="${output#*\[}"
        if [[ "${enabled}" == "on" ]]; then
            echo "${volume%%]*}"
        else
            echo "${volume%%]*} (muted)"
        fi
        ;;
    "t"|"toggle")
        [[ "$MIXER" == "pulse" ]] && pactl set-sink-mute ${CONTROL} toggle &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} toggle &> /dev/null ;;
    "m"|"mute")
        [[ "$MIXER" == "pulse" ]] && pactl set-sink-mute ${CONTROL} 1 &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} off &>/dev/null ;;
    "u"|"unmute")
        [[ "$MIXER" == "pulse" ]] && pactl set-sink-mute ${CONTROL} 0 &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} on &>/dev/null ;;
    "l"|"lower")
        [[ "$MIXER" == "pulse" ]] && pactl set-sink-volume ${CONTROL} -${2:-${STEP}}% &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} ${2:-${STEP}}%- &>/dev/null;;
    "r"|"raise")
        [[ "$MIXER" == "pulse" ]] && pactl set-sink-volume ${CONTROL} +${2:-${STEP}}% &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} ${2:-${STEP}}%+ &>/dev/null;;
    "s"|"set")
        [[ -n "${2}" ]] \
            && ( [[ "$MIXER" == "pulse" ]] && pactl set-sink-volume ${CONTROL} ${2}% &> /dev/null \
            || amixer -D 'default' -- sset ${CONTROL} ${2} &>/dev/null ) ;;
    *)
        $(usage)
        ;;
esac

