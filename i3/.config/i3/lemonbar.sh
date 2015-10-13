#!/bin/bash
#
# I3WM
# wrapper for lemonbar statusline
#   needs: [j4status]
#          [arrowbar]
#
# file: ~/.config/i3/lemonbar.sh
# v0.2 / 2015.10.13
#

panel_fifo="/tmp/i3_lemonbar_${USER}"

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    echo "The status bar is already running." >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# generate status FIFO
[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

# start status provider
export PATH="${PATH}:${I3_CONFIG}/scripts"
j4status > "${panel_fifo}" &

# start lemonbar
arrowbar.py < "${panel_fifo}" \
    | lemonbar -f "-xos4-terminesspowerline-medium-r-normal--12-120-72-72-c-60-iso10646-1" -B "#00000000" -F "#FFFFFFFF" &

wait
