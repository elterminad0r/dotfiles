#!/usr/bin/env sh

set -eu

for f in *.mp3 *.m4a; do
    loudgain "$f"
done
