#!/usr/bin/env python3

#   __   .__                            __          ___.    .__
# _/  |_ |__|  _____    ____    _______/  |_ _____  \_ |__  |  |    ____
# \   __\|  | /     \ _/ __ \  /  ___/\   __\\__  \  | __ \ |  |  _/ __ \
#  |  |  |  ||  Y Y  \\  ___/  \___ \  |  |   / __ \_| \_\ \|  |__\  ___/
#  |__|  |__||__|_|  / \___  >/____  > |__|  (____  /|___  /|____/ \___  >
#                  \/      \/      \/             \/     \/            \/
# FIGMENTIZE: timestable

"""
Print a times table

Basically I wrote this to see how rusty I was at illegible list comprehensions
and format constructs. It can be quite clever about how it sizes the table to
the terminal screen, as this isn't a straightforward function to invert.

TODO: use Grover's algorithm instead.
"""

import smartparse as argparse
import shutil

VERT = "│"
HORZ = "─"
CROS = "┼"
MULT = "×"

SCREEN_USAGE = 0.9, 0.8

def width(w, h):
    """
    The width of a times table from its dimensions
    """
    pad = len(str(w * h)) + 1
    return 2 + pad * (w + 1)

def make_size(ws, hs):
    """
    Reverse-engineer the dimensions of a times table from its size, using binary
    search, with a modification to first determine bounds.
    """
    h = hs - 2
    lw, uw = 1, 2
    while width(uw, h) < ws:
        lw, uw = uw, uw * 2
    while uw - lw > 1:
        mw = (lw + uw) // 2
        if width(mw, h) > ws:
            uw = mw
        else:
            lw = mw
    return lw, h

def timestable(w, h):
    """
    Print a `w` by `h` times table, which is nicely aligned and uses the GLOBAL
    CONSTANTS for table formatting.

    This function uses some nested f-strings, which are awesome and totally
    illegible. Go further at your own peril.
    """
    pad = len(str(w * h)) + 1
    xr = range(1, w + 1)
    yr = range(1, h + 1)
    print("{MULT:>{pad}} {VERT}{0}".format(
        "".join('{:>{pad}}'.format(x, pad=pad) for x in xr),
        pad=pad, MULT=MULT, VERT=VERT))
    print("{0:{HORZ}>{pad}}{HORZ}{CROS}{0:{HORZ}>{1}}".format(
            "", pad * w, HORZ=HORZ, pad=pad, CROS=CROS))
    for y in yr:
        print("{0:>{pad}} {VERT}{1}".format(
            y, "".join("{:>{pad}}".format(x * y, pad=pad) for x in xr),
            pad=pad, VERT=VERT))

def get_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-w", type=int, help="width of table")
    parser.add_argument("-l", type=int, help="height of table")
    return parser.parse_args()

def get_wh():
    """
    Decide what dimensions to use, based on input and terminal dimensions if
    available.
    """
    args = get_args()
    w, h = args.w, args.l
    ws, hs = map(lambda x, f: int(f * x),
            shutil.get_terminal_size(), SCREEN_USAGE)
    if args.w is None:
        if args.l is None:
            w, h = make_size(ws, hs)
        else:
            w, _ = make_size(ws, h + 2)
    elif args.l is None:
        h = hs - 2
    return w, h

if __name__ == "__main__":
    timestable(*get_wh())
