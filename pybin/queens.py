#!/usr/bin/env python3

#   ______ __ __   ____   ____    ____    ______
#  / ____/|  |  \_/ __ \_/ __ \  /    \  /  ___/
# < <_|  ||  |  /\  ___/\  ___/ |   |  \ \___ \
#  \__   ||____/  \___  >\___  >|___|  //____  >
#     |__|            \/     \/      \/      \/
# FIGMENTIZE: queens

"""
The "n queens" problem in Python - how many ways are there to fit n queens on an
n by n chessboard, such that no pair of queens attacks one another?
"""

import smartparse as argparse

from itertools import islice

# Uses the standard backtracking algorithm. Also, as no two queens may be on the
# same row (or column) we can simply track all the queens with a list of length
# n, containing their y coordinates (where the index in the list corresponds to
# x coordinate).

# TODO: facilities for only generating one board,
# TODO: more efficient algorithms (depth-first permutations)
# TODO: Use random starting permutation to avoid worst case (?)

def constrain_queen(queen_y, queens, length):
    """
    Check if a new queen does not attack any other queens already present.

    Uses the fact that the diagonals a queen can move along are defined
    precisely by having x ± y invariant.
    """
    return (queen_y not in islice(queens, length) and
            queen_y - length not in
                     islice((y - x for x, y in enumerate(queens)), length) and
            queen_y + length not in
                     islice((y + x for x, y in enumerate(queens)), length))

def _get_queens(n, queens, length):
    """
    Perform one level of backtracking to solve the problem for n = `n`, with the
    queens `queens` already in position, of which there are `length`.

    Written so as to be as fast as possible - shouldn't be doing much array
    reallocating, for example. Only ever uses one list, to which it yields
    references (so it keeps yielding the same reference). If you need a deep
    copy, make one.
    """
    if length == n:
        yield queens
    else:
        for queen_y in range(n):
            if constrain_queen(queen_y, queens, length):
                queens[length] = queen_y
                yield from _get_queens(n, queens, length + 1)

def get_queens(n):
    """
    Get all boards for the n queens problem. Thinly wraps _get_queens.
    """
    yield from _get_queens(n, [None] * n, 0)

def format_board(n, queens):
    """
    Make a string showing the n by n board described by the queen positions
    "queens"
    """
    return "\n".join(" ".join("Q" if i == queen else "_" for i in range(n))
                     for queen in queens)

def display_solutions(n):
    """
    Dump all solutions to stdout
    """
    total = 0
    for queens in get_queens(n):
        total += 1
        print("{}\n".format(format_board(n, queens)))
    print("{} total".format(total))

def get_args():
    """
    Parse argv
    """
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("n", type=int, nargs="?", default=8,
            help="Board size")
    return parser.parse_args()

if __name__ == "__main__":
    display_solutions(**vars(get_args()))
