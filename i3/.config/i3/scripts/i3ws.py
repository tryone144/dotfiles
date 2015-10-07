#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
# I3WM
# Helper to get an i3bar compatible workspace list
#   needs: [i3ipc-python]
#
# file: ~/.config/i3/scripts/i3ws.py
# v0.1 / 2015.10.07
#

import i3ipc
import json
import sys
import signal

running = True


def print_nonblock(msg):
    sys.stdout.write(msg)
    sys.stdout.write("\n")
    sys.stdout.flush()


def gen_state(name, focused, output):
    state = {"name": "workspace",
             "instance": "ws-" + name + ":" + output,
             "full_text": name}
    if focused:
        state["color"] = "#00FF00"

    # TODO: check output
    return state


def on_change(i3, event):
    if (event.change == 'focus' or event.change == 'init' or
            event.change == 'empty') and running:
        print_nonblock("," + dump_ws(i3.get_workspaces()))


def dump_ws(workspaces):
    out = []
    for ws in workspaces:
        out.append(gen_state(ws.name, ws.focused, ws.output))

    return json.dumps(out)


def recv_sig(signum, frame):
    sys.stderr.write("==> GOT SIGNAL " + str(signum) + "\n")
    sys.stderr.flush()

    global running
    if signum == signal.SIGUSR1:
        running = False
    elif signum == signal.SIGUSR2:
        running = True


def run():
    # init signal handler
    signal.signal(signal.SIGUSR1, recv_sig)
    signal.signal(signal.SIGUSR2, recv_sig)

    # init infinite json-stream
    sys.stdout.write('{"version":1,"stop_signal":10,"cont_signal":12,"click_events":false}\n')
    sys.stdout.write('[\n')
    sys.stdout.flush()

    # open connection to i3
    i3 = i3ipc.Connection()

    # output initial state
    print_nonblock(dump_ws(i3.get_workspaces()))

    # register change handler
    i3.on('workspace', on_change)

    # start event loop
    try:
        i3.main()
    except KeyboardInterrupt:
        print()
    finally:
        print("]")
        i3.main_quit()

if __name__ == '__main__':
    run()
