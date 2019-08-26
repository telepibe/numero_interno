#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

# $search defaults to empty string if its not defined.
search=${1:-}

if [[ -z $search ]]; then
	echo "Uso: $0 nombre|interno"
	exit 1
fi

actual_dir="$( dirname "$( readlink -f "$0")")"

# Loads $tels array with lines of file. Keeps newlines.
mapfile tels <"${actual_dir}/db.txt"

# $search in caps and captures extension number (not needed actually)
regex=".*${search^^}.*([0-9]{4})"

declare -i match=0
for interno in "${tels[@]}"; do
	if [[ ${interno^^} =~ $regex ]]; then
	 	echo "${BASH_REMATCH[0]}"
		match+=1
	fi 
done

if (( match==0 )); then
	exit 1
fi