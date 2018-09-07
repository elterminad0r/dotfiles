"""
smartparse: modifications to argparse that allow proper paragraph splitting
while still wrapping properly, and also including defaults by default. Inspired
by my frustrations and [1].

Be careful as this does rely on implementation details.

[1]: https://stackoverflow.com/questions/3853722/python-argparse-how-to-insert-newline-in-the-help-text
"""

import argparse
#del argparse.__all__
from argparse import *
import re
import textwrap

_ArgumentParser = argparse.ArgumentParser

def ArgumentParser(*args, **kwargs):
    """
    Wrap ArgumentParser, providing the custom help formatter.
    """
    return _ArgumentParser(*args, **kwargs,
                           formatter_class=SmartFormatter)

class SmartFormatter(ArgumentDefaultsHelpFormatter):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._whitespace_matcher = re.compile(" +", re.ASCII)

    def _fill_text(self, text, width, indent):
        text = self._whitespace_matcher.sub(' ', text).strip()
        return "\n\n".join(textwrap.fill(paragraph, width,
                                         initial_indent=indent,
                                         subsequent_indent=indent)
                           for paragraph in text.split("\n\n"))