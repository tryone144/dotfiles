#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to change volume of current pulseaudio or default alsa device
#   needs: [pactl]
#          [alsa]
#
# file: ~/.config/i3/scripts/volume.py
# v0.6 / 2022.05.31
#
# (c) 2022 Bernd Busse
#
# usage: ./volume.py {mute|unmute|toggle|get} | {lower|raise} [STEP]
#

import re
import sys
import subprocess

from itertools import chain


class SinkNotFoundError(Exception):
    pass


class Sink(object):
    """Generic audio sink. To be subclassed..."""

    def __init__(self):
        super().__init__()

    def __str__(self):
        out = f"{self.volume}%"
        if self.muted:
            out = " ".join((out, "(muted)"))

        return out

    def _call(self, cmd):
        if subprocess.call(cmd, stdout=subprocess.DEVNULL) != 0:
            print("Error: Mixer command failed.", file=sys.stderr)
            sys.exit(1)

        return subprocess.check_output(cmd).decode("utf-8").strip()

    def _get_volume(self):
        raise NotImplementedError

    def _set_volume(self, level):
        raise NotImplementedError

    def _is_muted(self):
        raise NotImplementedError

    def _set_muted(self, mute):
        raise NotImplementedError

    @property
    def volume(self):
        return self._get_volume()

    @volume.setter
    def volume(self, level):
        if level < 0:
            print(f"Level {level}% is smaller than 0%, clamp to 0%",
                  file=sys.stderr)
            level = 0
        elif level > 100:
            print(f"Level {level}% is greater than 100%, clamp to 100%",
                  file=sys.stderr)
            level = 100

        return self._set_volume(level)

    @property
    def muted(self):
        return self._is_muted()

    @muted.setter
    def muted(self, mute):
        return self._set_muted(mute)

    def lower_volume(self, step=10):
        level = self.volume - step
        self.volume = level if level > 0 else 0
        return self.volume

    def raise_volume(self, step=10):
        level = self.volume + step
        self.volume = level if level < 100 else 100
        return self.volume

    def toggle(self):
        self.muted = not self.muted
        return self.muted


class AlsaSink(Sink):
    """ALSA specific __Sink__ for device __name__."""
    def __init__(self, name="default"):
        super().__init__()

        if subprocess.call(["amixer", "-D", name], stdout=subprocess.DEVNULL) != 0:
            raise SinkNotFoundError(
                f"ALSA device '{name}' not found."
            )

        self.device = name

    def _amixer(self, *args):
        base_cmd = ("amixer", "-D", self.device, "--")
        return self._call(list(chain(base_cmd, args or [])))

    def _get_volume(self):
        out = self._amixer("sget", "Master", "playback")
        level = re.search("(?!\n).*\[([0-9]+)%\].*\n", out).group(1)
        return int(level)

    def _set_volume(self, level):
        return self._amixer("sset", "Master", "playback", f"{level}%")

    def _is_muted(self):
        out = self._amixer("sget", "Master", "playback")
        return re.search("\[off\]\n", out) is not None

    def _set_muted(self, mute):
        return self._amixer("sset", "Master", "playback",
                            "mute" if mute else "unmute")


class PulseSink(Sink):
    """PulseAudio specific __Sink__ for sink __name__ or __index__."""

    SINK_NAME = object()

    def __init__(self, index=None, name=None):
        super().__init__()

        if index is not None and name:
            raise ValueError(
                f"Specify either sink `index` or `name` but not both."
            )

        # Query sink name for specified index
        if index is not None:
            out = self._pactl("list", "sinks", "short")
            for ll in out.splitlines():
                ll_idx, ll_name, *_ = ll.split("\t")
                if int(ll_idx) == index:
                    name = ll_name
                    break
            else:
                raise SinkNotFoundError(
                    f"No PulseAudio sink with index {index} found."
                )

        # Fall back to default sink if no sink specified
        if not name:
            name = self._pactl("get-default-sink")

        if not name:
            raise SinkNotFoundError(f"No suitable PulseAudio sink found.")

        out = self._pactl("list", "sinks", "short")
        for ll in out.splitlines():
            _, ll_name, *_ = ll.split("\t")
            if ll_name == name:
                break
        else:
            raise SinkNotFoundError(
                f"PulseAudio sink '{name}' not found."
            )

        self.sink_name = name

    def _pactl(self, *args):
        base_cmd = ("pactl", "--")
        return self._call(list(c if c != self.SINK_NAME else self.sink_name
                               for c in chain(base_cmd, args or [])))

    def _get_volume(self):
        out = self._pactl("get-sink-volume", self.SINK_NAME)
        line = [ll for ll in out.splitlines()
                if ll.startswith("Volume:")][0] or ""

        levels = [int(level) for level in re.findall(
            "[\w-]+:\s*[0-9]+\s*\/\s*([0-9]+)%", line, re.M
        )]
        return sum(levels) // len(levels)

    def _set_volume(self, level):
        return self._pactl("set-sink-volume", self.SINK_NAME, f"{level}%")

    def _is_muted(self):
        out = self._pactl("get-sink-mute", self.SINK_NAME)
        line = [ll for ll in out.splitlines()
                if ll.startswith("Mute:")][0] or ""

        return re.match("^.*yes$", line, re.M) is not None

    def _set_muted(self, mute):
        return self._pactl("set-sink-mute", self.SINK_NAME,
                           "1" if mute else "0")


commands = {
    "get":    (False, ),
    "set":    (True, ),
    "lower":  (True, ),
    "raise":  (True, ),
    "mute":   (False, ),
    "unmute": (False, ),
    "toggle": (False, ),
}

usage = (
    "    usage: {0} [{{--sink|--device}} SINK_OR_DEVICE] "
    "[{{get|mute|unmute|toggle}} | {{lower|raise}} [STEP] | set VOLUME]"
)


def get_sink(driver=None, name=None):
    """Find preferred sink, or fall back to default."""
    if driver is None or driver == "pulse":
        if subprocess.call(["pactl", "info"], stdout=subprocess.DEVNULL,
                           stderr=subprocess.DEVNULL) == 0:
            try:
                if driver == "pulse" and name:
                    if name.isdigit():
                        return PulseSink(index=int(name))
                    else:
                        return PulseSink(name=name)
                else:
                    return PulseSink()
            except SinkNotFoundError as e:
                print(str(e), file=sys.stderr)
                if name:
                    sys.exit(1)

    # no PulseAudio support, fall back to ALSA
    try:
        if driver == "alsa" and name:
            return AlsaSink(name)
        else:
            return AlsaSink()
    except SinkNotFoundError as e:
        print(str(e), file=sys.stderr)
        sys.exit(1)


def main(action, args, verbose=False, device=None):
    def _log(*args, **kwargs):
        if verbose:
            print(*args, **kwargs)

    def _parse_volume_param(arg, name):
        try:
            return int(arg.rstrip("%"))
        except ValueError:
            print(f"Invalid parameter {name} = '{arg}'. Must be an integer in "
                  f"range 0 to 100.", file=sys.stderr)
            sys.exit(1)

    sink = get_sink(*device if device else [])

    if action == "mute":
        sink.muted = True
        _log(f"muted {sink!r}")
    elif action == "unmute":
        sink.muted = False
        _log(f"unmuted {sink!r}")
    elif action == "toggle":
        muted = sink.toggle()
        _log(f"toggle {sink!r} =>", "muted" if muted else "unmuted")
    elif action == "get":
        _log(f"{sink!r}: ", end="")
        print(f"{sink!s}")
    elif action == "set":
        try:
            volume = _parse_volume_param(args[0], "VOLUME")
        except IndexError:
            print("Missing parameter VOLUME. Must be an integer in range "
                  "0 to 100.", file=sys.stderr)
            sys.exit(1)
        sink.volume = volume
        _log(f"set {sink!r} volume to {volume} => {sink!s}")
    elif action == "lower":
        try:
            step = _parse_volume_param(args[0], "STEP")
        except IndexError:
            step = 10
        sink.lower_volume(step)
        _log(f"lower {sink!r} volume by {step}% => {sink!s}")
    elif action == "raise":
        try:
            step = _parse_volume_param(args[0], "STEP")
        except IndexError:
            step = 10
        sink.raise_volume(step)
        _log(f"raise {sink!r} volume by {step}% => {sink!s}")
    else:
        raise ValueError(f"Invalid action: '{action}'")


if __name__ == "__main__":
    cmd = "get"
    cmd_args = []
    verbose = False
    dev = None

    args = sys.argv[1:]

    if "-h" in args or "--help" in args \
            or "h" in args or "help" in args:
        print(usage.format(sys.argv[0]))
        sys.exit(0)

    if "-v" in args:
        verbose = True
        args.remove("-v")
    if "--verbose" in args:
        verbose = True
        args.remove("--verbose")

    for arg in args:
        sink_arg = re.match("^(?:-[sdD]|--(?:sink|device)(?:=(.+))?)$", arg)
        if sink_arg is not None:

            if sink_arg.group(0).strip("-")[0] == "s":
                driver = "pulse"
            else:
                driver = "alsa"

            if sink_arg.group(1):
                dev = (driver, sink_arg.group(1))
            else:
                idx = args.index(arg)
                dev = (driver, args[idx+1])
                del args[idx+1]

            args.remove(arg)
            break

    if len(args) > 0:
        for verb in commands.keys():
            if verb.startswith(args[0]):
                cmd = verb
                cmd_args = args[1:]
                break
        else:
            level = re.match("^[+-]?([0-9]+)%?$", args[0])
            if level is not None:
                cmd_args = [level.group(1)]
                if "+" in args[0]:
                    cmd = "raise"
                elif "-" in args[0]:
                    cmd = "lower"
                else:
                    cmd = "set"
            else:
                print(f"Unkown command: {args[0]}", file=sys.stderr)
                print(usage.format(sys.argv[0]), file=sys.stderr)
                sys.exit(1)

    if (not commands[cmd][0] and len(cmd_args) > 0) \
            or (commands[cmd][0] and len(cmd_args) > 1):
        print(usage.format(sys.argv[0]), file=sys.stderr)
        sys.exit(1)

    main(cmd, cmd_args, verbose=verbose, device=dev)
