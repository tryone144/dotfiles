#!/bin/bash
#
# WMScripts
# Helper to change volume of default alsa device (pulseaudio)
#   needs: [alsa] / [amixer]
#          [pactl]
#
# file: ~/.config/wmscripts/volume.sh
# v0.1 / 2016.02.16
#
# (c) 2016 Bernd Busse
#

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

usage() {
    echo "usage: ${0} {{mute|unmute|toggle|get} | {lower|raise} [STEP] | set VOLUME}" >&2
    exit 1
}

SINK="alsa_output.pci-0000_0e_00.4.analog-surround-51"
STEP="5"

case ${1} in
    "g"|"get")
        if [[ -n "${SINK}" ]]; then
            "${SCRIPT_DIR}/volume.py" --sink "${SINK}" get 2> /dev/null
        fi
        if [[ $? -ne 0 ]] || [[ -z "${SINK}" ]]; then
            output="$( amixer -D 'default' -- sget 'Master' | tail -n 1 )"
            enabled="$( echo "${output}" | grep -wo "on" )"
            volume="${output#*\[}"
            if [[ "${enabled}" == "on" ]]; then
                echo "${volume%%]*}"
            else
                echo "${volume%%]*} (muted)"
            fi
        fi ;;
    "t"|"toggle")
        [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" toggle &> /dev/null \
            || amixer -D 'default' -- sset 'Master' toggle &> /dev/null ;;
    "m"|"mute")
        [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" mute &> /dev/null \
            || amixer -D 'default' -- sset 'Master' off &>/dev/null ;;
    "u"|"unmute")
        [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" unmute &> /dev/null \
            || amixer -D 'default' -- sset 'Master' on &>/dev/null ;;
    "l"|"lower")
        [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" lower "${2:-${STEP}}%" &> /dev/null \
            || amixer -D 'default' -- sset 'Master' ${2:-${STEP}}%- &>/dev/null ;;
    "r"|"raise")
        [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" raise "${2:-${STEP}}%" &> /dev/null \
            || amixer -D 'default' -- sset 'Master' ${2:-${STEP}}%+ &>/dev/null ;;
    "s"|"set")
        [[ -n "${2}" ]] \
            && ( [[ -n "${SINK}" ]] && "${SCRIPT_DIR}/volume.py" --sink "${SINK}" set "${2}" &> /dev/null \
            || amixer -D 'default' -- sset 'Master' "${2}%" &>/dev/null ) ;;
    *)
        $(usage)
        ;;
esac

