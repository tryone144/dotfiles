#
# BASH
# .bash_profile with custom functions
# 
# file: ~/.bashrc
# v0.1 / 2014.12.10
#
# © 2014 Bernd Busse
#

# run .bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Simple Stopwatch
function stopwatch(){
    date1=`date +%s`; 
    while true; do 
        echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; sleep 0.1
    done
}

