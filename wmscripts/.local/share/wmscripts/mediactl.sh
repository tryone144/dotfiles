#!/bin/bash
#
# WMScripts
# Helper to toggle play status of MPD
#   needs: [mpc] / [mpd]
#
# file: ~/.config/wmscripts/mediactl.sh
# v0.1 / 2019.08.09
#
# (c) 2019 Bernd Busse
#

usage() {
    echo "usage: ${0} {toggle|stop|prev|next}" >&2
    exit 1
}

# check if mpd is running
mpc 2>&1 >/dev/null
if [[ $? -ne 0 ]]; then
    echo "could not connect to mpd" >&2
    exit 1
fi

# do action
case ${1} in
    "t"|"toggle")
        mpc toggle >/dev/null ;;
    "s"|"stop")
        mpc stop >/dev/null ;;
    "p"|"prev")
        mpc cdprev >/dev/null ;;
    "n"|"next")
        mpc next >/dev/null ;;
    *)
        $(usage) ;;
esac

