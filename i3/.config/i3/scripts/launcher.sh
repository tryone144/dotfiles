#!/bin/sh
#
# I3WM
# Helper to open specific dmenu instances
#   needs: [dmenu2]
#          [j4-dmenu-desktop]
#
# file: ~/.config/i3/scripts/launcher.sh
# v0.1 / 2014.12.08
#
# (c) 2014 Bernd Busse
#

# uses .desktop entries if run with 'd' or 'desktop'
case "${1}" in
    "desktop"|"d")
        j4-dmenu-desktop --dmenu="dmenu -q -i -dim 0.7 -l 5 -h 16 -p '>' -y 16 -w 320 -fn 'Ubuntu Mono-14:normal'"
        ;;
    *)
        dmenu_run -q -i -dim 0.7 -l 5 -h 16 -p '>' -y 16 -w 320 -fn 'Ubuntu Mono-14:normal'
        ;;
esac

