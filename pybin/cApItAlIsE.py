#!/usr/bin/env python3

"""
CaPiTaLiSaTiOn framework
"""

class CaPiTaLiSeR:
    """
    Object that tracks case state. One should not that it is still possible to
    distinguish between the class CaPiTaLiSeR and a cApItAlIsEr instance, using
    case conventions.
    """
    def __init__(self, make_upcase=False):
        """
        Pass in True to start on an uppercase letter
        """
        self.make_upcase = make_upcase

    def _process(self, s):
        """
        Process an iterable, returning a generator of characters
        """
        for c in s:
            if c.isalpha():
                if self.make_upcase:
                    yield c.upper()
                else:
                    yield c.lower()
                self.make_upcase = not self.make_upcase
            else:
                yield c

    def process(self, s):
        """
        Process a string into a string
        """
        return "".join(self._process(s))
