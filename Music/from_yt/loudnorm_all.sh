#!/usr/bin/env sh

set -eu

echo "just use replaygain"
exit 1

do_loudnorm() {
    filename="$1"
    echo "$filename"
    outputbase1="${filename%.m4a}"
    outputbase="${outputbase1%_norm}_norm"
    if [ -f "$outputbase.m4a" ]; then
        echo "Already processed"
        return 0
    else
        ffmpeg -i "$filename" -filter:a loudnorm -vn "$outputbase.m4a"
    fi
}

for f in *.m4a; do
    do_loudnorm "$f"
done
