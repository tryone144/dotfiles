#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to change volume of current pulseaudio or default alsa device
#   needs: [pactl]
#          [alsa]
#
# file: ~/.config/i3/scripts/volume.py
# v0.2 / 2015.01.03
#
# (c) 2015 Bernd Busse
#
# usage: ./volume.py {mute|get} | {lower|raise} [STEP]
#
import re
import sys
import subprocess

amixer_cmd = ['amixer', '-D', 'default', '--']
pactl_cmd = ['pactl', '--']

# toggle mute
def mute_toggle():
    pa_sink = get_sink()
    if pa_sink is not None:
        cmd = pactl_cmd + ['set-sink-mute', str(pa_sink), 'toggle']
    else:
        cmd = amixer_cmd + ['sset', 'Master', 'playback', 'toggle']
    if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
        sys.stderr.write("Fehler aufgetreten\n")

# lower volume by given percent
def lower_volume(step=10):
    pa_sink = get_sink()
    if pa_sink is not None:
        cmd = pactl_cmd + ['set-sink-volume', str(pa_sink), '-{0}%'.format(step)]
    else:
        cmd = amixer_cmd + ['sset', 'Master', 'playback', '{0}%-'.format(step)]
    if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
        sys.stderr.write("Fehler aufgetreten\n")

# raise volume by given percent
def raise_volume(step=10):
    pa_sink = get_sink()
    if pa_sink is not None:
        if (int(re.search('^([0-9]+)%.*$', get_volume()).group(1)) + step) > 100:
            cmd = pactl_cmd + ['set-sink-volume', str(pa_sink), '100%']
        else:
            cmd = pactl_cmd + ['set-sink-volume', str(pa_sink), '+{0}%'.format(step)]
    else:
        cmd = amixer_cmd + ['sset', 'Master', 'playback', '{0}%+'.format(step)]
    if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
        sys.stderr.write("Fehler aufgetreten\n")



# get volume level in percent
def get_volume():
    pa_sink = get_sink()
    if pa_sink is not None:
        cmd = pactl_cmd + ['list', 'sinks']
        out = str(subprocess.check_output(cmd), "utf-8")
        levels = re.findall('^\tVolume:.*\w+:\s*[0-9]+\s*/\s*([0-9]+%)\s*/.*$', out, re.M)
        level = levels[pa_sink]
        sinks = re.findall('^\tMute:\s(\w+)$', out, re.M)
        mute = re.match('yes', sinks[pa_sink])
    else:
        cmd = amixer_cmd + ['sget', 'Master', 'playback']
        out = str(subprocess.check_output(cmd), "utf-8")
        level = re.search('(?!\n).*\[([0-9]+%)\].*\n', out).group(1)
        mute = re.search('\[off\]\n', out)
    
    if mute is not None:
        level += " (muted)"
    return level

# test for 'pactl'
def get_sink():
    if subprocess.call(["pactl"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 127:
        return None
    else:
        cmd = pactl_cmd + ['list', 'sinks', 'short']
        out = str(subprocess.check_output(cmd), "utf-8")
        sink = re.search('^([0-9])\t.*\tRUNNING$', out, re.M)
        if sink is not None:
            return int(sink.group(1))
        else:
            sinks = re.finditer('^([0-9])\t(\w+)\t.*$', out, re.M)
            for s in sinks:
                if not re.match('null', s.group(2), re.I):
                    return int(s.group(1))
            return None
        
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

