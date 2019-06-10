"""
Random facilities that try to discourage long consecutive runs.
"""

from random import random
from math import exp

def heads_tails(k=0.3):
    """
    Yield "heads" or "coins", a generator of 0s and 1s.

    The k-factor argument increases or decreases the penalty for runs. If you
    make it too close to 0, this generator effectively becomes a random sequence
    of 1s and 0s. If you make it too high, the generator effectively alternates
    between 1s and 0s, spitting out pairs or singletons. If you make k
    negative, God help you.

    0.3 seems to be a fairly sensible default - this gets a fair number of runs
    of 3, still. See the output of the __main__ section.
    """
    run = 0
    prev = 0
    while True:
        if random() < 0.5 * exp(-k * run):
            yield prev
            run += 1
        else:
            prev ^= 1
            yield prev
            run = 0

if __name__ == "__main__":
    from itertools import islice
    for _k in range(20):
        k = 0.1 * _k
        print(f"k={k:4.2f}: {''.join(' @'[i] for i in islice(heads_tails(k), 50))}")