#!/bin/bash

for ID in 27011128 27011134; do
    PAGE=1
    while true; do
        TMPFILE=$(mktemp)
        curl -s "https://api.figshare.com/v2/articles/${ID}/files?page_size=100&page=${PAGE}" \
            | python3 -c "
import json,sys
data=json.load(sys.stdin)
if not data: sys.exit(1)
for f in data: print(f['download_url']); print(f['name'])
" > "$TMPFILE" 2>/dev/null || { rm -f "$TMPFILE"; break; }
        [ -s "$TMPFILE" ] || { rm -f "$TMPFILE"; break; }
        while read -r url && read -r name; do
            wget -q --show-progress -c "$url" -O "$name"
        done < "$TMPFILE"
        rm -f "$TMPFILE"
        PAGE=$((PAGE+1))
    done
done
