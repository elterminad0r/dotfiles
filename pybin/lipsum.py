#!/usr/bin/env python3

# .__   .__
# |  |  |__|______   ______ __ __   _____
# |  |  |  |\____ \ /  ___/|  |  \ /     \
# |  |__|  ||  |_> >\___ \ |  |  /|  Y Y  \
# |____/|__||   __//____  >|____/ |__|_|  /
#           |__|        \/              \/
# FIGMENTIZE: lipsum

"""
Generating lorem ipsum text from some appropriately formatted file, by default
~/fun/lists/lipsum/lipsum.txt. Doesn't do any text wrapping - see utilities like
"fold" and "fmt".
"""

# TODO: count by sentences

import sys
import pathlib

import smartparse as argparse

from itertools import islice, cycle

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("-f", "--file", type=argparse.FileType("r"),
            default=str(pathlib.Path.home() /
                    "fun" / "lists" / "lipsum" / "lipsum.txt"),
            help="""File to read paragraphs from, one per line, spaced with
                    empty lines""")
    parser.add_argument("paragraphs", type=int, nargs="?", default=5,
            help="Number of paragraphs to generate")
    return parser.parse_args()

def lipsum(file, paragraphs):
    """
    Generate paragraphs, starting back at the beginning if necessary
    """
    for line in islice(cycle(file), paragraphs * 2 - 1):
        sys.stdout.write(line)

if __name__ == "__main__":
    args = get_args()
    lipsum(**vars(args))
