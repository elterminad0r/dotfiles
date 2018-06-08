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
###END

with open(__file__, "r") as setupfile:
    print("".join(map(">>> {}".format, takewhile(lambda ln: ln != "###END\n", setupfile))))

print("running {}".format(sys.executable))
