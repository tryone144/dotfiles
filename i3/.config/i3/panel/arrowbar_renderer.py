#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# powerline-styled wrapper for i3status/j4status
#   needs: [i3]
#          [powerline-fonts]
#          [ionicon-fonts]
#
# file: ~/.config/i3/panel/arrowbar_renderer.py
# v0.5 / 2015.11.11
#

import re
import sys

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
OUTPUT_FMT = "%{{S{output}}}"


# Color codes
def parse_color(code):
    if len(code) == 9 and code[0] == "#":
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


COLOR = parse_color
COL_GOOD = "#00FF00"
COL_BAD = "#FF0000"

COL_DEFAULT_FG = COLOR("#FFFF")
COL_DEFAULT_BG = COLOR("#F000")

COLOR_SEP = COLOR("#CCC")
COLOR_URGENT_FG = COLOR("#FFF")
COLOR_URGENT_BG = COLOR("#900")

COLOR_WORKSPACE_ACTIVE_FG = COLOR("#EEE")
COLOR_WORKSPACE_ACTIVE_BG = COLOR("#1793d1")
COLOR_WORKSPACE_INACTIVE_FG = COLOR("#888")
COLOR_WORKSPACE_INACTIVE_BG = COLOR("#333")
COLOR_WORKSPACE_URGENT_FG = COLOR_URGENT_FG
COLOR_WORKSPACE_URGENT_BG = COLOR_URGENT_BG

COLOR_STATUS_TIME_FG = COLOR("#EEE")
COLOR_STATUS_TIME_BG = COLOR("#1793d1")
COLOR_STATUS_VOL_BG = COLOR("#555")
COLOR_STATUS_VOL_MUTE_BG = COLOR("#846")
COLOR_STATUS_BATTERY_BG = COLOR("#444")
COLOR_STATUS_URGENT_FG = COLOR_URGENT_FG
COLOR_STATUS_URGENT_BG = COLOR_URGENT_BG


# Helper functions (output)
def fprint_nb(fd, msg):
    fd.write(str(msg))
    fd.flush()


def print_nb(msg):
    fprint_nb(sys.stdout, str(msg))


class Renderer(object):
    SEGMENTS_LEFT = [re.compile(pat) for pat in ("workspace", )]
    SEGMENTS_CENTER = [re.compile(pat) for pat in ()]
    SEGMENTS_RIGHT = [re.compile(pat) for pat in ("pulseaudio",
                                                  "backlight",
                                                  "nm-*",
                                                  "cpu", "sensors", "mem",
                                                  "upower-battery",
                                                  "time", )]

    def __init__(self):
        super().__init__()
        self.show_on = None
        self.outputs = []

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

    def set_outputs(self, out):
        self.show_on = out

    def render(self):
        for o, output in enumerate(self.outputs):
            output_left = "%{l}"
            output_center = "%{c}"
            output_right = "%{r}"
            end_sep = self.__escape_color(bg="-") + \
                SEPARATOR_SEGMENT_RIGHT + \
                self.__escape_color(fg="-", bg="-")
            end_line = self.__escape_color(fg="-", bg="-")

            left = self._filter(self.left, output)
            center = self._filter(self.center, output)
            right = self._filter(self.right, output)

            # render segments
            for i, seg in enumerate(left):
                output_left += self._render_segment(
                        seg, POSITION_LEFT, first=(i == 0))
            for i, seg in enumerate(center):
                output_center += self._render_segment(
                        seg, POSITION_CENTER, first=(i == 0),
                        index=i, count=len(center))
            for i, seg in enumerate(right):
                output_right += self._render_segment(
                        seg, POSITION_RIGHT, first=(i == 0))

            print_nb(OUTPUT_FMT.format(output=o) +
                     output_left + end_sep +
                     output_center + end_sep +
                     output_right + end_line)
        print_nb("\n")

    def _render_segment(self, tag, position=POSITION_LEFT,
                        first=False, index=0, count=0):
        if len(tag) == 0:
            return ""

        output = ""
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

                action_end = ""
                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

            # draw end (separator)
            output += self.__escape_color(fg=color_bg)

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

                action_end = ""
                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

            # draw end (separator)
            output += self.__escape_color(fg=color_bg)

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

                action_end = ""
                for b, a in enumerate(t["actions"]):
                    if a is not None:
                        output += ACTION_START_FMT.format(button=b+1, action=a)
                        action_end += ACTION_END_FMT.format(button=b+1)
                output += t["text"] + action_end

        return output

    def _filter(self, segments, output=None):
        n_segs = []
        for tags in segments:
            n_tags = []
            for t in tags:
                if t["output"] is not None and output is not None \
                        and t["output"] != output:
                    continue
                n_tags.append(t)
            n_segs.append(n_tags)
        return n_segs

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

    def update_title(self, objects):
        fprint_nb(sys.stderr, objects)

    def update_outputs(self, objects):
        self.outputs.clear()
        for o in objects:
            if "active" in o.keys() and o["active"] and "name" in o.keys():
                if self.show_on is None \
                        or o["name"] in self.show_on:
                    self.outputs.append(o["name"])

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
        new = self.__tag(tag["name"],
                         " " + ICON_EXP.sub(self.__escape_icon,
                                            tag["full_text"]) + " ")

        if new["name"] == "upower-battery":
            new["text"] = new["text"].replace("Bat ", "") \
                                     .replace("Full ", "") \
                                     .replace("Chr ", "") \
                                     .replace("Empty ", "")
            new["color_bg"] = COLOR_STATUS_BATTERY_BG
            if "color" in tag.keys():
                new["color_fg"] = tag["color"]
                if tag["color"] == COL_BAD:
                    new["text"] = new["text"].replace(ICON_BATTERY_HALF,
                                                      ICON_BATTERY_LOW)
        elif new["name"] == "time":
            new["actions"][0] = "date|toggle"
            new["color_fg"] = COLOR_STATUS_TIME_FG
            new["color_bg"] = COLOR_STATUS_TIME_BG
        elif new["name"] == "pulseaudio":
            new["actions"][0] = "volume|toggle"
            new["color_bg"] = COLOR_STATUS_VOL_BG
            if "color" in tag.keys() and tag["color"] == COL_BAD:
                new["text"] = new["text"].replace(ICON_VOLUME_HIGH,
                                                  ICON_VOLUME_MUTE) \
                                         .replace(ICON_VOLUME_MEDIUM,
                                                  ICON_VOLUME_MUTE) \
                                         .replace(ICON_VOLUME_LOW,
                                                  ICON_VOLUME_MUTE)
                new["color_bg"] = COLOR_STATUS_VOL_MUTE_BG
        elif new["name"] == "backlight":
            pass

        if "urgent" in tag.keys() and tag["urgent"]:
            new["color_fg"] = COLOR_STATUS_URGENT_FG
            new["color_bg"] = COLOR_STATUS_URGENT_BG

        return new

    def __workspace_filter(self, ws):
        new = self.__tag("workspace",
                         " " + ws.name + " ",
                         actions=["i3|change-ws|" + ws.name,
                                  None, None],
                         color_fg=COLOR_WORKSPACE_INACTIVE_FG,
                         color_bg=COLOR_WORKSPACE_INACTIVE_BG)

        if "output" in ws.keys():
            new["output"] = ws.output

        if "focused" in ws.keys() and ws.focused:
            new["color_fg"] = COLOR_WORKSPACE_ACTIVE_FG
            new["color_bg"] = COLOR_WORKSPACE_ACTIVE_BG
        elif "urgent" in ws.keys() and ws.urgent:
            new["color_fg"] = COLOR_WORKSPACE_URGENT_FG
            new["color_bg"] = COLOR_WORKSPACE_URGENT_BG

        return new

    def __tag(self, name, text, output=None, actions=None,
              color_fg=COL_DEFAULT_FG, color_bg=COL_DEFAULT_BG):
        actions = actions if actions is not None else [None, None, None]
        return {"name": name, "text": text,
                "output": output, "actions": actions,
                "color_fg": color_fg, "color_bg": color_bg}

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
            output += "%{F" + fg + "}"

        if bg is not None:
            output += "%{B" + bg + "}"

        return output
