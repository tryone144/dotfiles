#!/bin/sh
#
# I3WM
# Helper to take a screenshot
#   needs: [imagemagick]
#          [xdg-user-dir]
#
# file: ~/.config/i3/scripts/screenshot.sh
# v1.0 / 2015.09.24
#
# (c) 2014 Bernd Busse
#

if (( $( which xdg-user-dir 2>&1 /dev/null; echo $? ) != 0 )); then
    _folder=~/
else
    _folder="$( xdg-user-dir "PICTURES" )/screenshots/"
    if [[ ! -d "${_folder}" ]]; then
        mkdir -p "${_folder}"
    fi
fi

_date="$(date +%Y%m%d_%H%M%S)"
_filename="${_folder}/screenshot_root_${_date}.png"

# take screenshot
import -window root "${_filename}"

