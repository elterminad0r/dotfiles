# .__                                         __   .__
# |__|______  ___.__.         _____  _____  _/  |_ |  |__    ______
# |  |\____ \<   |  | ______ /     \ \__  \ \   __\|  |  \  /  ___/
# |  ||  |_> >\___  |/_____/|  Y Y  \ / __ \_|  |  |   Y  \ \___ \
# |__||   __/ / ____|       |__|_|  /(____  /|__|  |___|  //____  >
#     |__|    \/                  \/      \/            \/      \/
# FIGMENTIZE: ipy-maths

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

pow = __builtins__["pow"]
###END

with open(__file__, "r") as setupfile:
    print("".join(map(">>> {}".format, takewhile(lambda ln: ln != "###END\n", setupfile))))

print("running on {}".format(sys.executable))

print("reminder from your friendly neighbourhood spiderman to use sage instead")
