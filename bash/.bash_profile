#
# BASH
# .bash_profile with custom functions
# 
# file: ~/.bashrc
# v0.1 / 2014.12.10
#
# (c) 2014 Bernd Busse
#

# run .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

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

