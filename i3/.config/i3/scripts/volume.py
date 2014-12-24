#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to change volume of default alsa device
#   needs: [alsa]
#
# file: ~/.config/i3/scripts/volume.py
# v0.1 / 2014.12.24
#
# (c) 2014 Bernd Busse
#
# usage: ./volume.py {mute|get} | {lower|raise} [STEP]
#
import re
import sys
import subprocess

amixer_cmd = ['amixer', '-D', 'default', '--']

# toggle mute
def mute_toggle():
#    pactl -- set-sink-mute ${pa_sink} toggle
    cmd = amixer_cmd + ['sset', 'Master', 'playback', 'toggle']
    subprocess.call(cmd, stdout=subprocess.DEVNULL)

# lower volume by given percent
def lower_volume(step=10):
#    pactl -- set-sink-volume ${pa_sink} -${1}%
    cmd = amixer_cmd + ['sset', 'Master', 'playback', '{0}%-'.format(step)]
    subprocess.call(cmd, stdout=subprocess.DEVNULL)

# raise volume by given percent
def raise_volume(step=10):
#    pactl -- set-sink-volume ${pa_sink} +${1}%
    cmd = amixer_cmd + ['sset', 'Master', 'playback', '{0}%+'.format(step)]
    subprocess.call(cmd, stdout=subprocess.DEVNULL)

# get volume level in percent
def get_volume():
#    level="$(pactl list sinks | sed -nr -e 's_^\tVolume:.*\w+:\s*[0-9]+\s*/\s*([0-9]+%)\s*/.*_\1_p' | sed -nr -e "$((${pa_sink}+1))p")"
#    mute=$(pactl list sinks | grep -Pe '^\tMute:' | sed -nr -e "$((${pa_sink}+1))p" | grep -Pe '^\tMute:\s+no$' > /dev/null; echo ${?})
    cmd = amixer_cmd + ['sget', 'Master', 'playback']
    out = str(subprocess.check_output(cmd), "utf-8")
    level = re.search('(?!\n).*\[([0-9]+%)\].*\n', out).group(1)
    mute = re.search('\[off\]\n', out)
    if mute is not None:
        level += " (muted)"

    return level

# test for 'pactl'
#def check_pactl():
#    pass
#if [[ -x "$(which pactl)" ]]; then
#    use_pactl=1
#    pa_sinklist="$(pactl list sinks short | grep -i "running")"
#    if [[ ${?} == 0 ]]; then
#        pa_sink="$(echo "${pa_sinklist}" | cut -f1)"
#    else
#        use_pactl=0
#    fi
#else
#    use_pactl=0
#fi

commands = [ 'mute',  'm',
             'lower', 'l',
             'raise', 'r',
             'get',   'g' ]

usage = "    usage: {0} {{mute|get}} | {{lower|raise}} [STEP]"

def main():
    verbose = False
    args = sys.argv
    if len(args) < 2:
        print(usage.format(args[0]))
        sys.exit(1)
    
    if '-v' in args[1:]:
        verbose = True
        args.remove('-v')

    if args[1] not in commands:
        print("Unkown command: {0}".format(args[0]))
        print(usage.format(args[0]))
        sys.exit(1)
    
    action = args[1]
    if action == 'mute' or action == 'm':
        mute_toggle()
        if verbose:
            print("toggle mute ==> {0}".format(get_volume()))
    elif action == 'lower' or action == 'l':
        try:
            step = int(args[2])
        except (IndexError, ValueError):
            step = 10
        lower_volume(step)
        if verbose:
            print("lower volume by {1}% ==> {0}".format(get_volume(), step))
    elif action == 'raise' or action == 'r':
        try:
            step = int(args[2])
        except (IndexError, ValueError) as e:
            step = 10
        raise_volume(step)
        if verbose:
            print("raise volume by {1}% ==> {0}".format(get_volume(), step))
    elif action == 'get' or action == 'g':
        print(get_volume())

if __name__ == '__main__':
    main()

