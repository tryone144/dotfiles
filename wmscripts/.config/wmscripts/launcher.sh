#!/bin/sh
#
# WMScripts
# Helper to open specific dmenu instances
#   needs: [dmenu2]
#          [j4-dmenu-desktop]
#
# file: ~/.config/wmscripts/launcher.sh
# v0.3.3 / 2018.03.06
#
# (c) 2018 Bernd Busse
#
# usage: ./launcher.sh [desktop|cmd]
#

# uses .desktop entries if run with 'd' or 'desktop'
case "${1}" in
    "desktop"|"d")
        exec j4-dmenu-desktop --dmenu="dmenu -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 16 -p '>' -x 16 -y 28 -w 320 -fn 'Hack-12:bold'"
        ;;
    *)
        exec dmenu_run -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 16 -p '>' -x 16 -y 28 -w 320 -fn 'Hack-12:bold'
        ;;
esac

