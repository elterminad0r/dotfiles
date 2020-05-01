#!/usr/bin/env python3

# TODO: Write backup protocol
# TODO: docstrings

#    ____  .__                  .___
#   / ___\ |  |__    _____    __| _/______  ______
#  / /_/  >|  |  \  /     \  / __ | \____ \ \____ \
#  \___  / |   Y  \|  Y Y  \/ /_/ | |  |_> >|  |_> >
# /_____/  |___|  /|__|_|  /\____ | |   __/ |   __/
#               \/       \/      \/ |__|    |__|
# FIGMENTIZE: ghmdpp

"""
GitHub MarkDown Pretty Printer.

Currently a program that acts on a file containing a single Markdown table
(obeying some suitable assumptions, in accordance with how I use tables) and
aligns it.
"""

import enum

from itertools import zip_longest

import smartparse as argparse

# TODO: what if there's eg `|` or \| in a cell
def split_line(line):
    """
    Split a line of markdown into cells
    """
    return map(str.strip, line.strip().strip("|").strip().split("|"))

class TableAlignment(enum.Enum):
    LEFT = enum.auto()
    CENTRE = enum.auto()
    RIGHT = enum.auto()

ALIGNMENTS_TO_FMT = {
    TableAlignment.LEFT: "<",
    TableAlignment.CENTRE: "^",
    TableAlignment.RIGHT: ">"}

def make_alignment_string(alignment, width):
    if width < 3:
        raise ValueError("width too small")
    if alignment == TableAlignment.LEFT:
        return ":{} ".format("-" * width)
    if alignment == TableAlignment.RIGHT:
        return " {}:".format("-" * width)
    return ":{}:".format("-" * width)

def parse_table_alignment(alignment):
    if not set(alignment).issubset({":", "-"}):
        raise ValueError("Unrecognised alignment characters: {}"
                .format(set(alignment) - {":", "-"}))
    if len(alignment) < 3:
        raise ValueError("alignment code too short: {!r}".format(alignment))
    if alignment[0] == ":":
        if alignment[-1] == ":":
            return TableAlignment.CENTRE
        return TableAlignment.LEFT
    if alignment[-1] == ":":
        return TableAlignment.RIGHT
    return TableAlignment.LEFT

def fmt_table_row(row, alignments, widths):
    if len(widths) < len(row):
        raise ValueError("More cells than widths")
    if len(alignments) < len(row):
        raise ValueError("More cells than alignments")
    if len(widths) < len(alignments):
        raise ValueError("More alignments than widths")
    return "|{}|".format(
            "|".join(
                " {:{}{}} ".format(
                        cell, ALIGNMENTS_TO_FMT[alignment], width)
                    for cell, (alignment, width) in
                        zip_longest(
                            row,
                            zip_longest(alignments, widths,
                                        fillvalue=TableAlignment.LEFT),
                            fillvalue="")))

def fmt_table_alignments(alignments, widths):
    if len(widths) < len(alignments):
        raise ValueError("More alignments than widths")
    return "|{}|".format(
            "|".join(
                "{}".format(
                        make_alignment_string(alignment, width))
                    for alignment, width in
                        zip_longest(alignments, widths,
                                    fillvalue=TableAlignment.LEFT)))

class MarkdownTable:
    def __init__(self, lines):
        try:
            head, alignments, *body = map(str.strip, lines)
        except IndexError as e:
            raise ValueError("Need table head and alignment") from e
        self.head = list(split_line(head))
        self.alignments = list(map(parse_table_alignment, split_line(alignments)))
        self.body = [list(split_line(line)) for line in body]

    def _fmt(self):
        head_and_body = self.body + [self.head]
        most_cells = max(map(len, head_and_body))
        max_widths = [max(3, max(len(line[i] if i < len(line) else "")
                                     for line in head_and_body))
                          for i in range(most_cells)]
        yield fmt_table_row(self.head,
                            [TableAlignment.LEFT] * len(self.head),
                            max_widths)
        yield fmt_table_alignments(self.alignments, max_widths)
        yield from (fmt_table_row(line, self.alignments, max_widths)
                for line in self.body)

    def fmt(self):
        return "\n".join(self._fmt())

def get_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
            "input", type=argparse.FileType("r"), default="-", nargs="?",
            help="Input file to be prettified")
    parser.add_argument(
            "output", type=argparse.FileType("w"), default="-", nargs="?",
            help="Output file")
    return parser.parse_args()

def main(args):
    with args.input as input_file:
        lines = list(input_file)
    table = MarkdownTable(lines)
    with args.output as output_file:
        for line in table._fmt():
            print(line, file=output_file)

if __name__ == "__main__":
    main(get_args())
