#!/usr/bin/env python3

#                 .__      ____
# _____________   |  |    / ___\  ____
# \___   /\__  \  |  |   / /_/  >/  _ \
#  /    /  / __ \_|  |__ \___  /(  <_> )
# /_____ \(____  /|____//_____/  \____/
#       \/     \/
# FIGMENTIZE: zalgo

"""
Making scary looking "zalgo" text.

Unbuffering will require Python 3.7.
"""

import sys

import smartparse as argparse

from random import gauss, choice

# from http://www.alanwood.net/unicode/combining_diacritical_marks.html,
#      https://en.wikipedia.org/wiki/Combining_Diacritical_Marks

combining = [chr(i) for i in range(0x0300, 0x036F + 1)]

# set for membership testing
combining_set = set(combining)

def _zalgo(s, mean, sd):
    """
    Zalgo encode a string, given the parameters to the normal distribution from
    which we sample the number of combining diacritical marks to add to any
    given character. Negatives round up to 0. Only add diacritics to
    alphanumeric characters.
    """
    for c in s:
        yield c
        # better to use isalnum than any kind of whitelist because it knows
        # better about multilingual characters
        if c.isalnum():
            for _ in range(int(0.5 + gauss(mean, sd))):
                yield choice(combining)

def zalgo(*args, **kwargs):
    """
    Wrapper around _zalgo to get back a string
    """
    return "".join(_zalgo(*args, **kwargs))

def _unzalgo(s):
    """
    Strip all combining diacritical marks from a string. This is packaged as
    "unzalgoing" although it might strip a little more if you've got
    multilingual text. However combining diacritical marks are really a fairly
    niche type of character so not a big worry.
    """
    for c in s:
        if c not in combining_set:
            yield c

def unzalgo(*args, **kwargs):
    """
    Wrapper around _unzalgo to get back a string
    """
    return "".join(_unzalgo(*args, **kwargs))

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mean", type=float, nargs="?", default=-1.0,
            help="""The mean of the normal distribution of the number of
                    diacritics added for each character""")
    parser.add_argument("sd", type=float, nargs="?", default=5.0,
            help="""The standard deviation of the normal distribution of the
                    number of diacritics added for each character""")
    parser.add_argument("-r", "--revert", action="store_true",
            help="Strip diacritical marks instead of adding them")
    parser.add_argument("-u", "--unbuffered", action="store_true",
            help="Reconfigure I/O objects to use line buffering")
    return parser.parse_args()

def do_zalgo(mean, sd, in_file, out_file):
    """
    Zalgo-ify a file
    """
    for line in in_file:
        out_file.write(zalgo(line, mean, sd))

def do_unzalgo(in_file, out_file):
    """
    Unzalgo-ify a file
    """
    for line in in_file:
        out_file.write(unzalgo(line))

if __name__ == "__main__":
    args = get_args()
    if args.unbuffered:
        sys.stdout.reconfigure(line_buffering=True)
    if args.revert:
        do_unzalgo(sys.stdin, sys.stdout)
    else:
        do_zalgo(args.mean, args.sd, sys.stdin, sys.stdout)
