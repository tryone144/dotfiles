#!/bin/bash
#
# WMScripts
# Helper to lock screen (and do the related stuff)
#   needs: [sxlock]
#
# file: ~/.config/wmscripts/locker.sh
# v1.2 / 2018.03.06
#
# (c) 2018 Bernd Busse
#

has_backlight="$( which xbacklight 2>/dev/null )"
dpy="${DISPLAY/:/_}"

service="com.github.chjj.compton.${dpy}"
interface='com.github.chjj.compton'
object='/com/github/chjj/compton'

#opt_fadedelta="$( dbus-send --print-reply=literal --dest="${service}" "${object}" \
#    "${interface}.opts_get" "string:fade_delta" | awk '{print $2;}' )"
opt_openclose="$( dbus-send --print-reply=literal --dest="${service}" "${object}" \
    "${interface}.opts_get" "string:no_fading_openclose" | awk '{print $2;}' )"
opt_unredir="$( dbus-send --print-reply=literal --dest="${service}" "${object}" \
    "${interface}.opts_get" "string:unredir_if_possible" | awk '{print $2;}' )"

# Enable compton's fade-in effect so that the lockscreen gets a nice fade-in effect.
# If disable unredir_if_possible is enabled in compton's config, we may need to
# disable that to avoid flickering. YMMV.
#dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
#    "string:fade_delta" "int32:10"
dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
    "string:no_fading_openclose" "boolean:false"
dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
    "string:unredir_if_possible" "boolean:false"

# pause dunst notifications
pkill -u ${USER} -USR1 dunst

# dim screen
if [[ -n "${has_backlight}" ]]; then
    back_val="$(( $(xbacklight -get | cut -d '.' -f 1) + 1))"
    xbacklight -time 500 -steps 50 -set 1 &
fi

sleep 0.2

# mute audio
#is_muted=$(${I3_CONFIG}/scripts/volume.py get | grep -v "muted" &> /dev/null; echo ${?})
#${I3_CONFIG}/scripts/volume.py mute

# lock screen
#sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-hack-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'
sxlock -p 'password1234' -u "${USER}@${HOSTNAME}" -f '-*-ubuntu mono-medium-r-normal-*-24-90-*-*-*-*-iso10646-*'

############################################################

# resume dunst notifications
pkill -u ${USER} -USR2 dunst

# undim screen
if [[ -n "${has_backlight}" ]]; then
    xbacklight -time 500 -steps 50 -set ${back_val} &
fi

sleep 0.2

# Revert compton's config changes.
#dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
#    "string:fade_delta" "int32:${opt_fadedelta}"
dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
    "string:no_fading_openclose" "boolean:${opt_openclose}"
dbus-send --type=method_call --dest="${service}" "${object}" "${interface}.opts_set" \
    "string:unredir_if_possible" "boolean:${opt_unredir}"

# unmute audio
#if (( $is_muted == 0 )); then
#    ${I3_CONFIG}/scripts/volume.py unmute
#fi

