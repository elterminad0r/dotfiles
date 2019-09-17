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

from itertools import islice, cycle, repeat, chain

LIPSUM_DIR = pathlib.Path.home() / "fun" / "lists" / "lipsum"
PASTA_DIR = pathlib.Path.home() / "fun" / "lists" / "pasta"

PASTA_REGISTRY = {
        "gamers": PASTA_DIR / "they_targeted_gamers.txt",
        "gnu/linux": PASTA_DIR / "gnu_linux.txt",
        "gnu/linux2": PASTA_DIR / "gnu_linux_2.txt"}

def pasta_factory(s):
    """
    Wrapper to convert short nicknames to filenames. Can't use argparse choices
    because it should match the type of the value of the argument.
    """
    try:
        return PASTA_REGISTRY[s].open("r")
    except KeyError:
        raise ValueError("Invalid pasta {!r}, choose one of {}".format(
                s, list(PASTA_REGISTRY)))

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    file_group = parser.add_mutually_exclusive_group()
    # important that this argument goes first so the default gets triggered
    file_group.add_argument("-f", "--file", type=argparse.FileType("r"),
            default=str(LIPSUM_DIR / "lipsum.txt"),
            help="File to read paragraphs from, spaced with empty lines")
    file_group.add_argument("-s", "--shakespeare", action="store_const",
            const=(LIPSUM_DIR / "shakespeare.txt").open("r"), dest="file",
            help="Print lines from the complete works of Shakespeare")
    file_group.add_argument("-p", "--pasta", type=pasta_factory, dest="file",
            help="Use a copypasta")
    parser.add_argument("paragraphs", type=int, nargs="?", default=5,
            help="""Number of paragraphs to generate. A negative integer `-n` is
                    taken to mean "n copies of the whole file".""")
    return parser.parse_args()

def get_paragraphs(file):
    """
    Try to intelligently split up paragraphs from a file
    """
    paragraph_body = []
    paragraph_post = []
    for line in file:
        if line.rstrip("\n"):
            if not paragraph_post:
                paragraph_body.append(line)
            else:
                yield "{}{}".format("".join(paragraph_body),
                                    "".join(paragraph_post))
                paragraph_body = [line]
                paragraph_post = []
        else:
            paragraph_post.append(line)
    yield "{}{}\n".format("".join(paragraph_body), "".join(paragraph_post))

def lipsum(file, paragraphs):
    """
    Generate paragraphs, starting back at the beginning if necessary. Follows
    the semantics detailed in the arguments.
    """
    if paragraphs < 0:
        # have to force the file into a persistent data structure here. Add a
        # newline for good measure
        lines = chain.from_iterable(repeat([*file, "\n"], abs(paragraphs)))
    else:
        lines = islice(cycle(get_paragraphs(file)), paragraphs)
    for line in lines:
        sys.stdout.write(line)

if __name__ == "__main__":
    args = get_args()
    lipsum(**vars(args))
