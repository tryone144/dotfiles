#!/bin/bash
#
# I3WM
# Helper to change volume of default alsa device (pulseaudio)
#   needs: [alsa] / [amixer]
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

#MIXER='default'
MIXER='pulse'
CONTROL='Master'

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
        amixer -D ${MIXER} -- sset ${CONTROL} toggle &>/dev/null ;;
    "m"|"mute")
        amixer -D ${MIXER} -- sset ${CONTROL} off &>/dev/null ;;
    "u"|"unmute")
        amixer -D ${MIXER} -- sset ${CONTROL} on &>/dev/null ;;
    "l"|"lower")
        amixer -D ${MIXER} -- sset ${CONTROL} ${2:-${STEP}}%- &>/dev/null;;
    "r"|"raise")
        amixer -D ${MIXER} -- sset ${CONTROL} ${2:-${STEP}}%+ &>/dev/null;;
    "s"|"set")
        [[ -n "${2}" ]] && amixer -D ${MIXER} -- sset ${CONTROL} ${2} &>/dev/null ;;
    *)
        $(usage)
        ;;
esac

