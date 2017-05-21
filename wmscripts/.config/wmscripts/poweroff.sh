#!/bin/bash
#
# WMScripts
# Helper to show a shutdown selection with dmenu
#   needs: [dmenu2]
#
# file: ~/.config/wmscripts/poweroff.sh
# v1.3 / 2016.08.23
#
# (c) 2016 Bernd Busse
#

screen_geometry="$(xrandr -d "${DISPLAY}" --query | grep ' primary ' | sed -n '1p' | grep -o -e '[0-9]\+x[0-9]\+')"
screen_width="$(echo "${screen_geometry}" | cut -d'x' -f1)"
screen_height="$(echo "${screen_geometry}" | cut -d'x' -f2)"

cmds="$(cat <<EOF
> poweroff
> reboot
> suspend
> hibernate
> lock screen
EOF
)"

i3_cmds="$(cat <<EOF

> reload i3
> quit i3
EOF
)"

herbstluft_cmds="$(cat <<EOF

> quit herbstluft
EOF
)"

franken_cmds="$(cat <<EOF

> quit frankenwm
EOF
)"

case "${DESKTOP_SESSION}" in
    "i3")
        cmds="${cmds}${i3_cmds}" ;;
    "herbstluftwm")
        cmds="${cmds}${herbstluft_cmds}" ;;
    "frankenwm")
        cmds="${cmds}${franken_cmds}" ;;
esac

lines_num=$(echo "${cmds}" | wc -l)
lines_height=26
height=$((${lines_num} * ${lines_height}))
width=640

value="$(echo "${cmds}" | /usr/bin/dmenu -f -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.5 \
    -l ${lines_num} -h ${lines_height} -x $(((${screen_width} - ${width}) / 2)) -y $(((${screen_height} - ${height}) / 2)) -w ${width} -fn 'Source Code Pro-14:bold')"

# check choosen value
case "${value:2}" in
    "poweroff") # shutdown computer
        systemctl poweroff
        ;;
    "reboot") # reboot computer
        systemctl reboot
        ;;
    "suspend") # suspend computer
        ${WM_SCRIPTS}/locker.sh &
        sleep 2 && systemctl suspend
        ;;
    "hibernate") # hibernate computer
        ${WM_SCRIPTS}/locker.sh &
        sleep 2 && systemctl hibernate
        ;;
    "lock screen") # lock screen
        ${WM_SCRIPTS}/locker.sh &
        ;;
    "reload i3") # reload i3
        i3-msg reload
        ;;
    "quit i3") # quit i3
        i3-msg exit
        ;;
    "quit herbstluft") # quit herbstluftwm
        ;;
    "quit frankenwm") # quit frankenwm
        ;;
    *) # aborted, do nothing
        ;;
esac

