#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to change brightness of display
#   needs: [xbacklight]
#
# file: ~/.config/i3/scripts/brightness.py
# v0.1 / 2015.03.04
#
# (c) 2015 Bernd Busse
#
# usage: ./brightness.py get | {inc|dec} [STEP]
#

import sys
import subprocess

step_mapping = [1, 3, 6, 10, 15, 20, 30, 40, 50, 60, 80, 100]
xbacklight_cmd = ['xbacklight', '-time', '10', '-steps', '2']


# decrease brightness by custom mapping
def decrease_brightness():
    bright = get_brightness()
    if bright < 3:
        bright = 1
    else:
        for i, val in enumerate(step_mapping):
            if bright <= val:
                bright = step_mapping[i-1]
                break

    cmd = xbacklight_cmd + ['-set', str(bright)]
    if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
        sys.stderr.write("Fehler aufgetreten\n")


# increase brightness by custom mapping
def increase_brightness(steps=1):
    bright = get_brightness()
    if bright > 80:
        bright = 100
    else:
        for i, val in enumerate(step_mapping):
            if bright <= val:
                bright = step_mapping[i+1]
                break

    cmd = xbacklight_cmd + ['-set', str(bright)]
    if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
        sys.stderr.write("Fehler aufgetreten\n")


# get brightness in percent
def get_brightness():
    cmd = xbacklight_cmd + ['-get']
    out = str(subprocess.check_output(cmd), "utf-8")

    try:
        return round(float(out))
    except ValueError:
        sys.stderr.write("Fehler aufgetreten\n")
        return None

commands = ['inc', '+',
            'dec', '-',
            'get', 'g']

usage = "    usage: {0} get | {{inc|dec}}"


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
    if action == 'dec' or action == '-':
        decrease_brightness()
        if verbose:
            print("decrease brightness ==> {0}%".format(get_brightness()))
    elif action == 'inc' or action == '+':
        increase_brightness()
        if verbose:
            print("increase brightness ==> {0}%".format(get_brightness()))
    elif action == 'get' or action == 'g':
        print("Brightness: {0}%".format(get_brightness()))

if __name__ == '__main__':
    main()
