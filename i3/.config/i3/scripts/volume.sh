#!/bin/sh
#
# I3WM
# Helper to change volume either with pulseaudio or alsa
#   needs: [pactl]
#          [alsa]
#
# file: ~/.config/i3/scripts/volume.sh
# v0.2 / 2014.12.19
#
# (c) 2014 Bernd Busse
#
# usage: ./volume.sh [mute,lower,raise,get] {PERCENT}
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

# get volume level in percent
function get_volume() {
    if [ ${use_pactl} == 1 ]; then
        level="$(pactl list sinks | sed -nr -e 's_^\tVolume:.*\w+:\s*[0-9]+\s*/\s*([0-9]+%)\s*/.*_\1_p' | sed -nr -e "$((${pa_sink}+1))p")"
        mute=$(pactl list sinks | grep -Pe '^\tMute:' | sed -nr -e "$((${pa_sink}+1))p" | grep -Pe '^\tMute:\s+no$' > /dev/null; echo ${?})
    else
        level="$(amixer -D default -- sget Master playback | sed -nr -e 's/^.*\[([0-9]+%)\].*$/\1/p' | sed -nr -e '1p')"
        mute=$(amixer -D default -- sget Master playback | grep -Pe ' \[on\]$' > /dev/null; echo ${?})
    fi
    echo -n "${level}"
    if [ ${mute} == 1 ]; then
        echo -n " (mute)"
    fi
    echo ""
}

# test for 'pactl'
if [ -x "$(which pactl)" ]; then
    use_pactl=1
    pa_sink="$(pactl list sinks short | grep -i "running" | cut -f1)"
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
    "get"|"g") # get volume level
        get_volume
        ;;
    *)
        echo "usage: ${0} [mute,lower,raise,get]"
        ;;
esac

