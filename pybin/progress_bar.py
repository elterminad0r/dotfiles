"""
Facilities for drawing a progress bar, as this is something I find myself
writing over and over again, when writing programs on the command line that take
time to execute.
"""

ASCII_PROG_CHARS = ">", "=", " "
UNICODE_PROG_CHARS = "▏▎▍▌▋▊▉█", "█", " "

def format_bar(width, fraction, unicode=None, prog_chars=None):
    """
    Format just the actual progress bar given the characters, width, and
    percentage completion.

    prog_chars should be a tuple of a linear progression of sub-characters for a
    partially filled character, the character to draw a fully filled in
    character with, and the character to fill the rest of the bar with.

    Optionally, you can leave it as None and pass in `unicode` as truthy or
    falsey to get default values for ascii or unicode-supporting terminals.
    """
    if prog_chars is None:
        if unicode is not None:
            prog_chars = UNICODE_PROG_CHARS if unicode else ASCII_PROG_CHARS
        else:
            raise ValueError("Need either to pass unicode, or pass characters")
    progression, block, fillchar = prog_chars
    integral, fractional = divmod(width * fraction, 1)
    return "{}{}".format(block * int(integral),
                         progression[int(len(progression) * fractional)]
                            if fractional else "").ljust(width, fillchar)

if __name__ == "__main__":
    import sys
    import time
    TOTAL = 1000
    for i in range(TOTAL + 1):
        time.sleep(0.01)
        print("\r[{}]".format(format_bar(78, i / TOTAL, unicode=True)),
              end="", file=sys.stderr, flush=True)
    print(file=sys.stderr)
