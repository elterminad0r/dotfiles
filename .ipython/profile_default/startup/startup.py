# .__                  __   .__
# |__|______  ___.__._/  |_ |  |__    ____    ____
# |  |\____ \<   |  |\   __\|  |  \  /  _ \  /    \
# |  ||  |_> >\___  | |  |  |   Y  \(  <_> )|   |  \
# |__||   __/ / ____| |__|  |___|  / \____/ |___|  /
#     |__|    \/                 \/              \/
# FIGMENTIZE: ipython

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

pow = __builtins__["pow"]
###END

with open(__file__, "r") as setupfile:
    print("".join(map(">>> {}".format, takewhile(lambda ln: ln != "###END\n", setupfile))))

print("running {}".format(sys.executable))
