#!/usr/bin/env python3

# vim: ft=python

#                  ____                                .__
# _____  _______  / ___\ ______ _____  _______   ______|  |__
# \__  \ \_  __ \/ /_/  >\____ \\__  \ \_  __ \ /  ___/|  |  \
#  / __ \_|  | \/\___  / |  |_> >/ __ \_|  | \/ \___ \ |   Y  \
# (____  /|__|  /_____/  |   __/(____  /|__| /\/____  >|___|  /
#      \/                |__|        \/      \/     \/      \/
# FIGMENTIZE: argpar.sh

"""
There's no reason we can't have nice things! Have you ever wanted to use long
options in a shell script? To set default values, read arguments into arrays,
automatically display and format help and usage texts? Enter argpar.sh!

Exposing Python's argparse to shell scripts. Basically I just cannot let go of
Python's nice, long option, type checking, narg-supporting argument parsing, so
I have created this monstrosity to ease my pain.

I think the filename extension .sh is warranted, because this program generates
shell code to be eval'd, so really it's only a single stage of indirection away
from shell code. Also it's just too good of a name to waste. Anyway it's only a
symbolic link, don't get too worked up about it (you could even change it !!!)

Single-valued arguments are formatted as variables. List-valued arguments are
formatted as arrays, except for the destination "passthrough", which is passed
to 'set --' (which means you can use it for POSIX shell scripts).

Should provide code modifying the ArgumentParser named `parser` on stdin. Any
positional arguments are treated as arguments to parse. Note that you can modify
the parser's description simply by setting the description property according to
your wishes.

Obviously this allows execution of arbitrary Python code, but you could do that
already if you're writing a shell script. Basically don't do anything ridiculous
like passing untrusted user input to this script. It's probably also a little
iffy to make you eval things, but that's the way it's gotta be.

Some similarities to argparse.bash:
https://github.com/nhoffman/argparse-bash/blob/master/argparse.bash

For an example of how to use it, see vimack.
"""

import sys
import re
import smartparse as argparse

def get_args():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--prefix", default="arg_",
            help="Prefix to attach to the outputted shell variables")
    parser.add_argument("name", help="Program name to display")
    parser.add_argument("arguments", nargs="*", default=[],
            help="Arguments to be passed on to the parser")
    return parser.parse_args()

def shell_quote(s):
    """
    shlex.quote on steroids
    Basically I don't trust zsh to be safe on anything, so I just quote
    everything. Not worried about prettiness here because everything should be
    happening at a runtime level anyway, not being typed by a user.
    """
    # Regular expression keeps the size of the output in some imitation of sane.
    return "'{}'".format(re.sub("'+", "'\"\\g<0>\"'", str(s)))

class ErrorHelpAction(argparse._HelpAction):
    """
    Help action that causes a non-zero exit code, so the caller knows not to
    proceed.
    """
    def __call__(self, parser, namespace, values, option_string=None):
        parser.print_help()
        parser.exit(3)

def caller_argparse(mod_code, args, prog):
    """
    Apply a caller's argument parsing to the caller's arguments
    """
    # Add our own help so we can use a non-zero exit code
    parser = argparse.ArgumentParser(prog=prog, add_help=False)
    parser.add_argument("-h", "--help", action=ErrorHelpAction,
            help="show this help message and exit")
    exec(mod_code)
    caller_args = parser.parse_args(args)
    return caller_args

def expose(args, prefix):
    """
    Expose a set of arguments as shell variable definitions
    """
    for var, val in args.__dict__.items():
        if isinstance(val, list):
            if var == "passthrough":
                print("set -- {}".format(" ".join(map(shell_quote, val))))
            else:
                print("{}{}=( {} )".format(prefix, var,
                                           " ".join(map(shell_quote, val))))
        else:
            if val is not None:
                print("{}{}={}".format(prefix, var, shell_quote(val)))

def argparsh():
    """
    Tie it all together
    """
    my_args = get_args()
    mod_code = sys.stdin.read()
    caller_args = caller_argparse(mod_code, my_args.arguments, my_args.name)
    expose(caller_args, my_args.prefix)

if __name__ == "__main__":
    argparsh()
