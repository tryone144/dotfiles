#!/bin/sh
#
# I3WM
# Helper to open favorite applications (for keyboard shortcuts)
#   needs: [urxvt]
#
# file: scripts/defaults.sh
# v0.2 / 2015.04.30
#
# (c) 2015 Bernd Busse
#

case "${1}" in
    "terminal") # Terminal Emulator ==> urxvt
        exec /usr/bin/urxvt
        ;;
    "web") # Webbrowser ==> chromium
        exec /usr/bin/chromium
        ;;
    "files") # Dateimanager ==> nautilus
        exec /usr/bin/nautilus --new-window
        ;;
    *) # unknown
        echo "Unkown favorite: ${1}" 1>&2
        ;;
esac

