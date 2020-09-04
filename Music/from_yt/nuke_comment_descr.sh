#!/usr/bin/env sh

set -eu

for f in *.m4a; do
    exiftool -comment= -description= "$f"
done
