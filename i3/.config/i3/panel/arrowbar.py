#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# powerline-styled wrapper for i3status/j4status
#   needs: [i3]
#          [powerline-fonts]
#          [ionicon-fonts]
#
# file: ~/.config/i3/panel/arrowbar.py
# v0.4 / 2015.10.16
#

import argparse
import i3ipc
import json
import re
import sys
import threading

POSITION_LEFT = 0
POSITION_RIGHT = 1
POSITION_CENTER = 2

# Special characters and icons
SEPARATOR_SEGMENT_RIGHT = ""   # \uE0B0
SEPARATOR_SEGMENT_LEFT = ""    # \uE0B2
SEPARATOR_PATH_RIGHT = ""      # \uE0B1
SEPARATOR_PATH_LEFT = ""       # \uE0B3

ICON_TIME = ""                 # \uF3B3
ICON_BACKLIGHT = ""            # \uF29B
ICON_CPU = ""                  # \uF2B3
ICON_MEM = ""                  # \uF313
ICON_TEMP = ""                 # \uF2B6

ICON_STORAGE_DISK = ""         # \uF44E
ICON_STORAGE_HOME = ""         # \uF144

ICON_BATTERY_EMPTY = ""        # \uF112
ICON_BATTERY_LOW = ""          # \uF115
ICON_BATTERY_HALF = ""         # \uF114
ICON_BATTERY_FULL = ""         # \uF113
ICON_BATTERY_CHARGE = ""       # \uF111

ICON_VOLUME_MUTE = ""          # \uF3B9
ICON_VOLUME_LOW = ""           # \uF3B8
ICON_VOLUME_MEDIUM = ""        # \uF3B7
ICON_VOLUME_HIGH = ""          # \uF3BA

ICON_NETWORK_WIFI = ""         # \uF25C
ICON_NETWORK_ETHER = ""        # \uF341
ICON_NETWORK_USB = ""          # \uF2B8

# RegEx and format-strings
ICON_EXP = re.compile(":(.*)_IC:")
BAT_EXP = re.compile("(Bat|Chr|Full|Empty)\s")
VOL_EXP = re.compile("([\d]+)%")

ACTION_START_FMT = "%{{A{button}:{action}:}}"
ACTION_END_FMT = "%{{A{button}}}"
COLOR_FMT = "#{aa}{rr}{gg}{bb}"

# Color codes
COLOR_SEP = "#CCC"
COLOR_URGENT_FG = "#FFF"
COLOR_URGENT_BG = "#900"

COLOR_WORKSPACE_ACTIVE_FG = "#EEE"
COLOR_WORKSPACE_ACTIVE_BG = "#1793d1"
COLOR_WORKSPACE_INACTIVE_FG = "#888"
COLOR_WORKSPACE_INACTIVE_BG = "#333"
COLOR_WORKSPACE_URGENT_FG = COLOR_URGENT_FG
COLOR_WORKSPACE_URGENT_BG = COLOR_URGENT_BG

COLOR_STATUS_TIME_FG = "#EEE"
COLOR_STATUS_TIME_BG = "#1793d1"
COLOR_STATUS_URGENT_FG = COLOR_URGENT_FG
COLOR_STATUS_URGENT_BG = COLOR_URGENT_BG


def fprint_nb(fd, msg):
    fd.write(str(msg))
    fd.flush()


def print_nb(msg):
    fprint_nb(sys.stdout, str(msg))


def parse_color(code):
    if code == "-":
        return code
    elif len(code) == 9 and code[0] == "#":
        return code
    else:
        color = {"aa": "FF", "rr": "FF", "gg": "FF", "bb": "FF"}

        if code[0] == "#":
            code = code[1:]

        if len(code) == 3:
            color["rr"] = code[0]*2
            color["gg"] = code[1]*2
            color["bb"] = code[2]*2
        elif len(code) == 4:
            color["aa"] = code[0]*2
            color["rr"] = code[1]*2
            color["gg"] = code[2]*2
            color["bb"] = code[3]*2
        elif len(code) == 6:
            color["rr"] = code[0:2]
            color["gg"] = code[2:4]
            color["bb"] = code[4:6]

        return COLOR_FMT.format(**color)


class Renderer(threading.Thread):
    SEGMENTS_LEFT = [re.compile(pat) for pat in ("workspace", )]
    SEGMENTS_CENTER = [re.compile(pat) for pat in ()]
    SEGMENTS_RIGHT = [re.compile(pat) for pat in ("pulseaudio",
                                                  "backlight",
                                                  "nm-*",
                                                  "cpu", "sensors", "mem",
                                                  "upower-battery",
                                                  "time", )]

    def __init__(self, daemon=True):
        super().__init__(daemon=daemon)

        self.left = [[] for _ in Renderer.SEGMENTS_LEFT]
        self.center = [[] for _ in Renderer.SEGMENTS_CENTER]
        self.right = [[] for _ in Renderer.SEGMENTS_RIGHT]

        self.workspace_objs = []
        self.status_objs = []

        for exp in Renderer.SEGMENTS_LEFT + Renderer.SEGMENTS_CENTER + \
                Renderer.SEGMENTS_RIGHT:
            if exp.pattern == "workspace":
                self.workspace_objs.append(exp.pattern)
            else:
                self.status_objs.append(exp.pattern)

    def run(self):
        pass

    def render(self):
        output_left = "%{l}"
        output_center = "%{c}"
        output_right = "%{r}"

        last_left = len(self.left) - 1
        last_center = len(self.center) - 1
        last_right = len(self.right) - 1

        # render segments
        for i, seg in enumerate(self.left):
            output_left += self._render_segment(
                    seg, POSITION_LEFT,
                    first=(i == 0), last=(i == last_left))
        for i, seg in enumerate(self.center):
            output_center += self._render_segment(
                    seg, POSITION_CENTER,
                    first=(i == 0), last=(i == last_center),
                    index=i, count=len(self.center))
        for i, seg in enumerate(self.right):
            output_right += self._render_segment(
                    seg, POSITION_RIGHT,
                    first=(i == 0), last=(i == last_right))

        print_nb(output_left + output_center + output_right + "\n")

    def _render_segment(self, tag, position=POSITION_LEFT,
                        first=False, last=False, index=0, count=0):
        if len(tag) == 0:
            return ""

        output = ""
        action_end = ""
        color_bg = tag[0]["color_bg"]

        if position == POSITION_LEFT:
            # draw separator
            output += self.__escape_color(bg=color_bg)
            if not first:
                output += SEPARATOR_SEGMENT_RIGHT

            # draw text
            output += self.__escape_color(fg=tag[0]["color_fg"])
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    if t["color_bg"] != color_bg:
                        output += self.__escape_color(fg=color_bg,
                                                      bg=t["color_bg"]) + \
                                  SEPARATOR_SEGMENT_RIGHT + \
                                  self.__escape_color(fg=t["color_fg"],
                                                      bg=t["color_bg"])
                        color_bg = t["color_bg"]
                    else:
                        output += self.__escape_color(fg=COLOR_SEP) + \
                                  SEPARATOR_PATH_RIGHT + \
                                  self.__escape_color(fg=t["color_fg"])

                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

            # draw end (separator)
            output += self.__escape_color(fg=color_bg)
            if last:
                output += self.__escape_color(bg="-") + \
                          SEPARATOR_SEGMENT_RIGHT + \
                          self.__escape_color(fg="-", bg="-")

        elif position == POSITION_CENTER:
            center = count // 2

            # draw separator
            if first:
                output += self.__escape_color(fg=color_bg, bg="-") + \
                          SEPARATOR_SEGMENT_LEFT
            elif index <= center:
                output += self.__escape_color(fg=color_bg) + \
                          SEPARATOR_SEGMENT_LEFT
            elif index > center:
                output += self.__escape_color(bg=color_bg) + \
                          SEPARATOR_SEGMENT_RIGHT

            # draw text
            output += self.__escape_color(fg=tag[0]["color_fg"],
                                          bg=color_bg)
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    if t["color_bg"] != color_bg:
                        if index < center:
                            output += self.__escape_color(fg=t["color_bg"],
                                                          bg=color_bg) + \
                                      SEPARATOR_SEGMENT_LEFT
                        else:
                            output += self.__escape_color(fg=color_bg,
                                                          bg=t["color_bg"]) + \
                                      SEPARATOR_SEGMENT_RIGHT
                        output += self.__escape_color(fg=t["color_fg"],
                                                      bg=t["color_bg"])
                        color_bg = t["color_bg"]
                    else:
                        output += self.__escape_color(fg=COLOR_SEP)
                        if index < center:
                            output += SEPARATOR_PATH_LEFT
                        else:
                            output += SEPARATOR_PATH_RIGHT
                        output += self.__escape_color(fg=t["color_fg"])

                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

            # draw end (separator)
            output += self.__escape_color(fg=color_bg)
            if last:
                output += self.__escape_color(bg="-") + \
                          SEPARATOR_SEGMENT_RIGHT + \
                          self.__escape_color(fg="-", bg="-")

        elif position == POSITION_RIGHT:
            # draw separator
            if first:
                output += self.__escape_color(bg="-")
            output += self.__escape_color(fg=color_bg) + \
                SEPARATOR_SEGMENT_LEFT

            # draw text
            output += self.__escape_color(fg=tag[0]["color_fg"],
                                          bg=color_bg)
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    if t["color_bg"] != color_bg:
                        output += self.__escape_color(fg=t["color_bg"],
                                                      bg=color_bg) + \
                                  SEPARATOR_SEGMENT_LEFT + \
                                  self.__escape_color(fg=t["color_fg"],
                                                      bg=t["color_bg"])
                        color_bg = t["color_bg"]
                    else:
                        output += self.__escape_color(fg=COLOR_SEP) + \
                                  SEPARATOR_PATH_LEFT + \
                                  self.__escape_color(fg=t["color_fg"])

                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

            # draw end
            if last:
                output += self.__escape_color(fg="-", bg="-")

        return output

    def update_workspace(self, objects):
        # clear old workspace
        for i, exp in enumerate(Renderer.SEGMENTS_LEFT):
            if exp.pattern in self.workspace_objs:
                self.left[i].clear()

        for i, exp in enumerate(Renderer.SEGMENTS_RIGHT):
            if exp.pattern in self.workspace_objs:
                self.right[i].clear()

        for i, exp in enumerate(Renderer.SEGMENTS_CENTER):
            if exp.pattern in self.workspace_objs:
                self.center[i].clear()

        # populate segment list
        for ws in objects:
            for i, exp in enumerate(Renderer.SEGMENTS_LEFT):
                if exp.match("workspace"):
                    self.left[i].append(self.__workspace_filter(ws))

            for i, exp in enumerate(Renderer.SEGMENTS_RIGHT):
                if exp.match("workspace"):
                    self.right[i].append(self.__workspace_filter(ws))

            for i, exp in enumerate(Renderer.SEGMENTS_CENTER):
                if exp.match("workspace"):
                    self.center[i].append(self.__workspace_filter(ws))

    def update_status(self, objects):
        # clear old status
        for i, exp in enumerate(Renderer.SEGMENTS_LEFT):
            if exp.pattern in self.status_objs:
                self.left[i].clear()

        for i, exp in enumerate(Renderer.SEGMENTS_RIGHT):
            if exp.pattern in self.status_objs:
                self.right[i].clear()

        for i, exp in enumerate(Renderer.SEGMENTS_CENTER):
            if exp.pattern in self.status_objs:
                self.center[i].clear()

        # populate segment list
        for tag in objects:
            if "name" in tag.keys() and "full_text" in tag.keys():
                for i, exp in enumerate(Renderer.SEGMENTS_LEFT):
                    if exp.match(tag["name"]):
                        self.left[i].append(self.__status_filter(tag))

                for i, exp in enumerate(Renderer.SEGMENTS_RIGHT):
                    if exp.match(tag["name"]):
                        self.right[i].append(self.__status_filter(tag))

                for i, exp in enumerate(Renderer.SEGMENTS_CENTER):
                    if exp.match(tag["name"]):
                        self.center[i].append(self.__status_filter(tag))

    def __status_filter(self, tag):
        new = {"name": tag["name"],
               "text": " " + ICON_EXP.sub(self.__escape_icon,
                                          tag["full_text"]) + " ",
               "actions": [None for _ in range(3)],
               "color_fg": "#FFFFFFFF",
               "color_bg": "#FF000000", }

        if new["name"] == "upower-battery":
            new["text"] = new["text"].replace("Bat ", "") \
                                     .replace("Full ", "") \
                                     .replace("Chr ", "") \
                                     .replace("Empty ", "")
            new["color_bg"] = "#444"
            if "color" in tag.keys():
                new["color_fg"] = tag["color"]
                if tag["color"] == "#FF0000":
                    new["text"] = new["text"].replace(ICON_BATTERY_HALF,
                                                      ICON_BATTERY_LOW)
        elif new["name"] == "time":
            new["actions"][0] = "date|toggle"
            new["color_fg"] = COLOR_STATUS_TIME_FG
            new["color_bg"] = COLOR_STATUS_TIME_BG
        elif new["name"] == "pulseaudio":
            new["actions"][0] = "volume|toggle"
            new["color_bg"] = "#555"
            if "color" in tag.keys() and tag["color"] == "#FF0000":
                new["text"] = new["text"].replace(ICON_VOLUME_HIGH,
                                                  ICON_VOLUME_MUTE) \
                                         .replace(ICON_VOLUME_MEDIUM,
                                                  ICON_VOLUME_MUTE) \
                                         .replace(ICON_VOLUME_LOW,
                                                  ICON_VOLUME_MUTE)
                new["color_bg"] = "#846"
        elif new["name"] == "backlight":
            pass

        if "urgent" in tag.keys() and tag["urgent"]:
            new["color_fg"] = COLOR_STATUS_URGENT_FG
            new["color_bg"] = COLOR_STATUS_URGENT_BG

        return new

    def __workspace_filter(self, ws):
        new = {"name": "workspace",
               "text": " " + ws.name + " ",
               "actions": ["i3|change-ws|" + ws.name,
                           None, None],
               "color_fg": COLOR_WORKSPACE_INACTIVE_FG,
               "color_bg": COLOR_WORKSPACE_INACTIVE_BG, }

        if ws.focused:
            new["color_fg"] = COLOR_WORKSPACE_ACTIVE_FG
            new["color_bg"] = COLOR_WORKSPACE_ACTIVE_BG
        elif ws.urgent:
            new["color_fg"] = COLOR_WORKSPACE_URGENT_FG
            new["color_bg"] = COLOR_WORKSPACE_URGENT_BG

        return new

    def __escape_icon(self, match):
        if match is None:
            return ""

        mode = match.group(1)
        if mode == "BAT":
            m = BAT_EXP.search(match.string)
            if m is None:
                return ICON_BATTERY_HALF

            state = m.group(1)
            if state == "Full":
                return ICON_BATTERY_FULL
            elif state == "Empty":
                return ICON_BATTERY_EMPTY
            elif state == "Chr":
                return ICON_BATTERY_CHARGE
            else:
                return ICON_BATTERY_HALF
        elif mode == "VOL":
            m = VOL_EXP.search(match.string)
            if m is None:
                return ICON_VOLUME_HIGH

            state = int(m.group(1))
            if state < 10:
                return ICON_VOLUME_LOW
            elif state < 50:
                return ICON_VOLUME_MEDIUM
            else:
                return ICON_VOLUME_HIGH
        elif mode == "LIGHT":
            return ICON_BACKLIGHT
        elif mode[:3] == "NET":
            iface = mode[4:]
            if iface == "WIFI":
                return ICON_NETWORK_WIFI
            elif iface == "USB":
                return ICON_NETWORK_USB
            else:
                return ICON_NETWORK_ETHER
        elif mode == "TIME":
            return ICON_TIME
        elif mode == "CPU":
            return ICON_CPU
        elif mode == "RAM":
            return ICON_MEM
        elif mode == "TEMP":
            return ICON_TEMP
        else:
            return ""

    def __escape_color(self, fg=None, bg=None):
        output = ""

        if fg is not None:
            color_fg = parse_color(fg)
            output += "%{F" + color_fg + "}"

        if bg is not None:
            color_bg = parse_color(bg)
            output += "%{B" + color_bg + "}"

        return output


def on_change_ws(i3, event):
    global renderer

    if event.change in ('focus', 'init', 'empty', 'urgent'):
        if renderer is not None:
            renderer.update_workspace(i3.get_workspaces())
            renderer.render()


def ws_thread(quit_event=None):
    global renderer

    try:
        i3 = i3ipc.Connection()
        if renderer is not None:
            renderer.update_workspace(i3.get_workspaces())
            renderer.render()

        i3.on("workspace", on_change_ws)
        i3.main()

        die_thread(quit_event, "connection to i3 lost.")
    except:
        die_thread(quit_event)


def stdin_thread(quit_event=None):
    global renderer

    try:
        # read header tags
        while True:
            _head = sys.stdin.readline()
            if _head == "":
                die_thread(quit_event, "stdin closed.")
            try:
                json.loads(_head)
            finally:
                break

        # read opening tag
        while True:
            _start = sys.stdin.readline()
            if _start == "":
                die_thread(quit_event, "stdin closed.")
            if _start[0] == "[":
                break

        # read contious status data
        while True:
            _line = sys.stdin.readline()
            if _line == "":
                die_thread(quit_event, "stdin closed.")
            if _line.startswith(","):
                _line = _line[1:]

            try:
                if renderer is not None:
                    renderer.update_status(json.loads(_line))
                    renderer.render()
            except json.decoder.JSONDecodeError as e:
                fprint_nb(sys.stderr,
                          "Error decoding JSON: " + e.msg + "\n")
    except:
        die_thread(quit_event)


def die_thread(event, msg="stopped unexpectedly"):
    if event is not None:
        fprint_nb(sys.stderr, "Error: " + msg + "\n")
        event.set()
    else:
        raise RuntimeError(msg)


def run(workspace=False):
    global renderer
    renderer = Renderer(daemon=True)
    renderer.start()

    stop_event = threading.Event()

    # open i3 IPC socket
    if workspace:
        i3_thread = threading.Thread(target=ws_thread,
                                     kwargs={"quit_event": stop_event},
                                     daemon=True)
        i3_thread.start()

    # start json parser
    status_thread = threading.Thread(target=stdin_thread,
                                     kwargs={"quit_event": stop_event},
                                     daemon=True)
    status_thread.start()

    try:
        stop_event.wait()
    except KeyboardInterrupt:
        fprint_nb(sys.stderr, "Got KeyboardInterrupt. exiting...\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
            description="powerline-styled i3status-wrapper for lemonbar",
            add_help=True)
    parser.add_argument("-w", "--workspace", action="store_true",
                        default=False, help="Add workspace information")
    args = parser.parse_args()

    run(workspace=args.workspace)
