#!/usr/bin/env python3

"""
This is a script that draws some colours on the terminal using ANSI escape
codes. It (hopefully) produces the same output as Tom Hale's solution at
https://askubuntu.com/questions/821157/print-a-256-color-test-pattern-in-the-terminal/821163#821163
"""

for i in range(8):
    if i == 0:
        print(f"\x1b[4{i}m{i:3}\x1b[0m", end="")
    else:
        print(f" \x1b[4{i};30m{i:3}\x1b[0m", end="")

for i in range(8, 16):
    print(f" \x1b[10{i - 8};30m{i:3}\x1b[0m", end="")

print()
print()

for row in range(2):
    for y in range(6):
        for col in range(3):
            for x in range(6):
                i = 16 + (row * 3 + col) * 6 ** 2 + y * 6 + x
                end = "" if x == 5 and col == 2 else " "
                if y < 3:
                    print(f"\x1b[48;5;{i}m{i:3}\x1b[0m", end=end)
                else:
                    print(f"\x1b[48;5;{i}m\x1b[38;5;0m{i:3}\x1b[0m", end=end)
            print("  ", end="")
        print()
    print()

for x in range(12):
    i = 232 + x
    print(f"{'' if x == 0 else ' '}\x1b[48;5;{i}m{i:3}\x1b[0m", end="")
print()

for x in range(12):
    i = 244 + x
    print(f"{'' if x == 0 else ' '}\x1b[48;5;{i}m\x1b[38;5;0m{i:3}\x1b[0m", end="")
print()
