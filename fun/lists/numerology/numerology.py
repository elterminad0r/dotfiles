"""
Applying some techniques from numerical computation to generalise
64 / 16 = 6 * 4 / 1 * 6 = 4 / 1
"""

from collections import Counter
from itertools import combinations, groupby
from math import gcd

# TODO: optimisation (not just the Easter course)
# TODO: can 0 ever be interesting?
# TODO: still some double counting with repeated digits.
# TODO: really this is a sort of big tree, where sometimes we give redundant
#       information about edges. eg when we say all of 555 / 2553 = 55 / 253,
#       555 / 2553 = 5 / 23, 55 / 235 = 5 / 23.

def remove_dups(g):
    return (x for x, _ in groupby(g))

def _powercounter(ctr_l):
    if ctr_l:
        k, v = ctr_l.pop()
        for subc in _powercounter(ctr_l):
            subc.append(None)
            for i in range(v + 1):
                subc[-1] = (k, i)
                yield subc
            subc.pop()
        ctr_l.append((k, v))
    else:
        yield ctr_l

def powercounter(ctr):
    """
    Find all sub-counters of the Counter ctr. Returns these as a generator of
    references to a single list object, which is populated appropriately after
    successive yields.
    """
    return _powercounter(list(ctr.items()))

def cancel_with_mask(n_l, d, mask):
    mask_ind = d_ind = 0
    for n_d in n_l:
        if n_d != d:
            yield n_d
        else:
            if mask_ind < len(mask) and mask[mask_ind] == d_ind:
                mask_ind += 1
            else:
                yield d
            d_ind += 1

def _ways_to_cancel(n_l, n_digits, digits):
    if digits:
        d, occ = digits.pop()
        for cancel in _ways_to_cancel(n_l, n_digits, digits):
            for mask in combinations(range(n_digits[d]), occ):
                yield cancel_with_mask(cancel, d, mask)
        digits.append((d, occ))
    else:
        yield n_l

def ways_to_cancel(n, n_digits, digits):
    for n_c in _ways_to_cancel(str(n), n_digits, digits):
        val = 0
        for d in n_c:
            val *= 10
            val += int(d)
        yield val

def digits_cancel(a, b, a_digits, b_digits, cancel_digits):
    for a_c in remove_dups(ways_to_cancel(a, a_digits, list(cancel_digits))):
        for b_c in remove_dups(ways_to_cancel(b, b_digits, cancel_digits)):
            if b_c != 0 and a * b_c == b * a_c:
                if gcd(a_c, b_c) == 1:
                    print("p", end=" ")
                else:
                    print(" ", end=" ")
                print("{} / {} = {} / {}".format(a, b, a_c, b_c))

def simplifies(a, b):
    """
    Determine if a/b ∈ Frac(ℤ) admits a numerological simplification.
    """
    if gcd(a, b) > 1 and a % 10 != 0 and b % 10 != 0:
        a_digits = Counter(str(a))
        b_digits = Counter(str(b))
        a_b_intersect = a_digits & b_digits
        if b_digits != a_b_intersect != a_digits and sum(a_b_intersect.values()) > 0:
            for cancel_digits in powercounter(a_b_intersect):
                if sum(t[1] for t in cancel_digits) > 0:
                    if any(t[0] != "0" and t[1] > 0 for t in cancel_digits):
                        digits_cancel(a, b, a_digits, b_digits, cancel_digits)

for t in range(10000, 100000):
    for i in range(10, t // 2):
        simplifies(i, t - i)
