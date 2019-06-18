#!/usr/bin/env sh

# Generate a muttrc to read locally stored mail. Should be given a sequence of
# directories to try and read mail from, in decreasing order of precedence.

set -eu

for maildir; do
    if [ -d "$maildir" ]; then
        echo "set folder=$maildir"
        echo "set mbox=+$USER"
        exit 0
    fi
done

>&2 echo "No suitable mailbox found in" "$@"
exit 1
