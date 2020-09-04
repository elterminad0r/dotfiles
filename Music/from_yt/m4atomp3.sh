#!/usr/bin/env sh

set -eu

for f in *.m4a; do
    if ! [ -f "${f%.m4a}.mp3" ]; then
        exiftool -comment= -description= "$f"
        ffmpeg -i "$f" -codec:v copy -codec:a libmp3lame -q:a 2 "${f%.m4a}.mp3"
    fi
done
