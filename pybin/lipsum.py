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

from itertools import islice, cycle, repeat, chain

LIPSUM_DIR = pathlib.Path.home() / "fun" / "lists" / "lipsum"
PASTA_DIR = pathlib.Path.home() / "fun" / "lists" / "pasta"

class PastaHashable:
    """
    Class that implements methods to allow argparse to test for membership after
    applying a type, so we can use type= and choices= simultaneously. Also wraps
    the file object protocols I need, which is just iteration.
    """
    REGISTRY = {
            "gamers": PASTA_DIR / "they_targeted_gamers.txt",
            "gnu/linux": PASTA_DIR / "gnu_linux.txt",
            "gnu/linux2": PASTA_DIR / "gnu_linux_2.txt"}

    def __init__(self, value):
        self.value = value
        if value in self.REGISTRY:
            self.file = self.REGISTRY[value].open("r")
        else:
            # don't directly raise an error, rather let the parser do that
            self.file = None

    def __hash__(self):
        return hash(self.value)

    def __eq__(self, other):
        return self.file is not None and self.value == other

    def __repr__(self):
        return repr(self.value)

    def __iter__(self):
        return self.file


def get_args():
    """
    Parse argv
    """
    import smartparse as argparse

    parser = argparse.ArgumentParser(description=__doc__)
    file_group = parser.add_mutually_exclusive_group()
    # important that this argument goes first so the default gets triggered
    file_group.add_argument("-f", "--file", type=argparse.FileType("r"),
            default=str(LIPSUM_DIR / "lipsum.txt"),
            help="File to read paragraphs from, spaced with empty lines")
    file_group.add_argument("-s", "--shakespeare", action="store_const",
            const=(LIPSUM_DIR / "shakespeare.txt").open("r"), dest="file",
            help="Print lines from the complete works of Shakespeare")
    file_group.add_argument("-p", "--pasta", type=PastaHashable,
            choices=PastaHashable.REGISTRY, dest="file",
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
