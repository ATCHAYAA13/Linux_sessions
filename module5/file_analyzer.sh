#!/bin/bash

ERROR_LOG="errors.log"

error_exit() {
    echo "ERROR: $1" | tee -a "$ERROR_LOG" >&2
    exit 1
}

show_help() {
cat <<EOF
Usage: $0 [OPTIONS]
-d <directory>   Recursively search directory
-f <file>        Search file
-k <keyword>     Keyword
--help           Show help
EOF
}

recursive_search() {
    for i in "$1"/*; do
        if [[ -f "$i" ]] && grep -qi "$2" "$i"; then
            echo "Match found in: $i"
        elif [[ -d "$i" ]]; then
            recursive_search "$i" "$2"
        fi
    done
}

[[ $# -eq 0 ]] && error_exit "No arguments provided"

[[ "$1" == "--help" ]] && show_help && exit 0

while getopts ":d:f:k:" opt; do
    case $opt in
        d) DIR="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        k) KEY="$OPTARG" ;;
        *) error_exit "Invalid option" ;;
    esac
done

[[ -z "$KEY" ]] && error_exit "Keyword cannot be empty"

if [[ -n "$FILE" ]]; then
    [[ ! -f "$FILE" ]] && error_exit "File not found"
    grep -qi "$KEY" <<< "$(cat "$FILE")" && echo "Keyword found" || echo "Not found"
elif [[ -n "$DIR" ]]; then
    [[ ! -d "$DIR" ]] && error_exit "Directory not found"
    recursive_search "$DIR" "$KEY"
else
    error_exit "Use -d or -f"
fi

echo "Script: $0"
echo "Arguments: $@"
