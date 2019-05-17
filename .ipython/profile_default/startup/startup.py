# FIGMENTIZE: ipython
#  _                _    _
# (_) _ __   _   _ | |_ | |__    ___   _ __
# | || '_ \ | | | || __|| '_ \  / _ \ | '_ \
# | || |_) || |_| || |_ | | | || (_) || | | |
# |_|| .__/  \__, | \__||_| |_| \___/ |_| |_|
#    |_|     |___/

import sys
import re
import random
import time

import string
from string import *
import math
from math import *
import itertools
from itertools import *
import functools
from functools import *
import collections
from collections import *
import operator
from operator import *
###END

with open(__file__, "r") as setupfile:
    print("".join(map(">>> {}".format, takewhile(lambda ln: ln != "###END\n", setupfile))))

print("running {}".format(sys.executable))
