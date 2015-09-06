#!/bin/bash
# backlight.sh - handle hardware brightness keys
#
# Copyright (c) 2015 Bernd Busse

_dev="/sys/class/backlight/intel_backlight/"

brightness() {
    _cur="$(< ${_dev}/actual_brightness )"
    _max="$(< ${_dev}/max_brightness )"
    _step=$(( ${_max} / 20 ))

    case $1 in
        "up")
            _new=$(( ${_cur} + ${_step} ))
            echo $(( ${_new} < ${_max} ? ${_new} : ${_max} )) > ${_dev}/brightness ;;
        "down")
            _new=$(( ${_cur} - ${_step} ))
            echo $(( ${_new} > 1 ? ${_new} : 1 )) > ${_dev}/brightness ;;
    esac
}

group=${1%%/*}
action=${1#*/}

if [[ "${group}" == "video" ]]; then
    case "${action}" in
	"brightnessup")
            logger "ACPI event: increase brightness"
            brightness up ;;
        "brightnessdown")
            logger "ACPI event: decrease brightness"
            brightness down ;;
    esac
fi

exit 0
