"""
Scraping lipsum text from the LaTeX package, viewed as a proxy for reliable
typography.
"""

import re
import sys

def clean_line(line):
    return re.sub("^\\s*([^%\n]*?)(?:\s*%[^\n]*?)?\n?$", r"\1", line)

def clean_file(file):
    return filter(None, map(clean_line, file))

def mangle_file(file):
    return re.sub("\s+", " ", " ".join(clean_file(file)))

def get_lipsum_pars(file):
    """
    This is a pretty hacky way to scrape a full language like LaTeX, but
    fortunately the files involved are basically glorified XML.
    """
    for par in re.finditer(r"\\NewLipsumPar\{\s*([^}]*?)\s*\}", mangle_file(file)):
        print(par.group(1))
        print()

if __name__ == "__main__":
    get_lipsum_pars(sys.stdin)
