#!/bin/bash
#
# WMScripts
# Cycle through screen modes when docked
#   needs: [xrandr]
#
# file: ~/.config/wmscripts/beamer.sh
# v1.1 / 2016.08.23
#
# (c) 2016 Bernd Busse
#

INTERNAL='eDP1'
EXTERNALS='DP2-1 DP2-2 DP2-3 HDMI1 HDMI2 DP1 DP2'

# backend commands
function enable_internal() {
    xrandr --output "${INTERNAL}" --preferred
}
function enable_external() {
    xrandr --output "${1}" --preferred --right-of "${INTERNAL}"
}
function disable_internal() {
    xrandr --output "${INTERNAL}" --off
}
function disable_external_all() {
    for ext in ${EXTERNALS}; do
        xrandr --output "${ext}" --off
    done
}
function set_primary() {
    xrandr --output "${1}" --primary
}

# helper commands
function internal_only() {
    echo "Enable internal / disable external"
    enable_internal
    set_primary "${INTERNAL}"
    disable_external_all
}
function external_only() {
    echo "Disable internal / enable external '${1}'"
    enable_external "${1}"
    set_primary "${1}"
    disable_internal
}
function both() {
    echo "Enable internal / enable external '${connected_screen}'"
    enable_internal
    set_primary "${INTERNAL}"
    enable_external "${1}"
}

function wm_reload() {
    killall compton
    if [[ "${DESKTOP_SESSION}" == "i3" ]]; then
        sleep 0.5; i3-msg -q -t command restart
    fi
}

# check for 'internal' argument
if [[ "${1}" == 'internal' ]]; then
    internal_only
    wm_reload
    exit
fi

# test for external screen
is_connected=0
connected_screen=""
for screen in ${EXTERNALS}; do
    connected=$( xrandr | grep -E "^${screen}\s+" | grep -E '\s+connected\s+' &> /dev/null; echo ${?} )
    if (( ${connected}  == 0 )); then
        echo "Found connected monitor: ${screen}"
        is_connected=1
        connected_screen="${screen}"
        break
    fi
done

# external screen is connected?
if (( ${is_connected} )); then
    # check for 'external' and 'both' argument
    if [[ "${1}" == 'external' ]]; then
        external_only "${connected_screen}"
        wm_reload
        exit
    elif [[ "${1}" == 'both' ]]; then
        both "${connected_screen}"
        wm_reload
        exit
    fi

    # check active screens
    internal_active=$( xrandr | grep -E "^${INTERNAL}\s+" | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?} )
    external_active=$( xrandr | grep -E "^${connected_screen}\s+" | grep -E '\s+connected\s+.*[0-9]+.*\(' &> /dev/null; echo ${?} )

    # toggle screens (both -> external -> internal)
    if (( ${internal_active} == 0 && ${external_active} == 0 )); then
        # both active
        external_only "${connected_screen}"
    elif (( ${internal_active} != 0 && ${external_active} == 0 )); then
        # external only
        internal_only
    else
        # internal only
        both "${connected_screen}"
    fi

    wm_reload
    exit
fi
