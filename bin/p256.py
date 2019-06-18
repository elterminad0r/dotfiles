#!/usr/bin/env python3

#         ________   .________  ________
# ______  \_____  \  |   ____/ /  _____/
# \____ \  /  ____/  |____  \ /   __  \
# |  |_> >/       \  /       \\  |__\  \
# |   __/ \_______ \/______  / \_____  /
# |__|            \/       \/        \/
# FIGMENTIZE: p256

"""
This is a script that draws some colours on the terminal using ANSI escape
codes. It (hopefully) produces the same output as Tom Hale's solution at
https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal/821163#821163
"""

for i in range(8):
    if i == 0:
        print("\x1b[4{0}m{0:3}\x1b[0m".format(i), end="")
    else:
        print(" \x1b[4{0};30m{0:3}\x1b[0m".format(i), end="")

for i in range(8, 16):
    print(" \x1b[10{};30m{:3}\x1b[0m".format(i - 8, i), end="")

print()
print()

for row in range(2):
    for y in range(6):
        for col in range(3):
            for x in range(6):
                i = 16 + (row * 3 + col) * 6 ** 2 + y * 6 + x
                end = "" if x == 5 and col == 2 else " "
                if y < 3:
                    print("\x1b[48;5;{0}m{0:3}\x1b[0m".format(i), end=end)
                else:
                    print("\x1b[48;5;{0}m\x1b[38;5;0m{0:3}\x1b[0m".format(i),
                            end=end)
            if col != 2:
                print("  ", end="")
        print()
    print()

for x in range(12):
    i = 232 + x
    end = "" if x == 11 else " "
    print("\x1b[48;5;{0}m{0:3}\x1b[0m".format(i), end=end)
print()

for x in range(12):
    i = 244 + x
    end = "" if x == 11 else " "
    print("\x1b[48;5;{0}m\x1b[38;5;0m{0:3}\x1b[0m".format(i), end=end)
print()
