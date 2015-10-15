#!/bin/bash
#
# I3WM
# wrapper for lemonbar statusline
#   needs: [lemonbar-xft]
#          [j4status]
#          [arrowbar]
#          [powerline-fonts]
#          [ionicons-font]
#
# file: ~/.config/i3/lemonbar.sh
# v0.3 / 2015.10.15
#

panel_fifo="/tmp/i3_lemonbar_${USER}"

font_normal="Ubuntu Mono derivative Powerline-11"
font_icon="Ionicons-12"

if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
    echo "$(basename $0)"
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
arrowbar.py --workspace < "${panel_fifo}" \
    | lemonbar -f "${font_normal}" -f "${font_icon}" -B "#00000000" -F "#FFFFFFFF" -g "x14" | \
    {
        # handle mouse actions
        while read -r line; do
            section="$( echo "${line}" | cut -d '|' -f 1 )"
            action="$( echo "${line}" | cut -d '|' -f 2 )"
            case ${section} in
                "i3")
                    case ${action} in
                        "change-ws")
                            ws="$( echo "${line}" | cut -d '|' -f 3 )"
                            i3-msg workspace $ws > /dev/null ;;
                    esac ;;
                "volume")
                    case ${action} in
                        "toggle")
                            ${I3_CONFIG}/scripts/volume.py toggle ;;
                        "raise")
                            ${I3_CONFIG}/scripts/volume.py raise 5 ;;
                        "lower")
                            ${I3_CONFIG}/scripts/volume.py lower 5 ;;
                    esac ;;
                "date")
                    ;;
            esac
        done
    } &

wait
