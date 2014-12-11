#!/bin/sh
#
# I3WM
# Helper to take a screenshot
#   needs: [imagemagick]
#
# file: ~/.config/i3/scripts/screenshot.sh
# v0.1 / 2014.12.08
#
# (c) 2014 Bernd Busse
#

_date=$(date +%Y%m%d_%H%M%S)
_filename=~/screenshot_root_${_date}.png

# take screenshot
import -window root ${_filename}

