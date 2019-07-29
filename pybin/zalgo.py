#!/usr/bin/env python3

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

combining = [
    "\u0300", "\u0301", "\u0302", "\u0303", "\u0304", "\u0305", "\u0306",
    "\u0307", "\u0308", "\u0309", "\u030A", "\u030B", "\u030C", "\u030D",
    "\u030E", "\u030F", "\u0310", "\u0311", "\u0312", "\u0313", "\u0314",
    "\u0315", "\u0316", "\u0317", "\u0318", "\u0319", "\u031A", "\u031B",
    "\u031C", "\u031D", "\u031E", "\u031F", "\u0320", "\u0321", "\u0322",
    "\u0323", "\u0324", "\u0325", "\u0326", "\u0327", "\u0328", "\u0329",
    "\u032A", "\u032B", "\u032C", "\u032D", "\u032E", "\u032F", "\u0330",
    "\u0331", "\u0332", "\u0333", "\u0334", "\u0335", "\u0336", "\u0337",
    "\u0338", "\u0339", "\u033A", "\u033B", "\u033C", "\u033D", "\u033E",
    "\u033F", "\u0340", "\u0341", "\u0342", "\u0343", "\u0344", "\u0345",
    "\u0346", "\u0347", "\u0348", "\u0349", "\u034A", "\u034B", "\u034C",
    "\u034D", "\u034E", "\u034F", "\u0350", "\u0351", "\u0352", "\u0353",
    "\u0354", "\u0355", "\u0356", "\u0357", "\u0358", "\u0359", "\u035A",
    "\u035B", "\u035C", "\u035D", "\u035E", "\u035F", "\u0360", "\u0361",
    "\u0362", "\u0363", "\u0364", "\u0365", "\u0366", "\u0367", "\u0368",
    "\u0369", "\u036A", "\u036B", "\u036C", "\u036D", "\u036E", "\u036F"]

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
            for _ in range(int(gauss(mean, sd))):
                yield choice(combining)

def zalgo(*args, **kwargs):
    """
    Wrapper around _zalgo to get back a string
    """
    return "".join(_zalgo(*args, **kwargs))

def _unzalgo(s):
    """
    Strip all combining diacritical marks from a string. This is packages as
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
    parser.add_argument("mean", type=float, nargs="?", default=10.0,
            help="""The mean of the normal distribution of the number of
                    diacritics added for each character""")
    parser.add_argument("sd", type=float, nargs="?", default=2.0,
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
