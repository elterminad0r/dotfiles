#            _____           .___   __     _____   .__   .___         ___________
#   ____    /  _  \  ______  |   |_/  |_  /  _  \  |  |  |   |  ______\_   _____/
# _/ ___\  /  /_\  \ \____ \ |   |\   __\/  /_\  \ |  |  |   | /  ___/ |    __)_
# \  \___ /    |    \|  |_> >|   | |  | /    |    \|  |__|   | \___ \  |        \
#  \___  >\____|__  /|   __/ |___| |__| \____|__  /|____/|___|/____  >/_______  /
#      \/         \/ |__|                       \/                 \/         \/
# FIGMENTIZE: cApItAlIsE

"""
CaPiTaLiSaTiOn framework

The __main__ code is a simple demo. The serious CaPiTaLiSaTiOn is implemented
elsewhere, in b_eChO and b_cAt in my ~/bin.
"""

from random import random

from humandom import heads_tails

class BaSeCaPiTaLiSeR:
    """
    Base class to provide capitalisation.
    """
    def process(self, s):
        """
        Process a string into a string
        """
        return "".join(self._process(s))

class CaPiTaLiSeR(BaSeCaPiTaLiSeR):
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

class RAnDOMCApItALiseR(BaSeCaPiTaLiSeR):
    """
    Similar object that instead provides random capitalisation.
    """
    def _process(self, s):
        """
        Process an iterable, returning a generator of characters
        """
        for c in s:
            if c.isalpha():
                if random() < 0.5:
                    yield c.upper()
                else:
                    yield c.lower()
            else:
                yield c

class HumANdomcaPITalisEr(BaSeCaPiTaLiSeR):
    """
    Use humandom to get more aesthetically random capitalisation
    """
    def __init__(self):
        self.bitstream = heads_tails()

    def _process(self, s):
        """
        Process an iterable, returning a generator of characters
        """
        for c in s:
            if c.isalpha():
                if next(self.bitstream):
                    yield c.upper()
                else:
                    yield c.lower()
            else:
                yield c

if __name__ == "__main__":
    import sys
    cApItAlIsEr = CaPiTaLiSeR()
    with open(__file__, "r") as source:
        for line in source:
            sys.stdout.write(cApItAlIsEr.process(line))
