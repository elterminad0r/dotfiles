#!/usr/bin/env python3

#                         .__
# _______   ____  ______  |  |  _____     ____   ____         ____  _____     ______  ____
# \_  __ \_/ __ \ \____ \ |  |  \__  \  _/ ___\_/ __ \      _/ ___\ \__  \   /  ___/_/ __ \
#  |  | \/\  ___/ |  |_> >|  |__ / __ \_\  \___\  ___/      \  \___  / __ \_ \___ \ \  ___/
#  |__|    \___  >|   __/ |____/(____  / \___  >\___  >______\___  >(____  //____  > \___  >
#              \/ |__|               \/      \/     \//_____/    \/      \/      \/      \/
# FIGMENTIZE: replace_case

# TODO

"""
Script to replace a (Python) regular expression with some word, performing some
operation on the case of the replacement text. The default behaviour is to copy
the case of the match, and if the replacement is longer than the match, carry on
with the case of the last letter. It can be configured to use different
algorithms past the last letter, or to not copy the case at all.

I've seen
https://unix.stackexchange.com/questions/125694/case-matching-pattern-replacement-with-sed
but I'm not clever enough to understand what's going on, and I'd like a script I
understand so that I can modify/improve it etc.
"""

import re
import enum

import smartparse as argparse

class CB(enum.Enum):
    """
    Capitalisation Behaviour: Enum specifying capitalisation behaviour.
    """
    FOLLOW = enum.auto()
    SWITCH = enum.auto()
    UPPER = enum.auto()
    LOWER = enum.auto()
    TITLE = enum.auto()

class PB(enum.Enum):
    """
    Punctuation Behaviour: Enum specifying how the case of punctuation should be
    interpreted.
    """
    IGNORE = enum.auto()
    UPPER = enum.auto()
    LOWER = enum.auto()
    FOLLOW = enum.auto()
    SWITCH = enum.auto()

def case_iterator(match, behaviour):
    if behaviour & CB.COPY:
        if behaviour & CB.FOLLOW:
            return

def set_case(match, repl, behaviour):
    if behaviour & CB.COPY:
        if behaviour == CB.COPY_CYCLE:
            pass

def make_repl(pat, behaviour):
    def repl(match):
        repl_string = match.expand(pat)
    return repl, called
