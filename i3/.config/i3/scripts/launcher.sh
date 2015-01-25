#!/bin/sh
#
# I3WM
# Helper to open specific dmenu instances
#   needs: [dmenu2]
#          [gtk3-nocsd]
#          [j4-dmenu-desktop]
#
# file: ~/.config/i3/scripts/launcher.sh
# v0.3.1 / 2015.01.25
#
# (c) 2015 Bernd Busse
#
# usage: ./launcher.sh [desktop|cmd]
#

# Disable GTK3 Window borders
export GTK_CSD=0
#export LD_PRELOAD=/usr/lib/gtk3-nocsd.so

# uses .desktop entries if run with 'd' or 'desktop'
case "${1}" in
    "desktop"|"d")
        j4-dmenu-desktop --dmenu="dmenu -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 16 -p '>' -x 16 -y 28 -w 320 -fn 'Ubuntu Mono-14:normal'"
        ;;
    *)
        dmenu_run -q -i -nb '#1A1A1A' -nf '#BEBEBE' -sb '#1793D1' -sf '#FFFFFF' -dim 0.7 -l 5 -h 16 -p '>' -x 16 -y 28 -w 320 -fn 'Ubuntu Mono-14:normal'
        ;;
esac

