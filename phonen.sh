#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# $search defaults to empty string if its not defined.
search=${1:-}

if [[ -z $search ]]; then
	echo "Uso: $0 nombre|interno"
	exit 1
fi

# Loads $tels array with lines of file. Keeps newlines.
mapfile tels <db.txt

# $search in caps and captures extension number (not needed actually)
regex=".*${search^^}.*([0-9]{4})"

# ${BASH_REMATCH[1]} has extension number
for interno in "${tels[@]}"; do
	[[ ${interno^^} =~ $regex ]] && echo "${BASH_REMATCH[0]}"
done