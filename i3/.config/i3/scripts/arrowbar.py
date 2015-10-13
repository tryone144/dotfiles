#!/bin/env python3
# ARROWBAR
# powerline-styled wrapper for i3status/j4status
#
# file: arrowbar.py
# v0.2 / 2015.10.13
#
# (c) 2015 Bernd Busse
# The MIT License (MIT)
#

import i3ipc
import json
import sys
import threading

POSITION_LEFT = 0
POSITION_RIGHT = 1
POSITION_CENTER = 2

SEPARATOR_SEGMENT_RIGHT = ""   # \uE0B0
SEPARATOR_SEGMENT_LEFT = ""    # \uE0B2
SEPARATOR_PATH_RIGHT = ""      # \uE0B1
SEPARATOR_PATH_LEFT = ""       # \uE0B3

COLOR_FMT = "#{aa}{rr}{gg}{bb}"
COLOR_SEP = "#DDD"


def fprint_nb(fd, msg):
    fd.write(str(msg))
    fd.flush()


def print_nb(msg):
    fprint_nb(sys.stdout, str(msg))


class Renderer(threading.Thread):
    SEGMENTS_LEFT = ("workspace", )
    SEGMENTS_CENTER = ("time", )
    SEGMENTS_RIGHT = ("pulseaudio",
                      "nm-ethernet",
                      "nm-wifi",
                      "upower-battery", )

    def __init__(self):
        super().__init__(daemon=True)

        self.left = [[] for _ in Renderer.SEGMENTS_LEFT]
        self.center = [[] for _ in Renderer.SEGMENTS_CENTER]
        self.right = [[] for _ in Renderer.SEGMENTS_RIGHT]

    def run(self):
        pass

    def render(self):
        output_left = "%{l}"
        output_center = "%{c}"
        output_right = "%{r}"

        # render segments
        for i, seg in enumerate(self.left):
            output_left += render_segment(seg, POSITION_LEFT,
                                          first=(i == 0),
                                          last=(i == len(self.left)-1))
        for i, seg in enumerate(self.center):
            output_center += render_segment(seg, POSITION_CENTER,
                                            first=(i == 0),
                                            last=(i == len(self.center)-1),
                                            index=i,
                                            count=len(self.center))
        for i, seg in enumerate(self.right):
            output_right += render_segment(seg, POSITION_RIGHT,
                                           first=(i == 0),
                                           last=(i == len(self.right)-1))

        print_nb(output_left + output_center + output_right + "\n")

    def update_workspace(self, objects):
        # clear old workspace
        self.left[0].clear()

        # populate segment list
        for ws in objects:
            if "workspace" in Renderer.SEGMENTS_LEFT:
                index = Renderer.SEGMENTS_LEFT.index("workspace")
                self.left[index].append(
                        self.__workspace_filter(ws))

            if "workspace" in Renderer.SEGMENTS_RIGHT:
                index = Renderer.SEGMENTS_RIGHT.index("workspace")
                self.right[index].append(
                        self.__workspace_filter(ws))

            if "workspace" in Renderer.SEGMENTS_CENTER:
                index = Renderer.SEGMENTS_CENTER.index("workspace")
                self.center[index].append(
                        self.__workspace_filter(ws))

    def update_status(self, objects):
        # clear old status
        self.center[0].clear()
        self.right[0].clear()
        self.right[1].clear()
        self.right[2].clear()
        self.right[3].clear()

        # populate segment list
        for tag in objects:
            if "name" in tag.keys() and "full_text" in tag.keys():
                if tag["name"] in Renderer.SEGMENTS_LEFT:
                    index = Renderer.SEGMENTS_LEFT.index(tag["name"])
                    self.left[index].append(
                            self.__status_filter(tag))

                if tag["name"] in Renderer.SEGMENTS_RIGHT:
                    index = Renderer.SEGMENTS_RIGHT.index(tag["name"])
                    self.right[index].append(
                            self.__status_filter(tag))

                if tag["name"] in Renderer.SEGMENTS_CENTER:
                    index = Renderer.SEGMENTS_CENTER.index(tag["name"])
                    self.center[index].append(
                            self.__status_filter(tag))

    def __status_filter(self, tag):
        new = {"name": "",
               "text": "",
               "color_fg": "#FFFFFFFF",
               "color_bg": "#FF000000"}
        if "name" in tag.keys():
            new["name"] = tag["name"]
        if "full_text" in tag.keys():
            new["text"] = " " + tag["full_text"].replace("%", "%%") + " "
        if "color" in tag.keys():
            new["color_fg"] = tag["color"]

        return new

    def __workspace_filter(self, ws):
        new = {"name": "workspace",
               "text": " " + ws.name.replace("%", "%%") + " ",
               "color_fg": "#FFFFFFFF",
               "color_bg": "#FF000000"}
        if ws.focused:
            new["color_fg"] = "#FF00FF00"

        return new


def parse_color(code):
    if code == "-":
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
        elif len(code) == 8:
            color["aa"] = code[0:2]
            color["rr"] = code[2:4]
            color["gg"] = code[4:6]
            color["bb"] = code[6:8]

        return COLOR_FMT.format(**color)


def escape_color(fg=None, bg=None):
    output = ""

    if fg is not None:
        color_fg = parse_color(fg)
        output += "%{F" + color_fg + "}"

    if bg is not None:
        color_bg = parse_color(bg)
        output += "%{B" + color_bg + "}"

    return output


def render_segment(tag, position=POSITION_LEFT,
                   first=False, last=False, index=0, count=0):
    output = ""

    if len(tag) > 0:
        color_bg = tag[0]["color_bg"]
        center = count // 2

        if position == POSITION_LEFT:
            # draw separator
            output += escape_color(bg=color_bg)
            if not first:
                output += SEPARATOR_SEGMENT_RIGHT

            # draw text
            output += escape_color(fg=tag[0]["color_fg"])
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    output += escape_color(fg=COLOR_SEP)
                    output += SEPARATOR_PATH_RIGHT
                    output += escape_color(fg=t["color_fg"])
                output += t["text"]

            # draw end (separator)
            output += escape_color(fg=color_bg)
            if last:
                output += escape_color(bg="-")
                output += SEPARATOR_SEGMENT_RIGHT
                output += escape_color(fg="-", bg="-")

        elif position == POSITION_CENTER:
            # draw separator
            if first:
                output += escape_color(fg=color_bg, bg="-")
                output += SEPARATOR_SEGMENT_LEFT
            elif index <= center:
                output += escape_color(fg=color_bg)
                output += SEPARATOR_SEGMENT_LEFT
            elif index > center:
                output += escape_color(bg=color_bg)
                output += SEPARATOR_SEGMENT_RIGHT

            # draw text
            output += escape_color(fg=tag[0]["color_fg"], bg=color_bg)
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    output += escape_color(fg=COLOR_SEP)
                    if index <= center:
                        output += SEPARATOR_PATH_LEFT
                    else:
                        output += SEPARATOR_PATH_RIGHT
                    output += escape_color(fg=t["color_fg"])
                output += t["text"]

            # draw end (separator)
            output += escape_color(fg=color_bg)
            if last:
                output += escape_color(bg="-")
                output += SEPARATOR_SEGMENT_RIGHT
                output += escape_color(fg="-", bg="-")

        elif position == POSITION_RIGHT:
            # draw separator
            output += escape_color(fg=color_bg)
            if first:
                output += escape_color(bg="-")
            output += SEPARATOR_SEGMENT_LEFT

            # draw text
            output += escape_color(fg=tag[0]["color_fg"], bg=color_bg)
            for i, t in enumerate(tag):
                if i > 0:
                    # draw sub-separator
                    output += escape_color(fg=COLOR_SEP)
                    output += SEPARATOR_PATH_LEFT
                    output += escape_color(fg=t["color_fg"])
                output += t["text"]

            # draw end
            if last:
                output += escape_color(fg="-", bg="-")

    return output


def on_change_ws(i3, event):
    if event.change == 'focus' or \
            event.change == 'init' or event.change == 'empty':
        global renderer
        renderer.update_workspace(i3.get_workspaces())
        renderer.render()


def run():
    global renderer
    renderer = Renderer()
    renderer.start()

    # open i3 IPC socket
    i3 = i3ipc.Connection()
    i3.on("workspace", on_change_ws)
    renderer.update_workspace(i3.get_workspaces())

    i3_thread = threading.Thread(target=i3.main, daemon=True)
    i3_thread.start()

    try:
        # read header tags
        while True:
            _head = sys.stdin.readline()
            if _head == "":
                continue
            try:
                json.loads(_head)
            except json.decoder.JSONDecodeError as e:
                fprint_nb(sys.stderr,
                          "Error parsing JSON Header: " + e.msg + "\n")
                sys.exit(1)
            finally:
                break

        # read opening tag
        while True:
            _start = sys.stdin.readline()
            if _start == "":
                continue
            if _start == "[\n":
                break

        while True:
            _line = sys.stdin.readline()
            if _line == "":
                continue
            if _line.startswith(","):
                _line = _line[1:]

            try:
                obj = json.loads(_line)
                renderer.update_status(obj)
                renderer.render()
            except json.decoder.JSONDecodeError as e:
                fprint_nb(sys.stderr,
                          "Error decoding JSON: " + e.msg + "\n")

    except KeyboardInterrupt:
        print()
    finally:
        i3.main_quit()

if __name__ == '__main__':
    run()
