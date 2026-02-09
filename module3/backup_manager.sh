#!/bin/bash

#Check arguments
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <extension>"
    exit 1
fi

SRC="$1"
DEST="$2"
EXT="$3"

#Create backup directory
if [ ! -d "$DEST" ]; then
    mkdir "$DEST" || { echo "Failed to create backup directory"; exit 1; }
fi

#Globbing, array
FILES=("$SRC"/*"$EXT")

#Check if files exist
if [ ! -e "${FILES[0]}" ]; then
    echo "No files with extension $EXT found."
    exit 0
fi

export BACKUP_COUNT=0
TOTAL_SIZE=0

echo "Files to be backed up:"
for f in "${FILES[@]}"; do
    size=$(stat -c %s "$f")
    echo "$(basename "$f") - $size bytes"
done

#Backup process
for f in "${FILES[@]}"; do
    fname=$(basename "$f")
    size=$(stat -c %s "$f")

    if [ ! -e "$DEST/$fname" ] || [ "$f" -nt "$DEST/$fname" ]; then
        cp "$f" "$DEST/"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
        TOTAL_SIZE=$((TOTAL_SIZE + size))
    fi
done

#Report
REPORT="$DEST/backup_report.log"
{
    echo "Backup Summary"
    echo "--------------"
    echo "Total files backed up: $BACKUP_COUNT"
    echo "Total size backed up: $TOTAL_SIZE bytes"
    echo "Backup directory: $DEST"
} > "$REPORT"

echo "Backup completed. Report saved at $REPORT"
