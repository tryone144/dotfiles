#!/bin/bash
#
# WMScripts
# Helper to toggle play status of MPD / mpris
#   needs: [mpc] / [mpd]
#          [qdbus] + ([plasma-browser-integration] || [vlc])
#
# file: ~/.local/share/wmscripts/mediactl.sh
# v0.3 / 2020.04.29
#
# (c) 2020 Bernd Busse
#

__CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
__LAST_CLIENT="$( realpath "$__CONFIG_HOME/mediactl_status.txt" )"


function usage() {
    echo "usage: ${0} [mpd|vlc|plasma] {toggle|stop|prev|next}" >&2
    exit 1
}

function get_last_client() {
    cat "$__LAST_CLIENT" 2>/dev/null
}
function save_last_client() {
    echo "$1" > "$__LAST_CLIENT" 2>/dev/null
}


MPRIS_PLASMA="org.kde.plasma.browser_integration"
MPRIS_VLC="org.mpris.MediaPlayer2.vlc"

# call mpris MediaPlaye2 dbus interface
function mpris_call() {
    local service="${1}"
    local method="${2}"
    qdbus "${service}" "/org/mpris/MediaPlayer2" "org.mpris.MediaPlayer2.${method}"
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
    local stats="$( mpc 2>/dev/null )"
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


# check if mpris MediaPlayer2 is running
function mpris_isrunning() {
    local service="${1//./\\.}"
    qdbus | grep -e "^\s*${service}" 2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    return 1
}
function plasma_isrunning() {
    mpris_isrunning "${MPRIS_PLASMA}"
}
function vlc_isrunning() {
    mpris_isrunning "${MPRIS_VLC}"
}

# check if mpris MediaPlayer2 is playing
function mpris_playing() {
    service="${1}"
    reply="$( mpris_call "${service}" "Player.PlaybackStatus" 2>/dev/null )"
    if [[ "$reply" == "Playing" ]]; then
        return 0
    fi

    return 1
}
function plasma_playing() {
    mpris_playing "${MPRIS_PLASMA}"
}
function vlc_playing() {
    mpris_playing "${MPRIS_VLC}"
}

# check if mpris MediaPlayer2 can play
function mpris_canplay() {
    local service="${1}"
    local reply="$( mpris_call "${service}" "Player.CanPlay" 2>/dev/null )"

    if [[ "${service}" == "${MPRIS_PLASMA}" ]]; then
        mpris_call "${service}" "Player.Metadata" | grep -e '^kde:mediaSrc' 2>&1 >/dev/null
        if [[ "$?" -eq 0 ]] && [[ "$reply" == "true" ]]; then
            return 0
        fi
    else
        [[ "$reply" == "true" ]] && return 0
    fi

    return 1
}
function plasma_canplay() {
    mpris_canplay "${MPRIS_PLASMA}"
}
function vlc_canplay() {
    mpris_canplay "${MPRIS_VLC}"
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
    local service="${1}"
    mpris_call "${service}" "Player.PlayPause" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris toggle failed" >&2
        return 1
    fi

    return 0
}
function toggle_plasma() {
    toggle_mpris "${MPRIS_PLASMA}"
}
function toggle_vlc() {
    toggle_mpris "${MPRIS_VLC}"
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
    local service="${1}"
    mpris_call "${service}" "Player.Stop" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris stop failed" >&2
        return 1
    fi

    return 0
}
function stop_plasma() {
    stop_mpris "${MPRIS_PLASMA}"
}
function stop_vlc() {
    stop_mpris "${MPRIS_VLC}"
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
    local service="${1}"
    mpris_call "${service}" "Player.Previous" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris previous failed" >&2
        return 1
    fi

    return 0
}
function prev_plasma() {
    prev_mpris "${MPRIS_PLASMA}"
}
function prev_vlc() {
    prev_mpris "${MPRIS_VLC}"
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
    local service="${1}"
    mpris_call "${service}" "Player.Next" >/dev/null
    if [[ $? -ne 0 ]]; then
        echo "Error: mpris next failed" >&2
        return 1
    fi

    return 0
}
function next_plasma() {
    next_mpris "${MPRIS_PLASMA}"
}
function next_vlc() {
    next_mpris "${MPRIS_VLC}"
}


# get prioritized list of clients
function order_clients() {
    local preferred_client="$1"
    local clients=( "$preferred_client" )

    for client in "vlc" "plasma" "mpd"; do
        [[ "$client" != "$preferred_client" ]] && clients=( ${clients[@]} "$client" )
    done

    echo "${clients[@]}"
}

# get all running clients
function clients_running() {
    local running=()
    for client in $( order_clients ); do
        if ${client}_isrunning; then
            running=( ${running[@]} "$client" )
        fi
    done

    echo "${running[@]}"
}

# get all playing clients
function clients_playing() {
    local playing=()
    for client in $( clients_running ); do
        if ${client}_playing; then
            playing=( ${playing[@]} "$client" )
        fi
    done

    echo "${playing[@]}"
}

# get best client for controling
function get_preferred_client() {
    local canplay="${1:-0}"
    local last_client="$( get_last_client )"

    if [[ "$( clients_running | wc -w )" -gt 1 ]]; then
        # prefer the playing client if more than one is running
        for client in $( clients_playing ); do
            echo "$client"
            return 0
        done

        # no client is playing
        if [[ "$canplay" -ne 0 ]]; then
            # check client which can play, last controlled first
            # (prefers vlc > plasma > mpd if not set)
            for client in $( order_clients "$last_client" ); do
                if ${client}_isrunning && ${client}_canplay; then
                    echo "$client"
                    return 0
                fi
            done
        fi

        # try the first running client, prefer the last controlled
        for client in $( order_clients "$last_client" ); do
            if ${client}_isrunning; then
                echo "$client"
                return 0
            fi
        done

        # no client running
        return 1
    else
        # use the first running client
        for client in $( clients_running ); do
            echo "$client"
            return 0
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
        "vlc"|"mpd"|"plasma")
            # force handling of specific client
            client="$1"
            shift && continue ;;
        "t"|"toggle")
            if [[ -z "$client" ]] && [[ "$( clients_running | wc -w )" -gt 1 ]]; then
                # More than one is running, so we toggle all that are playing but set
                # the preferred one for the next call

                if (vlc_playing && plasma_playing) || (vlc_playing && mpd_playing); then
                    # prefer vlc over all
                    save_last_client "vlc"
                    toggle_vlc || exit 1

                    if mpd_playing; then
                        toggle_mpd || exit 1
                    fi
                    if plasma_playing; then
                        toggle_plasma || exit 1
                    fi

                    shift && break
                elif plasma_playing && mpd_playing; then
                    # prefer plasma-mpris over mpd
                    save_last_client "plasma"
                    toggle_plasma && toggle_mpd || exit 1
                    shift && break
                fi

            fi

            [[ -n "$client" ]] || client="$( get_preferred_client 1 )"
            save_last_client "$client"
            toggle_${client} || exit 1
            shift ;;
        "s"|"stop")
            if [[ -z "$client" ]] && [[ "$( clients_running | wc -w )" -gt 1 ]]; then
                # More than one is running, so we stop all that are playing but set
                # the preferred one for the next call

                if (vlc_playing && plasma_playing) || (vlc_playing && mpd_playing); then
                    # prefer vlc over all
                    save_last_client "vlc"
                    stop_vlc || exit 1

                    if mpd_playing; then
                        stop_mpd || exit 1
                    fi
                    if plasma_playing; then
                        stop_plasma || exit 1
                    fi

                    shift && break
                elif plasma_playing && mpd_playing; then
                    # prefer plasma-mpris over mpd
                    save_last_client "plasma"
                    stop_plasma && stop_mpd || exit 1
                    shift && break
                fi
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client )"
            save_last_client "$client"
            stop_${client} || exit 1
            shift ;;
        "p"|"prev")
            if [[ -z "$client" ]] && [[ "$( clients_running | wc -w )" -gt 1 ]]; then
                # More than one is running, so send the signal to all that are playing

                if vlc_playing; then
                    prev_vlc || exit 1
                fi
                if plasma_playing; then
                    prev_plasma || exit 1
                fi
                if mpd_playing; then
                    prev_mpd || exit 1
                fi

                shift && break
            fi

            [[ -n "$client" ]] || client="$( get_preferred_client 1 )"
            save_last_client "$client"
            prev_${client} || exit 1
            shift ;;
        "n"|"next")
            if [[ -z "$client" ]] && [[ "$( clients_running | wc -w )" -gt 1 ]]; then
                # More than one is running, so send the signal to all that are playing

                if vlc_playing; then
                    next_vlc || exit 1
                fi
                if plasma_playing; then
                    next_plasma || exit 1
                fi
                if mpd_playing; then
                    next_mpd || exit 1
                fi

                shift && break
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
