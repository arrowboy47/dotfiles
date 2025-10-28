#!/bin/bash

# v1.0
# Closebox73
# Script to check total size and number of files in Trash

TRASH_DIR="$HOME/.local/share/Trash/files"

case "$1" in
	-s)
		# Total size in human-readable format
		du -hs "$TRASH_DIR" 2>/dev/null | awk '{print $1}'
		;;
	-c)
		# Count total files (including in subfolders)
		find "$TRASH_DIR" -type f 2>/dev/null | wc -l
		;;
	*)
		echo "Usage: $0 -s (size) | -c (count)"
		exit 1
		;;
esac

exit 0
