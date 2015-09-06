#!/bin/bash
# volume.sh - handle hardware volume keys
#
# Copyright (c) 2015 Bernd Busse

_dsp=":0"
_user="bernd"

volume() {
    if (( $( pgrep 'pulseaudio' 2>&1 > /dev/null; echo $? ) == 0 )); then
        export DISPLAY="${_dsp}"
        export XAUTHORITY="/home/${_user}/.Xauthority"
        if (( $( pactl info 2>&1 > /dev/null; echo $? ) == 0 )); then
            for index in $( pactl list sinks short | awk '{ print $1}' ); do
                case $1 in
                    "up")
                        pactl set-sink-volume ${index} +5% ;;
                    "down")
                        pactl set-sink-volume ${index} -5% ;;
                    "mute")
                        pactl set-sink-mute ${index} toggle ;;
                esac
            done
            for index in $( pactl list sources short | grep -v 'monitor' | awk '{ print $1 }' ); do
                case $1 in
                    "mic")
                        pactl set-source-mute ${index} toggle ;;
                esac
            done
        fi
    else
        case $1 in
            "up")
                amixer -- set Master 5%+ ;;
            "down")
                amixer -- set Master 5%- ;;
            "mute")
                amixer -- set Master toggle ;;
            "mic")
                amixer -- set Caputure toggle ;;
        esac
    fi
}

group=${1%%/*}
action=${1#*/}

if [[ "${group}" == "button" ]]; then
    case "${action}" in
	"volumeup")
            logger "ACPI event: increase volume"
            volume up ;;
        "volumedown")
            logger "ACPI event: decrease volume"
            volume down ;;
        "mute")
            logger "ACPI event: toggle mute"
            volume mute ;;
        "f20")
            logger "ACPI event: toggle mic"
            volume mic ;;
    esac
fi

exit 0
