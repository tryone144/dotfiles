#!/bin/sh
#
# I3WM
# Helper to change volume either with pulseaudio or alsa
#   needs: [pactl]
#          [alsa]
#
# file: ~/.config/i3/scripts/volume.sh
# v0.1 / 2014.12.17
#
# (c) 2014 Bernd Busse
#
# usage: ./volume.sh [mute,lower,raise] {PERCENT}
#

# toggle mute
function mute_toggle() {
    if [ ${use_pactl} == 1 ]; then
        pactl -- set-sink-mute ${pa_sink} toggle
    else
        amixer -D default -- sset Master playback toggle
    fi
}

# lower volume by given percent
function lower_volume() {
    if [ ${use_pactl} == 1 ]; then
        pactl -- set-sink-volume ${pa_sink} -${1}%
    else
        amixer -D default -- sset Master playback ${1}%-
    fi
}

# raise volume by given percent
function raise_volume() {
    if [ ${use_pactl} == 1 ]; then
        pactl -- set-sink-volume ${pa_sink} +${1}%
    else
        amixer -D default -- sset Master playback ${1}%+
    fi
}

# test for 'pactl'
if [ -x "$(which pactl)" ]; then
    use_pactl=1
    pa_sink="$(pactl list sinks short | grep -i running | cut -f1)"
else
    use_pactl=0
fi

# get arguments
case "${1}" in
    "mute"|"m") # toggle mute
        mute_toggle
        ;;
    "lower"|"l") # lower volume
        if [ -n "${2}" ]; then
            lower_volume ${2}
        else
            lower_volume 10
        fi
        ;;
    "raise"|"r") # raise volume
        if [ -n "${2}" ]; then
            raise_volume ${2}
        else
            raise_volume 10
        fi
        ;;
    *)
        echo "usage: ${0} [mute,lower,raise]"
        ;;
esac

