import sys
import re
import random
import time

from string import *
from math import *
from itertools import *
from functools import *
from collections import *
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
