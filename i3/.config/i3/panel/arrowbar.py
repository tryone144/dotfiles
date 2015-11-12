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
# v0.5 / 2015.11.11
#

import argparse
import i3ipc
import json
import sys
import threading
import queue

from arrowbar_renderer import Renderer, fprint_nb


renderer = None
debug = False
callback = queue.Queue(10)
stop_event = threading.Event()


def on_change_ws(i3, event):
    if renderer is not None:
        if event.change in ('focus'):
            renderer.clear_title()
        renderer.update_workspace(i3.get_workspaces())
        thread_render()


def on_change_title(i3, event):
    if renderer is not None:
        if event.change in ('focus', 'title', 'urgent') \
                and event.container.focused:
            renderer.update_title(event.container)
            thread_render()
        elif event.change in ('close') and event.container.focused:
            renderer.clear_title()
            thread_render()


def on_change_output(i3, event):
    if renderer is not None:
        renderer.update_outputs(i3.get_outputs())
        thread_render()


def i3ipc_thread(use_ws=False, use_title=False):
    try:
        i3 = i3ipc.Connection()
        conf = i3.get_bar_config("status")

        if renderer is not None:
            if "outputs" in conf.keys():
                renderer.set_outputs(conf["outputs"])
            if use_ws:
                renderer.update_workspace(i3.get_workspaces())
            if use_title:
                renderer.clear_title()
            renderer.update_outputs(i3.get_outputs())
            thread_render()

        if use_ws:
            i3.on("workspace", on_change_ws)
        if use_title:
            i3.on("window", on_change_title)
        i3.on("output", on_change_output)
        i3.main()

        thread_die("connection to i3 lost.")
    except Exception as e:
        thread_die(exception=e)


def stdin_thread():
    try:
        # read header tags
        while True:
            _head = sys.stdin.readline()
            if _head == "":
                thread_die(quit_event, "stdin closed.")
            try:
                json.loads(_head)
            finally:
                break

        # read opening tag
        while True:
            _start = sys.stdin.readline()
            if _start == "":
                thread_die(quit_event, "stdin closed.")
            if _start[0] == "[":
                break

        # read contious status data
        while True:
            _line = sys.stdin.readline()
            if _line == "":
                thread_die(quit_event, "stdin closed.")
            if _line.startswith(","):
                _line = _line[1:]

            try:
                if renderer is not None:
                    renderer.update_status(json.loads(_line))
                    thread_render()
            except json.decoder.JSONDecodeError as e:
                fprint_nb(sys.stderr,
                          "Error decoding JSON: " + e.msg + "\n")
    except Exception as e:
        thread_die(exception=e)


def thread_die(msg="Thread stopped unexpectedly", exception=None):
    callback.put((die, [], {"msg": msg, "exception": exception}))


def thread_render():
    callback.put((renderer.render, [], {}))


def die(msg="program crashed", exception=None):
    if exception is not None:
        fprint_nb(sys.stderr, "Error: " + msg + "\n")
        if not debug:
            e = type(exception).__name__
            emsg = str(exception)
            fprint_nb(sys.stderr, e + ": " + emsg + "\n")
        else:
            raise exception
    else:
        if not debug:
            fprint_nb(sys.stderr, "Error: " + msg + "\n")
        else:
            raise RuntimeError(msg)

    stop_event.set()
    sys.exit(1)


def main(use_ws=False, use_title=False):
    global renderer
    global debug
    renderer = Renderer()

    # open i3 IPC socket
    i3_thread = threading.Thread(target=i3ipc_thread,
                                 kwargs={"use_ws": use_ws,
                                         "use_title": use_title},
                                 daemon=True)
    i3_thread.start()

    # start json parser
    status_thread = threading.Thread(target=stdin_thread,
                                     daemon=True)
    status_thread.start()

    try:
        while not stop_event.is_set():
            f, args, kwargs = callback.get()
            f(*args, **kwargs)
            callback.task_done()
    except KeyboardInterrupt:
        fprint_nb(sys.stderr, "Got KeyboardInterrupt. exiting...\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
            description="powerline-styled i3status-wrapper for lemonbar",
            add_help=True)
    parser.add_argument("-w", "--workspace", action="store_true",
                        default=False, help="Add workspace information")
    parser.add_argument("-t", "--title", action="store_true",
                        default=False, help="Add focused window title")
    parser.add_argument("--debug", action="store_true",
                        default=False, help="Show Tracebacks")
    args = parser.parse_args()

    debug = args.debug
    if debug:
        import cProfile
        cProfile.run("main(use_ws=" + str(args.workspace) + ", " +
                     "use_title=" + str(args.title) + ")")
        sys.exit(0)
    main(use_ws=args.workspace, use_title=args.title)
