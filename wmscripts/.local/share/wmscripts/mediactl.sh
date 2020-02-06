#!/bin/bash
#
# WMScripts
# Helper to toggle play status of MPD / mpris
#   needs: [mpc] / [mpd]
#          [plasma-browser-integration]
#
# file: ~/.local/share/wmscripts/mediactl.sh
# v0.2 / 2020.02.06
#
# (c) 2020 Bernd Busse
#

__CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
__LAST_CLIENT="$( realpath "$__CONFIG_HOME/mediactl_status.txt" )"

function usage() {
    echo "usage: ${0} [mpd|mpris] {toggle|stop|prev|next}" >&2
    exit 1
}

function get_last_client() {
    cat "$__LAST_CLIENT" 2>/dev/null
}
function save_last_client() {
    echo "$1" > "$__LAST_CLIENT" 2>/dev/null
}

# call plasma-mpris dbus interface
function mpris_call() {
    qdbus "org.kde.plasma.browser_integration" "/org/mpris/MediaPlayer2" "org.mpris.MediaPlayer2.$1"
}


# check if mpd is running
function mpd_isrunning() {
    mpc 2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    return 1
}

# check if mpd is playing
function mpd_playing() {
    stats="$( mpc 2>/dev/null )"
    [[ $( echo "$stats" | wc -l ) -gt 1 ]] && echo "$stats" | head -n 2 | tail -n 1 | grep -e '^\[playing\]' >/dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    return 1
}

# check if mpd can play
function mpd_canplay() {
    if [[ $( mpc playlist | wc -l 2>/dev/null ) -gt 0 ]]; then
        return 0
    fi

    return 1
}


# check if plasma-mpris is running
function mpris_isrunning() {
    qdbus | grep -e "^\s*org\.kde\.plasma\.browser_integration" 2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    return 1
}

# check if plasma-mpris is playing
function mpris_playing() {
    reply="$( mpris_call "Player.PlaybackStatus" 2>/dev/null )"
    if [[ "$reply" == "Playing" ]]; then
        return 0
    fi

    return 1
}

# check if plasma-mpris can play
function mpris_canplay() {
    reply="$( mpris_call "Player.CanPlay" 2>/dev/null )"
    [[ "$reply" == "true" ]] && mpris_call "Player.Metadata" | grep -e '^kde:mediaSrc' 2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    return 1
}


# toggle playback
function toggle_mpd() {
    mpc toggle >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpd toggle failed" >&2
        return 1
    fi

    return 0
}
function toggle_mpris() {
    mpris_call "Player.PlayPause" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris toggle failed" >&2
        return 1
    fi

    return 0
}

# stop playback
function stop_mpd() {
    mpc stop >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpd stop failed" >&2
        return 1
    fi

    return 0
}
function stop_mpris() {
    mpris_call "Player.Stop" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris stop failed" >&2
        return 1
    fi

    return 0
}

# previous track
function prev_mpd() {
    mpc cdprev >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpd cdprev failed" >&2
        return 1
    fi

    return 0
}
function prev_mpris() {
    mpris_call "Player.Previous" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris previous failed" >&2
        return 1
    fi

    return 0
}

# next track
function next_mpd() {
    mpc next >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpd next failed" >&2
        return 1
    fi

    return 0
}
function next_mpris() {
    mpris_call "Player.Next" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris next failed" >&2
        return 1
    fi

    return 0
}


# get prioritized list of clients
function order_clients() {
    local preferred_client="$1"
    local clients=( "$preferred_client" )

    for client in "mpris" "mpd"; do
        [[ "$client" != "$preferred_client" ]] && clients=( ${clients[@]} "$client" )
    done

    echo "${clients[@]}"
}

# get best client for controling
function get_preferred_client() {
    local canplay="${1:-0}"
    local last_client="$( get_last_client )"

    if mpd_isrunning && mpris_isrunning; then
        # prefer the playing client if both are running
        for client in $( order_clients ); do
            if ${client}_playing; then
                echo "$client"
                return
            fi
        done

        # no client is playing
        if [[ "$canplay" -ne 0 ]]; then
            # check client which can play, last controlled first (prefers mpris if not set)
            for client in $( order_clients "$last_client" ); do
                if ${client}_canplay; then
                    echo "$client"
                    return
                fi
            done
        fi

        # just try the last controlled client (or mpris if not set)
        echo "${last_client:-mpris}"
    else
        # use the first running client
        for client in $( order_clients ); do
            if ${client}_isrunning; then
                echo "$client"
                return
            fi
        done

        # no client running
        return 1
    fi
}


# client to control
client=

# handle action
while true; do
    case $1 in
        "mpd"|"mpris")
            # force handling of mpd or plasma-mpris
            client="$1"
            shift && continue ;;
        "t"|"toggle")
            if [[ -z "$client" ]] && mpd_isrunning && mpris_isrunning; then
                # both are playing, so we toggle both but prefer mpris in the next step
                if mpd_playing && mpris_playing; then
                    save_last_client "mpris"
                    toggle_mpd && toggle_mpris || exit 1
                    shift && break
                fi
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client 1 )"
            save_last_client "$client"
            toggle_${client} || exit 1
            shift ;;
        "s"|"stop")
            if [[ -z "$client" ]] && mpd_isrunning && mpris_isrunning; then
                # both are playing, so we stop both but prefer mpris in the next step
                if mpd_playing && mpris_playing; then
                    save_last_client "mpris"
                    stop_mpd && stop_mpris || exit 1
                    shift && break
                fi
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client )"
            save_last_client "$client"
            stop_${client} || exit 1
            shift ;;
        "p"|"prev")
            if [[ -z "$client" ]] && mpd_isrunning && mpris_isrunning; then
                # both are playing, so we send the signal to both
                if mpd_playing && mpris_playing; then
                    prev_mpd && prev_mpris || exit 1
                    shift && break
                fi
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client 1 )"
            save_last_client "$client"
            prev_${client} || exit 1
            shift ;;
        "n"|"next")
            if [[ -z "$client" ]] && mpd_isrunning && mpris_isrunning; then
                # both are playing, so we send the signal to both
                if mpd_playing && mpris_playing; then
                    next_mpd && next_mpris || exit 1
                    shift && break
                fi
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client 1 )"
            save_last_client "$client"
            next_${client} || exit 1
            shift ;;
        *)
            $( usage ); exit 1 ;;
    esac

    break
done

if [[ $# -gt 0 ]]; then
    echo "Warning: unhandled arguments: $@" >&2
    $( usage ); exit 1
fi
