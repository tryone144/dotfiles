#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to change volume of current pulseaudio or default alsa device
#   needs: [pactl]
#          [alsa]
#
# file: ~/.config/i3/scripts/volume.py
# v0.6 / 2015.07.19
#
# (c) 2015 Bernd Busse
#
# usage: ./volume.py {mute|unmute|toggle|get} | {lower|raise} [STEP]
#
import re
import sys
import subprocess


class sink(object):
    """ Generic sink. To be subclassed... """
    def __init__(self):
        super().__init__()

    def __str__(self):
        out = "{0}%".format(self.get_volume())
        if self.is_mute():
            out += " (muted)"

        return out

    def set_volume(self, level):
        raise NotImplementedError

    def lower_volume(self, step=10):
        raise NotImplementedError

    def raise_volume(self, step=10):
        raise NotImplementedError

    def get_volume(self):
        raise NotImplementedError

    def set_mute(self, enabled):
        raise NotImplementedError

    def toggle_mute(self):
        raise NotImplementedError

    def is_mute(self):
        raise NotImplementedError

    def call(self, cmd):
        if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
            sys.stderr.write("Fehler aufgetreten\n")
            sys.exit(1)


class alsa_sink(sink):
    """ ALSA specific actions for device with name __name__ """
    def __init__(self, name='default'):
        super().__init__()

        self.name = name
        self.cmd = ['amixer', '-D', self.name, '--']

    def set_volume(self, level):
        cmd = self.cmd + ['sset', 'Master', 'playback',
                          '{0}%'.format(level)]
        self.call(cmd)

    def lower_volume(self, step=10):
        cmd = self.cmd + ['sset', 'Master', 'playback',
                          '{0}%-'.format(step)]
        self.call(cmd)

    def raise_volume(self, step=10):
        cmd = self.cmd + ['sset', 'Master', 'playback',
                          '{0}%+'.format(step)]
        self.call(cmd)

    def get_volume(self):
        cmd = self.cmd + ['sget', 'Master', 'playback']
        out = str(subprocess.check_output(cmd), "utf-8")
        level = re.search('(?!\n).*\[([0-9]+)%\].*\n', out).group(1)

        return int(level)

    def set_mute(self, mute):
        cmd = self.cmd + ['sset', 'Master', 'playback',
                          'mute' if mute else 'unmute']
        self.call(cmd)

    def toggle_mute(self):
        cmd = self.cmd + ['sset', 'Master', 'playback',
                          'toggle']
        self.call(cmd)

    def is_mute(self):
        cmd = self.cmd + ['sget', 'Master', 'playback']
        out = str(subprocess.check_output(cmd), "utf-8")
        mute = re.search('\[off\]\n', out)

        return mute is not None


class pulseaudio_sink(sink):
    """ PulseAudio specific actions for sink with index __index__ """
    def __init__(self, index, number):
        super().__init__()

        self.number = number
        self.index = index
        self.cmd = ['pactl', '--']

    def set_volume(self, level):
        if level > 100:
            print("Level {0}% is larger than 100%, resetting...".format(level))
            level = 100

        cmd = self.cmd + ['set-sink-volume', str(self.index),
                          '{0}%'.format(level)]
        self.call(cmd)

    def lower_volume(self, step=10):
        cmd = self.cmd + ['set-sink-volume', str(self.index),
                          '-{0}%'.format(step)]
        self.call(cmd)

    def raise_volume(self, step=10):
        if self.get_volume() + step > 100:
            self.set_volume(100)
            return

        cmd = self.cmd + ['set-sink-volume', str(self.index),
                          '+{0}%'.format(step)]
        self.call(cmd)

    def get_volume(self):
        cmd = self.cmd + ['list', 'sinks']
        out = str(subprocess.check_output(cmd), "utf-8")
        levels = re.findall('^\tVolume:\s*[\w-]+:\s*[0-9]+\s*\/\s*([0-9]+)%',
                            out, re.M)

        return int(levels[self.number])

    def set_mute(self, mute):
        cmd = self.cmd + ['set-sink-mute', str(self.index),
                          'true' if mute else 'false']
        self.call(cmd)

    def toggle_mute(self):
        cmd = self.cmd + ['set-sink-mute', str(self.index),
                          'toggle']
        self.call(cmd)

    def is_mute(self):
        cmd = self.cmd + ['list', 'sinks']
        out = str(subprocess.check_output(cmd), "utf-8")
        sinks = re.findall('^\tMute:\s(\w+)$', out, re.M)
        mute = re.match('yes', sinks[self.number])

        return mute is not None


# test for 'pactl'
def get_default_sink():
    if subprocess.call(["pactl"], stdout=subprocess.DEVNULL,
                       stderr=subprocess.DEVNULL) == 127:
        # no PulseAudio support, fallback to ALSA
        return alsa_sink(name="default")
    else:
        cmd = ['pactl', '--', 'list', 'sinks', 'short']
        out = str(subprocess.check_output(cmd), "utf-8").splitlines()

        for i, o in enumerate(out):
            sink = re.search('^([0-9])\t(\w*combined\w*)\t.*$', o, re.M)
            if sink is not None:
                return pulseaudio_sink(int(sink.group(1)), i)


commands = ['mute',   'm',
            'unmute', 'u',
            'toggle', 't',
            'lower',  'l',
            'raise',  'r',
            'get',    'g']

usage = "    usage: {0} {{mute|unmute|toggle|get}} | {{lower|raise}} [STEP]"


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
    s = get_default_sink()
    if action == 'toggle' or action == 't':
        s.toggle_mute()
        if verbose:
            print("toggle mute ==> {0}".format(s))
    elif action == 'mute' or action == 'm':
        s.set_mute(mute=True)
        if verbose:
            print("mute on ==> {0}".format(s))
    elif action == 'unmute' or action == 'u':
        s.set_mute(mute=False)
        if verbose:
            print("mute off ==> {0}".format(s))
    elif action == 'lower' or action == 'l':
        try:
            step = int(args[2])
        except (IndexError, ValueError):
            step = 10
        s.lower_volume(step)
        if verbose:
            print("lower volume by {1}% ==> {0}".format(s, step))
    elif action == 'raise' or action == 'r':
        try:
            step = int(args[2])
        except (IndexError, ValueError):
            step = 10
        s.raise_volume(step)
        if verbose:
            print("raise volume by {1}% ==> {0}".format(s, step))
    elif action == 'get' or action == 'g':
        print(s)

if __name__ == '__main__':
    main()
