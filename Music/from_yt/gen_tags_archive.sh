#!/usr/bin/env sh

set -eu

EXIF_TAGS="-Title -Artist -Genre -TrackNumber -Album -Composer"

get_tags() {
    filename="$1"
    filename_title="$2"
    echo "$filename"
    exiftool $EXIF_TAGS "$filename" > "$filename_title.txt"
}

for f in *.m4a; do
    get_tags "$f" "${f%.m4a}"
done
