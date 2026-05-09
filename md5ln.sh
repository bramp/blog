#!/bin/bash
set -e

src=$1
extension="${src#*.}"
filename="${src%%.*}"

# Cross-platform MD5
if command -v md5 >/dev/null 2>&1; then
    hash=$(md5q "$src" 2>/dev/null || md5 -q "$src")
elif command -v md5sum >/dev/null 2>&1; then
    hash=$(md5sum "$src" | awk '{ print $1 }')
else
    echo "Error: md5 or md5sum not found"
    exit 1
fi

dest=$filename.$hash.$extension

echo "Copying $src to $dest"
cp "$src" "$dest"
