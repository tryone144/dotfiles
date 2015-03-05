#!/bin/bash
#
# I3WM
# Helper to do screen manipulation with xrandr
#   needs: [xrandr]
#
# file: ~/.config/i3/scripts/xrotate.sh
# v0.5 / 2015.03.04
#
# (c) 2015 Bernd Busse
#

screen_geometry="$(xrandr -d "${DISPLAY}" --query | grep ' primary ' | sed -n '1p' | grep -o -e '[0-9]\+x[0-9]\+')"
screen_width="$(echo "${screen_geometry}" | cut -d'x' -f1)"
screen_height="$(echo "${screen_geometry}" | cut -d'x' -f2)"

cmds="$(cat <<EOF
> normal
> inverted
> left
> right
EOF
)"

lines_num=$(echo "${cmds}" | wc -l)
lines_height=26
height=$((${lines_num} * ${lines_height}))
width=640

value="$(echo "${cmds}" | /usr/bin/dmenu -f -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.5 \
    -l ${lines_num} -h ${lines_height} -x $(((${screen_width} - ${width}) / 2)) -y $(((${screen_height} - ${height}) / 2)) -w ${width} -fn 'Ubuntu Mono-16:normal')"

# check choosen value
case "${value:2}" in
    "normal") # normal orientation
        xrandr -o normal
        ;;
    "inverted") # upside-down orientation
        xrandr -o inverted
        ;;
    "left") # turned left
        xrandr -o left
        ;;
    "right") # turned right
        xrandr -o right
        ;;
    *) # aborted, do nothing
        ;;
esac

