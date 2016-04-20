#
# BASH
# .aliases little function tools for my bash
# 
# file: ~/.bash_aliases
# v1.3 / 2016.04.20
#
# (c) 2016 Bernd Busse
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Aliase
alias ls='ls --color=auto -h'
alias grep='grep --color=auto'
alias archey="archey3 --config=~/.config/archey3.cfg"
alias clr='clear; archey3 --config=~/.config/archey3.cfg'
alias clrmem="sudo bash -c 'echo 3 > /proc/sys/vm/drop_caches'"
alias cpu-perf='sudo cpupower frequency-set -g performance'
alias cpu-save='sudo cpupower frequency-set -g ondemand'

alias update='yaourt -Syua'
alias copy='xclip -selection clipboard'
alias webcam='mplayer tv:// -tv driver=v4l2 -vo gl'
alias rainbow='for i in {0..255}; do echo -e "\e[0;38;5;${i};49;22m${i}: COLOR RAINBOW \e[7m INVERT :D \e[0m"; done'
alias win7='_PWD=${PWD}; cd /opt/kvm/; ./start_win7.sh -spice-client spicy; cd ${_PWD}'

alias rublogin='sudo /etc/NetworkManager/dispatcher.d/20-rublogin eth0 up'
alias vpn-bussenet='_PWD=${PWD}; cd ~/.openvpn/busse-rs/; sudo openvpn --config ./denknix-TO-IPFire.ovpn; cd ${_PWD}'
alias vpn-rub='_PWD=${PWD}; cd ~/.openvpn/rub/; sudo openvpn --config ./OpenVPN_RUB.ovpn; cd ${_PWD}'
alias vpn-badbank='_PWD=${PWD}; cd ~/.openvpn/badbank/; sudo openvpn --config ./badbank.ovpn; cd ${_PWD}'

alias screencast='ffmpeg -f x11grab -s $( xwininfo -display :0 -root | grep -e "geometry" | sed -re "s/.*\s([0-9]+x[0-9]+)\+.*/\1/g" ) -i :0.0 -r 15 -vcodec mjpeg -q:v 5 -f mjpeg'
alias toggle="~/.config/i3/scripts/beamer.sh"
alias beamer-on="~/.config/i3/scripts/beamer.sh external"
alias beamer-off="~/.config/i3/scripts/beamer.sh internal"

alias dpms_off='xset -dpms; xset s off'
alias dpms_on='xset +dpms; xset s 600'
alias snd_speaker="amixer -c 0 sset 'Analog Output' 'Multichannel'"
alias snd_headphones="amixer -c 0 sset 'Analog Output' 'Stereo Headphones FP'"

# Simple Stopwatch
function stopwatch() {
    date1=$(date +%s); 
    while true; do 
        echo -ne "$(date -u --date @$(($(date +%s) - ${date1})) +%H:%M:%S)\r"; sleep 0.1
    done
}

# Simple countdown timer
function countdown() {
    seconds=${1};
    if [ -z ${seconds} ]; then
        return
    fi
    date1=$(($(date +%s) + ${seconds})); 
    while [ "${date1}" -ne $(date +%s) ]; do 
        echo -ne "$(date -u --date @$((${date1} - $(date +%s) )) +%H:%M:%S)\r"; 
    done
    echo -e "BOOOOOOOMMMM!!!!!!"
}

# Show Batter percentage
function battery() {
    for bat in $(upower -e | grep 'battery'); do
        output="$(upower -i $bat)"
        _name="$(echo "$output" | grep 'native-path' | sed -re 's/^\s*native-path:\s*(.*)$/\1/g')"
        _percentage="$(echo "$output" | grep 'percentage' | sed -re 's/^\s*percentage:\s*([0-9][0-9]%)$/\1/g')"
        _state="$(echo "$output" | grep 'state' | sed -re 's/^\s*state:\s*(.*)$/\1/g')"
        echo "${_name}: ${_percentage} (${_state})"
    done
}

# test files with different hash functions
function _hashtest() {
    # $1 = hash-algorithm / $2 = hash-length
    # $3 = file / $4 = hash
    if (( ${#} != 4 )); then
        echo "usage: ${1:-_hash}test [FILE] [HASH]" >&2
        return 1
    fi
    if [[ ! -e "${3}" ]]; then
        echo "cannot find file ${3}" >&2
        return 1
    fi
    if (( ${#4} != ${2} )); then
        echo "invalid ${1}-hash ${4}" >&2
        return 1
    fi

    [[ $( ${1}sum "${3}" | head -c ${2}) == "${4}" ]] && echo "File valid!" >&2 || echo "File invalid!" >&2
}

alias md5test='_hashtest "md5" 32'
alias sha256test='_hashtest "sha256" 64'
alias sha512test='_hashtest "sha512" 128'

# Manage local and remote proxy settings
function manage_proxy() {
    case ${1} in
        set)
            PROXY_IP="192.168.110.15"
            PROXY_PORT=3128
            echo "Setting proxy to ${PROXY_IP}:${PROXY_PORT}..."
            export http_proxy="http://${PROXY_IP}:${PROXY_PORT}"; export HTTP_PROXY="${http_proxy}"
            export https_proxy="http://${PROXY_IP}:${PROXY_PORT}"; export HTTPS_PROXY="${https_proxy}"
            export ftp_proxy="ftp://${PROXY_IP}:${PROXY_PORT}"; export FTP_PROXY="${https_proxy}"
            export no_proxy="127.0.0.1, localhost, 192.168.110.1, 192.168.110.15"; export NO_PROXY="${no_proxy}"
            gsettings set org.gnome.system.proxy mode 'manual' 
            gsettings set org.gnome.system.proxy.http host "${PROXY_IP}"
            gsettings set org.gnome.system.proxy.http port ${PROXY_PORT}
            gsettings set org.gnome.system.proxy.ftp host "${PROXY_IP}"
            gsettings set org.gnome.system.proxy.ftp port ${PROXY_PORT}
            gsettings set org.gnome.system.proxy.https host "${PROXY_IP}"
            gsettings set org.gnome.system.proxy.https port ${PROXY_PORT}
            gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12' , '*.rs.bussenet.de', '192.168.110.15' ]"
            ;;
        unset)
            echo "Unsetting proxy..."
            unset http_proxy; unset HTTP_PROXY
            unset https_proxy; unset HTTPS_PROXY
            unset ftp_proxy; unset FTP_PROXY
            unset no_proxy; unset NO_PROXY
            gsettings set org.gnome.system.proxy mode 'none' 
            ;;
        *)
            echo "unkown command: ${1}" >&2
            return 1
            ;;
    esac
}

