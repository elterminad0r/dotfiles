#!/usr/bin/env python3

# FIGMENTIZE: zalgo

"""
Making scary looking "zalgo" text.
"""

import sys

from random import gauss, choice

# from http://www.alanwood.net/unicode/combining_diacritical_marks.html

combining = [
    "\u0300", "\u0301", "\u0302", "\u0303", "\u0304", "\u0305", "\u0306",
    "\u0307", "\u0308", "\u0309", "\u030A", "\u030B", "\u030C", "\u030D",
    "\u030E", "\u030F", "\u0310", "\u0311", "\u0312", "\u0313", "\u0314",
    "\u0315", "\u0316", "\u0317", "\u0318", "\u0319", "\u031A", "\u031B",
    "\u031C", "\u031D", "\u031E", "\u031F", "\u0320", "\u0321", "\u0322",
    "\u0323", "\u0324", "\u0325", "\u0326", "\u0327", "\u0328", "\u0329",
    "\u032A", "\u032B", "\u032C", "\u032D", "\u032E", "\u032F", "\u0330",
    "\u0331", "\u0332", "\u0333", "\u0334", "\u0335", "\u0336", "\u0337",
    "\u0338", "\u0339", "\u033A", "\u033B", "\u033C", "\u033D", "\u033E",
    "\u033F", "\u0340", "\u0341", "\u0342", "\u0343", "\u0344", "\u0345",
    "\u0346", "\u0347", "\u0348", "\u0349", "\u034A", "\u034B", "\u034C",
    "\u034D", "\u034E", "\u034F", "\u0350", "\u0351", "\u0352", "\u0353",
    "\u0354", "\u0355", "\u0356", "\u0357", "\u0358", "\u0359", "\u035A",
    "\u035B", "\u035C", "\u035D", "\u035E", "\u035F", "\u0360", "\u0361",
    "\u0362", "\u0363", "\u0364", "\u0365", "\u0366", "\u0367", "\u0368",
    "\u0369", "\u036A", "\u036B", "\u036C", "\u036D", "\u036E", "\u036F"]

def zalgo(s, mean, sd):
    for c in s:
        yield c
        if c.isalnum():
            for _ in range(int(gauss(mean, sd))):
                yield choice(combining)

if __name__ == "__main__":
    for line in sys.stdin:
        sys.stdout.write("".join(zalgo(line, 10, 2)))
