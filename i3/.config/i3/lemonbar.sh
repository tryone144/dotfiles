#!/usr/bin/env bash
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
# v0.4.3 / 2019.08.06
#

panel_fifo="/dev/shm/i3_lemonbar_${USER}"
config="${I3_CONFIG}/panel/j4status-${HOSTNAME}.conf"

#font_normal="Source Code Pro for Powerline-9"
font_normal="Source Code Pro-9"
font_icon="Ionicons-12"

if [[ $(pgrep -cx $(basename $0)) -gt 1 ]] ; then
    echo "The status bar is already running." >&2
    exit 1
fi

if [[ ! -e "${config}" ]]; then
    echo "Cannot find config file: ${config}" >&2
    exit 1
fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# generate status FIFO
[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"

export PATH="${PATH}:${I3_CONFIG}/panel"

# start lemonbar
arrowbar.py --workspace --title < "${panel_fifo}" 2>> /tmp/arrowbar.log \
    | lemonbar -f "${font_normal}" -f "${font_icon}" -B "#00000000" -F "#FFFFFFFF" -g "x14" -a 40 | \
    {
        # handle mouse actions
        while read -r line; do
            section="$( echo "${line}" | cut -d '|' -f 1 )"
            action="$( echo "${line}" | cut -d '|' -f 2 )"
            instance="$( echo "${line}" | cut -d '|' -f 3 )"
            case ${section} in
                "i3")
                    case ${action} in
                        "change-ws")
                            i3-msg workspace $instance > /dev/null ;;
                    esac ;;
                "volume")
                    case ${action} in
                        "toggle")
                            if [[ -n "${instance}" ]]; then
                                volume.py --sink "${instance}" toggle
                            else
                                volume.py toggle
                            fi ;;
                        "raise")
                            if [[ -n "${instance}" ]]; then
                                volume.py --sink "${instance}" raise 5
                            else
                                volume.py raise 5
                            fi ;;
                        "lower")
                            if [[ -n "${instance}" ]]; then
                                volume.py --sink "${instance}" lower 5
                            else
                                volume.py lower 5
                            fi ;;
                    esac ;;
                "date")
                    ;;
            esac
        done
    } && kill 0 &

# start status provider
j4status -c "${config}" > "${panel_fifo}"

wait
