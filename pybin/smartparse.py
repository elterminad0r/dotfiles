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

[1]: https://stackoverflow.com/questions/3853722/python-argparse-how-to-insert-newline-in-the-help-text
"""

import argparse
from argparse import *
import enum
import re
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

class APEnumBase:
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

class APEnum(APEnumBase, enum.Enum):
    pass

if __name__ == "__main__":
    class MyEnum(APEnum):
        ONE = enum.auto()
        TWO = enum.auto()
    parser = ArgumentParser(description=__doc__)
    parser.add_argument("number", type=MyEnum.argparse, choices=list(MyEnum))
    args = parser.parse_args()
    print("you picked: {}".format(args.number))
