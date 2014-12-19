#!/bin/sh
#
# I3WM
# Helper to open specific dmenu instances
#   needs: [dmenu2]
#          [j4-dmenu-desktop]
#
# file: ~/.config/i3/scripts/launcher.sh
# v0.2 / 2014.12.18
#
# (c) 2014 Bernd Busse
#

# uses .desktop entries if run with 'd' or 'desktop'
case "${1}" in
    "desktop"|"d")
        j4-dmenu-desktop --dmenu="dmenu -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 18 -p '>' -x 16 -y 28 -w 320 -fn 'Ubuntu Mono-16:normal'"
        ;;
    *)
        dmenu_run -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 18 -p '>' -x 16 -y 28 -w 320 -fn 'Ubuntu Mono-16:normal'
        ;;
esac

