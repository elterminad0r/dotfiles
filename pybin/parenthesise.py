#!/usr/bin/env python3

#    ___                                              ___
#   /  /______ _____  _______   ____    ____    ______\  \
#  /  / \____ \\__  \ \_  __ \_/ __ \  /    \  /  ___/ \  \
# (  (  |  |_> >/ __ \_|  | \/\  ___/ |   |  \ \___ \   )  )
#  \  \ |   __/(____  /|__|    \___  >|___|  //____  > /  /
#   \__\|__|        \/             \/      \/      \/ /__/
# FIGMENTIZE: (parens)

"""
Parenthesising sequences. Inspired by the question about associative operators
from the Cambridge 1A Groups Introductory Examples Sheet.
"""

from itertools import product, chain
from functools import reduce
from operator import mul

DEFAULT_OPERATOR = " \u2219 "

def _parenthesise(lo, hi):
    """
    Yield all parenthesisations of the sequence from lo to hi - 1, inclusive.

    Parenthesisations represented as nested tuples. Each tuple has length 2, or
    length 1 if it represents a "base case" lowest level element.
    """
    if hi - lo <= 1:
        yield tuple(range(lo, hi))
    yield from chain.from_iterable(
                product(_parenthesise(lo, n),
                        _parenthesise(n, hi)) for n in range(lo + 1, hi))

def parenthesise(n):
    """
    Wrapper to just give the n-th order bracketing, starting at 1.
    """
    yield from _parenthesise(1, n + 1)

def fmt_parens(parens, operator=DEFAULT_OPERATOR):
    """
    Format a parenthesisation a little more nicely.

    Even though this script never fails to pass a value for operator, keep the
    sensible default for the likely event of other associativity fans wanting to
    reuse code.
    """
    if len(parens) == 1:
        return str(parens[0])
    return "({l}{o}{r})".format(l=fmt_parens(parens[0], operator),
                                r=fmt_parens(parens[1], operator),
                                o=operator)

def display_parens(n, operator=DEFAULT_OPERATOR):
    """
    Display parenthesisations of length n
    """
    total = 0
    for parens in parenthesise(n):
        print(fmt_parens(parens, operator))
        total += 1
    print("total: {} (expecting {})".format(total, predict_number(n)))

def dp_predict_number(n):
    """
    Count the number of bracketings, but make it snappy. Dynamic approach.
    This could even cache between calls, but that's rather overkill considering
    how slow all the other things here are (and that this is faster calculated
    combinatorially).
    """
    previous = [0, 1, 1]
    for m in range(3, n + 1):
        if m & 1:
            previous.append(2 * sum(previous[k] * previous[m - k]
                                    for k in range(1, m // 2 + 1)))
        else:
            previous.append(2 * sum(previous[k] * previous[m - k]
                                    for k in range(1, m // 2))
                          + previous[m // 2] ** 2)
    return previous[n]

def elem_prod(it):
    """
    Conventional product of the elements of an iterable
    """
    return reduce(mul, it, 1)

def predict_number(n):
    """
    Return the Catalan number corresponding to the bracketing problem of order
    n. Even faster than predict_number.
    """
    return elem_prod(range(n + 1, 2 * n - 1)) // elem_prod(range(1, n))

def get_args():
    """
    Parse argv
    """
    import smartparse as argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("n", type=int, nargs="?", default=5,
            help="Order of bracketing to produce")
    parser.add_argument("operator", nargs="?", default=DEFAULT_OPERATOR,
            help="Operator to format bracketings with. Can be empty.")
    calc_action = parser.add_mutually_exclusive_group()
    calc_action.add_argument("--predict", action="store_true",
            help="Only calculate the number, do not show them all.")
    calc_action.add_argument("--dp-predict", action="store_true",
            help="Only calculate the number with DP, do not show them all.")
    return parser.parse_args()

if __name__ == "__main__":
    args = get_args()
    if args.predict:
        print(predict_number(args.n))
    elif args.dp_predict:
        print(dp_predict_number(args.n))
    else:
        display_parens(args.n, args.operator)
