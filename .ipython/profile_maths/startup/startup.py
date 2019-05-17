# FIGMENTIZE: ipy-maths
#  _                                         _    _
# (_) _ __   _   _         _ __ ___    __ _ | |_ | |__   ___
# | || '_ \ | | | | _____ | '_ ` _ \  / _` || __|| '_ \ / __|
# | || |_) || |_| ||_____|| | | | | || (_| || |_ | | | |\__ \
# |_|| .__/  \__, |       |_| |_| |_| \__,_| \__||_| |_||___/
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

import mpmath
import scipy
import numpy as np

from sympy import init_session
init_session()
###END

with open(__file__, "r") as setupfile:
    print("".join(map(">>> {}".format, takewhile(lambda ln: ln != "###END\n", setupfile))))

print("running on {}".format(sys.executable))

print("reminder from your friendly neighbourhood spiderman to use sage instead")
