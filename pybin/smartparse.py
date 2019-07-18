#                                   __
#   ______  _____  _____  _______ _/  |_ ______ _____  _______  ______  ____
#  /  ___/ /     \ \__  \ \_  __ \\   __\\____ \\__  \ \_  __ \/  ___/_/ __ \
#  \___ \ |  Y Y  \ / __ \_|  | \/ |  |  |  |_> >/ __ \_|  | \/\___ \ \  ___/
# /____  >|__|_|  /(____  /|__|    |__|  |   __/(____  /|__|  /____  > \___  >
#      \/       \/      \/               |__|        \/            \/      \/
# FIGMENTIZE: smartparse

"""
smartparse: modifications to argparse that allow proper paragraph splitting
while still wrapping properly, and also including defaults by default. Inspired
by my frustrations and [1].

Be careful as this does rely on implementation details.

Also provides some other useful little utilities like a function to parse a
number argument and check it is in an appropriate range, and an enum that can be
used with the choices kwarg.

[1]: https://stackoverflow.com/questions/3853722/python-argparse-how-to-insert-newline-in-the-help-text
"""

import argparse
from argparse import *
# Basically because I needed access to _HelpAction somewhere. Probably best to
# think of a better solution to this but oh well
from argparse import _HelpAction

import enum
import re
import math
import textwrap

def ArgumentParser(*args, **kwargs):
    """
    Wrap ArgumentParser, providing the custom help formatter.
    """
    return argparse.ArgumentParser(*args, **kwargs,
                           formatter_class=SmartFormatter)

class SmartFormatter(ArgumentDefaultsHelpFormatter):
    """
    Formatter class that fixes the paragraph formatting, whiel still respecting
    the width.
    """
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._whitespace_matcher = re.compile(" +", re.ASCII)

    def _fill_text(self, text, width, indent):
        text = self._whitespace_matcher.sub(' ', text).strip()
        return "\n\n".join(textwrap.fill(paragraph, width,
                                         initial_indent=indent,
                                         subsequent_indent=indent)
                           for paragraph in text.split("\n\n"))

class APEnum(enum.Enum):
    """
    Allow argparse arguments to be Enums. Lets you do things like

    >>> parser.add_argument('some_val', type=SomeEnum.argparse, choices=list(SomeEnum))

    Built on from
    https://stackoverflow.com/a/55500795/5468953
    """
    def __str__(self):
        return self.name.lower()

    def __repr__(self):
        return str(self)

    @classmethod
    def argparse(cls, s):
        try:
            return cls[s.upper()]
        except KeyError:
            return s

def num_in_range(lower=-math.inf, upper=math.inf,
                 lower_inclusive=True, upper_inclusive=False, num_type=int):
    """
    Parse a number. By default, parses like an integer, but you can pass the
    num_type argument to use a float or a Fraction, or anything that understands
    comparisons with the lower and upper arguments, which are -∞ and ∞ by
    default.

    The range is inclusive on the lower bound, and exclusive on the upper bound,
    like Python's range(), by default although that can be modified by the
    lower_inclusive and upper_inclusive arguments.
    """
    def ranged_num(s):
        val = num_type(s)
        if not ((lower <= val if lower_inclusive else lower < val) and
                (val <= upper if upper_inclusive else val < upper)):
            raise ValueError("{} is not in the range {}{}, {}{}".format(
                val,
                "[" if lower_inclusive else "(",
                lower, upper,
                "]" if upper_inclusive else ")"))
        return val
    return ranged_num

if __name__ == "__main__":
    class MyEnum(APEnum):
        ONE = enum.auto()
        TWO = enum.auto()
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("number", type=MyEnum.argparse, choices=list(MyEnum))
    parser.add_argument("--rating", type=num_in_range(1, 11), default=20,
            help="How much you like this program on a scale of 1-10")
    args = parser.parse_args()
    print("you picked: {}".format(args.number))
    print("you rated this program at {}/{}".format(args.rating, 10))
