#!/usr/bin/env python3

# ___.                    .__                 .__   .__
# \_ |__  _____     ______|__|  ____  _____   |  |  |  |  ___.__.
#  | __ \ \__  \   /  ___/|  |_/ ___\ \__  \  |  |  |  | <   |  |
#  | \_\ \ / __ \_ \___ \ |  |\  \___  / __ \_|  |__|  |__\___  |
#  |___  /(____  //____  >|__| \___  >(____  /|____/|____// ____|
#      \/      \/      \/          \/      \/             \/
# FIGMENTIZE: basically

"""
Simple base conversion functions. Also a command-line interface to do base
conversion from stdin to stdout.

Throughout, I use while loops instead of recursion because of Python's lack of
tail call optimisation.

The internally used integer sequence representation of radices prefers
little-endian, as this ensures we don't have to do any arithmetic with the
length of the sequence, which I think makes for cleaner-looking functions.

It doesn't to much error checking. By default, it considers the digits 0-9, A-Z,
a-z as having values 0-61. It ignores unknown digits and digits that are too
high for the given base.

Everything is assumed to operate on the non-negative integers.
"""

import sys
import string

STANDARD_DIGITS = "{}{}{}".format(string.digits,
                                  string.ascii_uppercase,
                                  string.ascii_lowercase)
STANDARD_DIGIT_LOOKUP = {char: ind for ind, char in enumerate(STANDARD_DIGITS)}

def from_base_ints(num, base):
    """
    Convert `num`, a (little-endian) sequence of integers (representing the
    digits of number in base `base`) into a Python integer.
    """
    value = 0
    place_value = 1
    for digit in num:
        value += digit * place_value
        place_value *= base
    return value

def from_base_ints_big(num, base):
    """
    Convert `num`, a (big-endian) sequence of integers (representing the
    digits of number in base `base`) into a Python integer. This happens to be
    more efficient to implement this way as well, as it can be done without
    simply reversing the input (which might undesirably consume the whole
    iterable and over-allocate memory before starting computation).
    """
    value = 0
    for digit in num:
        value *= base
        value += digit
    return value

def to_base_ints(num, base):
    """
    Convert `num`, a Python integer, to a little-endian sequence of integers
    representing digits in base `base`. There are no leading zeroes except for
    the special case in which `num` is 0.
    """
    if not num:
        yield 0
    while num:
        num, r = divmod(num, base)
        yield r

def get_digits(num, base, digits):
    """
    Read digits from a string, discarding unknown or oversized digital values.
    """
    for c in num:
        if c in digits:
            value = digits[c]
            if value < base:
                yield value

def from_base(num, base, digits=STANDARD_DIGIT_LOOKUP):
    """
    Convert `num`, a (big-endian) string in base `base` with digit values
    defined by a mapping `digits`, to a Python integer. To make it case
    insensitive, call str.upper() on num.

    Ignores any characters not in `digits`.
    """
    return from_base_ints_big(get_digits(num, base, digits), base)

def to_base(num, base, digits=STANDARD_DIGITS):
    """
    Convert `num`, a Python integer, to a big-endian string in base `base` with
    digit values defined by a mapping `digits`.
    """
    return "".join(digits[d] for d in to_base_ints(num, base))[::-1]

def get_args():
    """
    Parse command line arguments
    """
    import smartparse as argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("from_base", type=int,
            help="Base of the string in stdin")
    parser.add_argument("to_base", nargs="?", type=int, default=10,
            help="Base of the string to output to stdout")
    return parser.parse_args()

if __name__ == "__main__":
    args = get_args()
    print(to_base(from_base(sys.stdin.read(), args.from_base), args.to_base))
