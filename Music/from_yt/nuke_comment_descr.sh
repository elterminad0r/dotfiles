#!/usr/bin/env sh

set -eu

had_args=0
for f; do
    had_args=1
    exiftool -comment= -description= "$f"
done

if [ "$had_args" = 0 ]; then
    for f in *.m4a; do
        exiftool -comment= -description= "$f"
    done
fi
