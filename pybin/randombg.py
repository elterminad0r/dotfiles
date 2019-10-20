#!/usr/bin/env python3

#                             .___               ___.       ____
# _______ _____     ____    __| _/ ____    _____ \_ |__    / ___\
# \_  __ \\__  \   /    \  / __ | /  _ \  /     \ | __ \  / /_/  >
#  |  | \/ / __ \_|   |  \/ /_/ |(  <_> )|  Y Y  \| \_\ \ \___  /
#  |__|   (____  /|___|  /\____ | \____/ |__|_|  /|___  //_____/
#              \/      \/      \/              \/     \/
# FIGMENTIZE: randombg

"""
Stateful random background setter

This is a python script that uses feh to set the background on a computer
running X. It keeps track of a "stack" of previous backgrounds, which it can
traverse, so strictly speaking it's a list.
"""

# TODO add option for a literal path
# TODO add command line options for wallpaper directory, stack location, max
#      stack size

import os
import sys
import pickle
import collections
import random
import subprocess
import pathlib
import shutil

import smartparse as argparse

import gi
gi.require_version('Notify', '0.7')
from gi.repository import Notify
Notify.init("backgrounds")

WALLPAPERS = pathlib.Path.home() / "Pictures" / "wallpapers"
if os.getenv("XDG_CACHE_HOME"):
    CACHE_HOME = pathlib.Path(os.getenv("XDG_CACHE_HOME"))
else:
    CACHE_HOME = pathlib.Path.home() / ".cache"
STACK = CACHE_HOME / "randombg" / "stack.pickle"
MAX_STACK = 100

def ensure_cache():
    """
    Ensure an appropriate directory to write the cache file to exists.
    """
    if not STACK.exists():
        Notify.Notification.new(
                "randombg",
                "Creating {!s}".format(stack))
    STACK.parent.mkdir(parents=True, exist_ok=True)
    return STACK

class BackgroundStack:
    """
    The Stack object keeps track of previous backgrounds and is responsible for
    cycling to new ones, or revisiting previous ones.

    This object is persisted to a pickle file, so isn't initialised very often.

    Uses lots of gobject notifications, as I like to put this script in a cron
    job, so feedback has to be communicated graphically.
    """
    def __init__(self):
        """
        Set attributes and set the first background.. The actual stack is
        handled entirely through a deque, which has functionality to limit size.
        """
        self.stack = collections.deque(maxlen=MAX_STACK)
        self.cycling = True
        self.random_bg()

    def set_bg(self, choice):
        """
        Set the background to a particular file using feh.
        """
        if not isinstance(choice, pathlib.Path):
            notif = Notify.Notification.new(
                    "randombg",
                    "Your cache is out of date - not using pathlib")
            notif.set_urgency(Notify.Urgency.CRITICAL)
            notif.show()
            print("Cache out of date", file=sys.stderr)
            sys.exit(1)
        else:
            if shutil.which("feh"):
                Notify.Notification.new(
                        "randombg",
                        "{} (s:{})".format(choice, self.pos)).show()
                subprocess.call(
                        ["feh", "--bg-scale", choice])
            else:
                notif = Notify.Notification.new(
                        "randombg",
                        "Feh executable not present")
                notif.set_urgency(Notify.Urgency.CRITICAL)
                notif.show()
                print("No feh executable", file=sys.stderr)
                sys.exit(1)

    def random_bg(self):
        """
        Choose a random background to set.
        """
        # TODO: prevent repetition
        if self.cycling:
            choice = random.choice(list(WALLPAPERS.iterdir()))
            self.stack.append(choice)
            self.pos = len(self.stack) - 1
            self.set_bg(choice)
        else:
            Notify.Notification.new("randombg", "cycling is off").show()

    def toggle_cycle(self):
        """
        Turn cycling on or off>
        """
        self.cycling = not self.cycling
        Notify.Notification.new("randombg", "cycling set to {}"
                .format(self.cycling)).show()

    def prev_bg(self):
        """
        Revisit previous background (making sure not to IndexError)
        """
        if self.pos > 0:
            self.pos -= 1
            self.set_bg(self.stack[self.pos])
        else:
            Notify.Notification.new("randombg", "stack underflow").show()

    def next_bg(self):
        """
        Climb back up the stack. Only applicable after a call to prev_bg.
        """
        if self.pos < len(self.stack) - 1:
            self.pos += 1
            self.set_bg(self.stack[self.pos])
        else:
            Notify.Notification.new("randombg", "stack overflow").show()

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    action = parser.add_mutually_exclusive_group(required=True)
    action.add_argument("--random", action="store_true",
            help="choose random next background and move to top of stack")
    action.add_argument("--toggle", action="store_true",
            help="toggle cycling")
    action.add_argument("--next", action="store_true",
            help="move to next background in stack")
    action.add_argument("--prev", action="store_true",
            help="move to previous background in stack")
    action.add_argument("--init", action="store_true",
            help="initialise the background stack")
    return parser.parse_args()

if __name__ == "__main__":
    args = get_args()
    if args.init:
        stack = BackgroundStack()
        with ensure_cache().open("wb") as stackfile:
            pickle.dump(stack, stackfile)
    else:
        try:
            with ensure_cache().open("rb") as stackfile:
                stack = pickle.load(stackfile)
        # TODO: just make this automatic
        except Exception:
            print("ERROR: you may need to initialise with --init\n\n")
            raise
        if args.random:
            stack.random_bg()
        elif args.toggle:
            stack.toggle_cycle()
        elif args.prev:
            stack.prev_bg()
        elif args.next:
            stack.next_bg()
        else:
            print("unimplemented option")

        with ensure_cache().open("wb") as stackfile:
            pickle.dump(stack, stackfile)
