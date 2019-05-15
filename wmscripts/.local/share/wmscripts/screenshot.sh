#!/bin/sh
#
# WMScripts
# Helper to take a screenshot
#   needs: [imagemagick]
#          [xdg-user-dir]
#
# file: ~/.config/wmscripts/screenshot.sh
# v1.0 / 2015.09.24
#
# (c) 2016 Bernd Busse
#

if (( $( which xdg-user-dir 2>&1 1>/dev/null; echo $? ) != 0 )); then
    dest_folder=~/
else
    dest_folder="$( xdg-user-dir "PICTURES" )/screenshots/"
    if [[ ! -d "${dest_folder}" ]]; then
        mkdir -p "${dest_folder}"
    fi
fi

if (( $( which xfce4-screenshooter 2>&1 1>/dev/null; echo $? ) != 0 )); then
    _date="$(date +%Y%m%d_%H%M%S)"
    _filename="${dest_folder}/screenshot_root_${_date}.png"
    
    # take screenshot
    import -window root "${_filename}"
else
    case ${1} in
        "r" | "region")
            xfce4-screenshooter --region --save "${dest_folder}" ;;
        *)
            xfce4-screenshooter --fullscreen --save "${dest_folder}" ;;
    esac
fi
